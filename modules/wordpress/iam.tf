data "aws_iam_policy_document" "ecs_task_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    effect    = "Allow"
    resources = [aws_secretsmanager_secret.secrets.arn]
  }
  statement {
    actions   = ["kms:Decrypt"]
    effect    = "Allow"
    resources = [aws_kms_key.kms.arn]
  }
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
    effect    = "Allow"
    resources = formatlist("%s/*", [aws_s3_bucket.media_bucket.arn])
  }
  statement {
    actions = [
      "s3:ListAllMyBuckets"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetBucketOwnershipControls",
      "s3:PutBucketOwnershipControls",
      "s3:CreateBucket",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    effect    = "Allow"
    resources = [aws_s3_bucket.media_bucket.arn]
  }
  statement {
    actions   = ["ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.app}TaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_trust.json
}

resource "aws_iam_policy" "ecs_task_policy" {
  name   = "${var.app}TaskPolicy"
  policy = data.aws_iam_policy_document.ecs_task_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_role_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_policy.arn
}


# data "aws_iam_policy_document" "service_assume" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["ecs.amazonaws.com"]
#     }
#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "service" {

#   name        = "${var.app}ServiceRole"

#   assume_role_policy    = data.aws_iam_policy_document.service_assume.json
#   force_detach_policies = true

#   tags = var.tags
# }

# data "aws_iam_policy_document" "service" {

#   statement {
#     sid       = "ECSService"
#     resources = ["*"]

#     actions = [
#       "ec2:Describe*",
#       "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
#       "elasticloadbalancing:DeregisterTargets",
#       "elasticloadbalancing:Describe*",
#       "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
#       "elasticloadbalancing:RegisterTargets"
#     ]
#   }

# }

# resource "aws_iam_policy" "service" {

#   name        = "${var.app}ServiceRolePolicy"
#   description = "ECS service policy that allows Amazon ECS to make calls to your load balancer on your behalf"
#   policy      = data.aws_iam_policy_document.service.json

#   tags = var.tags
# }

# resource "aws_iam_role_policy_attachment" "service" {

#   role       = aws_iam_role.service.name
#   policy_arn = aws_iam_policy.service.arn
# }