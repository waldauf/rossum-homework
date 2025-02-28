###############################################################################
### SOURCE ####################################################################
# https://www.env0.com/blog/terragrunt
###############################################################################

# terragrunt.hcl
remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    # ${path_relative_to_include()} can relates to clusters/{dev,test,prod}
    path = "${path_relative_to_include()}/terraform.tfstate"
  }
}

# Define inputs that are common to all deployments
inputs = {

  postgres_root          = "root"
  postgres_root_password = "root"

  database_names = ["custom_db1", "custom_db2", "custom_db3"]

  user_database_map = {
    "custom_user1" = "custom_db1"
    "custom_user2" = "custom_db2"
    "custom_user3" = "custom_db3"
  }
}
