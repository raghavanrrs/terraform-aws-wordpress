resource "random_password" "db_password" {
  length  = var.db_password_length
  special = false

  keepers = {
    # Generate a new id each time we switch to a new AMI id
    version = var.db_password_version
  }
}

resource "aws_kms_key" "kms" {
  description              = "KMS Key used to encrypt ${title(var.app)} ${title(var.env)} related resources"
  deletion_window_in_days  = var.deletion_window_in_days
  policy                   = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "KeyPolicy",
    "Statement": [
      {
        "Sid": "Full permissions for account hosting the key",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "Delegate use of key to selected accounts",
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": [
            "kms:Decrypt",
            "kms:DescribeKey",
            "kms:Encrypt",
            "kms:GenerateDataKey*",
            "kms:ReEncrypt*"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
  enable_key_rotation      = var.enable_key_rotation
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  tags = merge(
    {
      "Name" = "${var.org}-${var.app}-${var.env}kms"
    },
    var.tags
  )
}

resource "aws_kms_alias" "keyalias" {
  name          = format("%s/%s-%s-%s", "alias", var.org, var.env, var.app)
  target_key_id = aws_kms_key.kms.key_id
}

resource "aws_efs_file_system" "efs" {
  creation_token = "${var.org}-${var.app}-${var.env}"
  encrypted      = true
  kms_key_id     = aws_kms_key.kms.arn
  tags           = var.tags
}

resource "aws_security_group" "efs" {
  name        = "${var.org}-${var.app}-${var.env}-efs"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-efs"
  }
}

resource "aws_efs_mount_target" "efs" {
  count           = length(aws_subnet.private[*].id)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private[count.index].id
  depends_on      = [aws_subnet.private]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "efs" {
  for_each       = var.root_directory
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    gid = try(each.value.gid, 33)
    uid = try(each.value.uid, 33)
  }

  root_directory {
    path = each.value.path
    creation_info {
      owner_gid   = try(each.value.owner_gid, 33)
      owner_uid   = try(each.value.owner_uid, 33)
      permissions = try(each.value.permissions, 755)
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = format("%s/%s/%s", var.org, var.app, var.env)
  retention_in_days = var.log_retention
  kms_key_id        = aws_kms_key.kms.arn
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "logs" {
  name           = var.app
  log_group_name = aws_cloudwatch_log_group.logs.name
}

resource "aws_ecs_cluster" "ecs" {
  name = format("%s-%s-%s-cluster", var.org, var.app, var.env)
  tags = var.tags
}

resource "aws_ecs_task_definition" "app" {
  family     = format("%s-%s-%s", var.org, var.app, var.env)
  depends_on = [null_resource.build_and_push_image]
  container_definitions = jsonencode(
    [
      {
        "name" : "${format("%s-%s-%s", var.org, var.app, var.env)}",
        "image" : "${aws_ecr_repository.app.repository_url}:${var.org}-${var.app}-${var.env}-${aws_ssm_parameter.version.version}",
        "portMappings" : [
          {
            "containerPort" : 80,
            "protocol" : "tcp"
          }
        ],
        "command" : [
          "wp plugin install offload-media-cloud-storage --activate"
        ]
        "secrets" : [
          {
            "name" : "WORDPRESS_DATABASE_PASSWORD",
            "valueFrom" : "${aws_secretsmanager_secret.secrets.arn}:WORDPRESS_DB_PASSWORD::"
          },
          {
            "name" : "WORDPRESS_DATABASE_USER",
            "valueFrom" : "${aws_secretsmanager_secret.secrets.arn}:WORDPRESS_DB_USER::"
          },
          {
            "name" : "WORDPRESS_DATABASE_NAME",
            "valueFrom" : "${aws_secretsmanager_secret.secrets.arn}:WORDPRESS_DB_NAME::"
          },
          {
            "name" : "WORDPRESS_DATABASE_HOST",
            "valueFrom" : "${aws_secretsmanager_secret.secrets.arn}:WORDPRESS_DB_HOST::"
          },
        ],
        "environment" : [
          {
            "name" : "WORDPRESS_PLUGINS",
            "value" : "${local.plugins}"
          },
          {
            "name" : "MEDIA_S3_BUCKET_NAME"
            "value" : "${aws_s3_bucket.media_bucket.id}"
          }
        ],
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : "${aws_cloudwatch_log_group.logs.name}",
            "awslogs-region" : "${data.aws_region.current.name}",
            "awslogs-stream-prefix" : var.app
          }
        },
        "mountPoints" : [
          {
            "readOnly" : false,
            "containerPath" : "/var/www/html/wp-content/themes",
            "sourceVolume" : "efs-themes"
          },
          {
            "readOnly" : false,
            "containerPath" : "/var/www/html/wp-content/plugins",
            "sourceVolume" : "efs-plugins"
          }
        ]
      }
  ])
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  #task_role_arn = aws_iam_role.service.arn

  dynamic "volume" {
    for_each = var.root_directory
    content {
      name = volume.key
      efs_volume_configuration {
        file_system_id     = aws_efs_file_system.efs.id
        root_directory     = "/"
        transit_encryption = "ENABLED"
        authorization_config {
          access_point_id = aws_efs_access_point.efs[volume.key].id
        }
      }
    }
  }

  tags = var.tags
}

resource "aws_ecs_service" "service" {
  name             = var.app
  cluster          = aws_ecs_cluster.ecs.arn
  task_definition  = aws_ecs_task_definition.app.arn
  desired_count    = var.ecs_service_desired_count
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  propagate_tags   = "SERVICE"
  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.alb.arn
    container_name   = format("%s-%s-%s", var.org, var.app, var.env)
    container_port   = var.container_port
  }
  tags = var.tags
}

resource "aws_security_group" "alb" {
  name        = "${var.org}-${var.app}-${var.env}-alb"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-alb"
  }
}

