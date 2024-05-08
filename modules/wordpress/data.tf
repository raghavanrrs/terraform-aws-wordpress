#data "aws_ecr_authorization_token" "token" {
#}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_rds_engine_version" "rds_engine_version" {
  engine = var.db_engine
}