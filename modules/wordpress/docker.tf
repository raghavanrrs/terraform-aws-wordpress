#provider "docker" {
#  registry_auth {
#    address  = format("%v.dcr.ecr.%v.amazonaws.com", data.aws_caller_identity.current.account_id, data.aws_region.current.name)
#    username = data.aws_ecr_authorization_token.token.user_name
#    password = data.aws_ecr_authorization_token.token.password
#  }
#}