resource "aws_security_group" "ecs" {
  name        = "${var.org}-${var.app}-${var.env}-ecs"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    cidr_blocks = var.private_subnets
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-ecs"
  }
}

resource "aws_lb" "alb" {
  name               = "${var.org}-${var.app}-${var.env}-alb"
  internal           = var.lb_internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id
  tags               = var.tags
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.container_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}

resource "aws_lb_target_group" "alb" {
  name        = "${var.org}-${var.app}-${var.env}-http"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  health_check {
    matcher = "200-499"
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }
  tags = var.tags
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.org}_${var.app}_${var.env}_db_subnet_group"
  subnet_ids = aws_subnet.db.*.id
  tags       = var.tags
}

locals {
  rds_cluster_engine_version = var.rds_cluster_engine_version == "" ? data.aws_rds_engine_version.rds_engine_version.version : var.rds_cluster_engine_version
  plugins                    = join(",", var.plugins)
  sha                        = sha1("${path.module}/src/Dockerfile")
}

resource "aws_security_group" "rds" {
  name        = "${var.org}-${var.app}-${var.env}-rds"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-rds"
  }
}

resource "aws_rds_cluster" "app" {
  cluster_identifier              = format("%s-%s-%s-db-cluster", var.org, var.app, var.env)
  backup_retention_period         = var.rds_cluster_backup_retention_period
  copy_tags_to_snapshot           = true
  database_name                   = var.app
  port                            = var.db_port
  db_subnet_group_name            = aws_db_subnet_group.db.name
  deletion_protection             = var.rds_cluster_deletion_protection
  enabled_cloudwatch_logs_exports = var.rds_cluster_enable_cloudwatch_logs_export
  engine_version                  = local.rds_cluster_engine_version
  engine                          = "aurora-mysql"
  final_snapshot_identifier       = format("%s-%s-%s-db-cluster-final", var.org, var.app, var.env)
  kms_key_id                      = aws_kms_key.kms.arn
  master_password                 = random_password.db_password.result
  master_username                 = var.rds_cluster_master_username
  preferred_backup_window         = var.rds_cluster_preferred_backup_window
  preferred_maintenance_window    = var.rds_cluster_preferred_maintenance_window
  storage_encrypted               = true
  skip_final_snapshot             = var.rds_cluster_skip_final_snapshot
  vpc_security_group_ids          = [aws_security_group.rds.id]
  tags                            = var.tags
}

resource "aws_rds_cluster_instance" "app" {
  count                = var.rds_cluster_instance_count
  identifier           = join("-", [aws_rds_cluster.app.cluster_identifier, count.index + 1])
  cluster_identifier   = aws_rds_cluster.app.id
  engine               = aws_rds_cluster.app.engine
  engine_version       = aws_rds_cluster.app.engine_version
  instance_class       = var.rds_cluster_instance_instance_class
  db_subnet_group_name = aws_db_subnet_group.db.name

  tags = var.tags
}

resource "aws_secretsmanager_secret" "secrets" {
  name                    = format("%s/%s/%s", var.org, var.env, var.app)
  description             = "Secrets for ECS ${title(var.app)} ${title(var.env)}."
  kms_key_id              = aws_kms_key.kms.id
  tags                    = var.tags
  recovery_window_in_days = 0 ## not a very good practice but for the purpose of rush testing
}


resource "aws_secretsmanager_secret_version" "secrets" {
  secret_id = aws_secretsmanager_secret.secrets.id
  secret_string = jsonencode({
    WORDPRESS_DB_HOST     = aws_rds_cluster.app.endpoint
    WORDPRESS_DB_USER     = "${var.org}-${var.app}-${var.env}-dbuser"
    WORDPRESS_DB_PASSWORD = random_password.db_password.result
    WORDPRESS_DB_NAME     = "${var.org}${var.app}${var.env}"
  })
}

resource "aws_s3_bucket" "media_bucket" {
  bucket = format("%s-%s-%s", var.org, var.env, var.app)

  tags = var.tags
}

resource "aws_ecr_repository" "app" {
  name                 = var.app
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "build_and_push_image" {
  triggers = {
    build_trigger = var.always_run ? timestamp() : filesha1("${path.module}/src/Dockerfile")
  }

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.app.repository_url}:${var.org}-${var.app}-${var.env}-${aws_ssm_parameter.version.version} .  -f ${path.module}/src/Dockerfile && aws ecr get-login-password --region ${data.aws_region.current.name} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com && docker push ${aws_ecr_repository.app.repository_url}:${var.org}-${var.app}-${var.env}-${aws_ssm_parameter.version.version}"
  }
}


resource "aws_ssm_parameter" "version" {
  name  = format("/%s/%s/%s/version", var.org, var.app, var.env)
  type  = "String"
  value = format("%s-%s", var.wordpress_image, substr(local.sha, 0, 8))
}