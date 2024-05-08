<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.8.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | 3.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_subnet_group.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_ecr_repository.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_efs_access_point.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_policy.ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_kms_alias.keyalias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_rds_cluster.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_route_table.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.media_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_secretsmanager_secret.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_subnet.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [null_resource.build_and_push_image](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.az](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecr_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_authorization_token) | data source |
| [aws_iam_policy_document.ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_rds_engine_version.rds_engine_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_always_run"></a> [always\_run](#input\_always\_run) | n/a | `bool` | `false` | no |
| <a name="input_app"></a> [app](#input\_app) | [REQUIRED] Application name | `string` | n/a | yes |
| <a name="input_azs"></a> [azs](#input\_azs) | [REQUIRED] List of AZ | `list(string)` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | n/a | `number` | `80` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | Number of CPU units reserved for the container in powers of 2 | `string` | `"1024"` | no |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | [OPTIONAL] Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | [REQUIRED] List of DB subnets. | `list(string)` | n/a | yes |
| <a name="input_db_engine"></a> [db\_engine](#input\_db\_engine) | n/a | `string` | `"aurora-mysql"` | no |
| <a name="input_db_network_acl_egress"></a> [db\_network\_acl\_egress](#input\_db\_network\_acl\_egress) | Egress network ACL rules | `list(map(string))` | `[]` | no |
| <a name="input_db_network_acl_ingress"></a> [db\_network\_acl\_ingress](#input\_db\_network\_acl\_ingress) | Ingress network ACL rules | `list(map(string))` | `[]` | no |
| <a name="input_db_password_length"></a> [db\_password\_length](#input\_db\_password\_length) | [OPTIONAL] DB Password Length | `number` | `32` | no |
| <a name="input_db_password_version"></a> [db\_password\_version](#input\_db\_password\_version) | [OPTIONAL] DB password version | `number` | `1` | no |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | n/a | `number` | `3306` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | [OPTIONAL] Number of days the key will be scheduled for deletion | `number` | `7` | no |
| <a name="input_ecs_service_desired_count"></a> [ecs\_service\_desired\_count](#input\_ecs\_service\_desired\_count) | Number of tasks to have running | `number` | `2` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | [OPTIONAL] Enable key rotation. Defaults to true. | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | [OPTIONAL] Enable/Disable NAT GW. | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | [REQUIRED] Env variable | `string` | n/a | yes |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | [OPTIONAL] Specifies the intended use of the key. Valid values: ENCRYPT\_DECRYPT or SIGN\_VERIFY. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_lb_internal"></a> [lb\_internal](#input\_lb\_internal) | If the load balancer should be an internal load balancer | `bool` | `false` | no |
| <a name="input_log_retention"></a> [log\_retention](#input\_log\_retention) | [OPTIONAL] Log group retention in days. | `number` | `14` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Specify a family for a task definition, which allows you to track multiple versions of the same task definition | `string` | `"2048"` | no |
| <a name="input_org"></a> [org](#input\_org) | [REQUIRED] Organisation tag | `string` | n/a | yes |
| <a name="input_plugins"></a> [plugins](#input\_plugins) | n/a | `list(string)` | <pre>[<br>  "all"<br>]</pre> | no |
| <a name="input_private_network_acl_egress"></a> [private\_network\_acl\_egress](#input\_private\_network\_acl\_egress) | Egress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_private_network_acl_ingress"></a> [private\_network\_acl\_ingress](#input\_private\_network\_acl\_ingress) | Ingress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | [REQUIRED] List of Private subnets. | `list(string)` | n/a | yes |
| <a name="input_public_network_acl_egress"></a> [public\_network\_acl\_egress](#input\_public\_network\_acl\_egress) | Egress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_public_network_acl_ingress"></a> [public\_network\_acl\_ingress](#input\_public\_network\_acl\_ingress) | Egress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | [REQUIRED] List of Public subnets. | `list(string)` | n/a | yes |
| <a name="input_rds_cluster_backup_retention_period"></a> [rds\_cluster\_backup\_retention\_period](#input\_rds\_cluster\_backup\_retention\_period) | Number of days to retain backups | `number` | `1` | no |
| <a name="input_rds_cluster_deletion_protection"></a> [rds\_cluster\_deletion\_protection](#input\_rds\_cluster\_deletion\_protection) | If the cluster should have deletion protection enabled | `bool` | `false` | no |
| <a name="input_rds_cluster_enable_cloudwatch_logs_export"></a> [rds\_cluster\_enable\_cloudwatch\_logs\_export](#input\_rds\_cluster\_enable\_cloudwatch\_logs\_export) | Set of log types to export to cloudwatch, valid values are audit, error, general, slowquery, postgresql | `list(string)` | <pre>[<br>  "audit"<br>]</pre> | no |
| <a name="input_rds_cluster_engine_version"></a> [rds\_cluster\_engine\_version](#input\_rds\_cluster\_engine\_version) | Engine version to use for the cluster | `string` | `""` | no |
| <a name="input_rds_cluster_instance_count"></a> [rds\_cluster\_instance\_count](#input\_rds\_cluster\_instance\_count) | Number of RDS instances to provision | `number` | `1` | no |
| <a name="input_rds_cluster_instance_instance_class"></a> [rds\_cluster\_instance\_instance\_class](#input\_rds\_cluster\_instance\_instance\_class) | Database instance type | `string` | `"db.t3.medium"` | no |
| <a name="input_rds_cluster_master_username"></a> [rds\_cluster\_master\_username](#input\_rds\_cluster\_master\_username) | Master username for the RDS cluster | `string` | `"admin"` | no |
| <a name="input_rds_cluster_preferred_backup_window"></a> [rds\_cluster\_preferred\_backup\_window](#input\_rds\_cluster\_preferred\_backup\_window) | The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter.  Time in UTC. | `string` | `"08:00-09:00"` | no |
| <a name="input_rds_cluster_preferred_maintenance_window"></a> [rds\_cluster\_preferred\_maintenance\_window](#input\_rds\_cluster\_preferred\_maintenance\_window) | The weekly time range during which system maintenance can occur, in (UTC). | `string` | `"sun:06:00-sun:07:00"` | no |
| <a name="input_rds_cluster_skip_final_snapshot"></a> [rds\_cluster\_skip\_final\_snapshot](#input\_rds\_cluster\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB cluster is deleted | `bool` | `true` | no |
| <a name="input_root_directory"></a> [root\_directory](#input\_root\_directory) | [OPTIONAL] EFS root directory config | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | [OPTIONAL] Map of Tags | `map(any)` | <pre>{<br>  "Terraform": "true"<br>}</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | [REQUIRED] VPC CIDR | `string` | n/a | yes |
| <a name="input_wordpress_image"></a> [wordpress\_image](#input\_wordpress\_image) | n/a | `string` | `"bitnami/wordpress:6.5.2"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->