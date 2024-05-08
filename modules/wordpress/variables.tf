variable "app" {
  type        = string
  description = "[REQUIRED] Application name"
}

variable "env" {
  type        = string
  description = "[REQUIRED] Env variable"
}

variable "db_password_length" {
  type        = number
  description = "[OPTIONAL] DB Password Length"
  default     = 32
}

variable "db_password_version" {
  type        = number
  description = "[OPTIONAL] DB password version"
  default     = 1
}

variable "deletion_window_in_days" {
  default     = 7
  description = "[OPTIONAL] Number of days the key will be scheduled for deletion"
  type        = number
}

variable "key_usage" {
  type        = string
  description = "[OPTIONAL] Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY."
  default     = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  type        = string
  description = "[OPTIONAL] Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports."
  default     = "SYMMETRIC_DEFAULT"
}

variable "enable_key_rotation" {
  default     = true
  type        = bool
  description = "[OPTIONAL] Enable key rotation. Defaults to true."
}

variable "tags" {
  type        = map(any)
  description = "[OPTIONAL] Map of Tags"
  default = {
    "Terraform" : "true"
  }
}

variable "org" {
  type        = string
  description = "[REQUIRED] Organisation tag"
}

variable "root_directory" {
  type        = any
  description = "[OPTIONAL] EFS root directory config"
  default     = {}
}

variable "log_retention" {
  type        = number
  default     = 14
  description = "[OPTIONAL] Log group retention in days."
}

variable "vpc_cidr" {
  type        = string
  description = "[REQUIRED] VPC CIDR"
}

variable "azs" {
  type        = list(string)
  description = "[REQUIRED] List of AZ"
}

variable "public_subnets" {
  type        = list(string)
  description = "[REQUIRED] List of Public subnets."
}

variable "private_subnets" {
  type        = list(string)
  description = "[REQUIRED] List of Private subnets."
}

variable "database_subnets" {
  type        = list(string)
  description = "[REQUIRED] List of DB subnets."
}

variable "enable_nat_gateway" {
  type        = bool
  description = "[OPTIONAL] Enable/Disable NAT GW."
  default     = true
}

variable "public_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "public_network_acl_ingress" {
  description = "Egress network ACL rules"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "private_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "private_network_acl_ingress" {
  description = "Ingress network ACL rules"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "db_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = list(map(string))

  default = []
}

variable "db_network_acl_ingress" {
  description = "Ingress network ACL rules"
  type        = list(map(string))

  default = []
}

variable "db_port" {
  type    = number
  default = 3306
}

variable "rds_cluster_backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 1
}

variable "rds_cluster_deletion_protection" {
  description = "If the cluster should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "rds_cluster_enable_cloudwatch_logs_export" {
  description = "Set of log types to export to cloudwatch, valid values are audit, error, general, slowquery, postgresql"
  type        = list(string)
  default     = ["audit"]
}

variable "rds_cluster_engine_version" {
  description = "Engine version to use for the cluster"
  type        = string
  default     = ""
}

variable "rds_cluster_master_username" {
  description = "Master username for the RDS cluster"
  type        = string
  default     = "admin"
}

variable "db_engine" {
  type    = string
  default = "aurora-mysql"
}

variable "rds_cluster_preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter.  Time in UTC."
  type        = string
  default     = "08:00-09:00"
}

variable "rds_cluster_preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in (UTC)."
  type        = string
  default     = "sun:06:00-sun:07:00"
}

variable "rds_cluster_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  type        = bool
  default     = true
}

variable "rds_cluster_instance_count" {
  description = "Number of RDS instances to provision"
  type        = number
  default     = 1
}

variable "rds_cluster_instance_instance_class" {
  description = "Database instance type"
  type        = string
  default     = "db.t3.medium"
}


variable "cpu" {
  description = "Number of CPU units reserved for the container in powers of 2"
  type        = string
  default     = "1024"
}

variable "memory" {
  description = "Specify a family for a task definition, which allows you to track multiple versions of the same task definition"
  type        = string
  default     = "2048"
}

variable "ecs_service_desired_count" {
  description = "Number of tasks to have running"
  type        = number
  default     = 2
}

variable "lb_internal" {
  description = "If the load balancer should be an internal load balancer"
  type        = bool
  default     = false
}

variable "container_port" {
  type    = number
  default = 80
}

variable "wordpress_image" {
  type    = string
  default = "bitnami/wordpress:6.5.2"
}

variable "plugins" {
  type    = list(string)
  default = ["all"]
}

variable "always_run" {
  type    = bool
  default = false
}