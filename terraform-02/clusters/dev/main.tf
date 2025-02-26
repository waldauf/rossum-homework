module "postgresql_users" {
  source = "../../modules/postgresql_users"

  postgres_host          = var.postgres_host
  postgres_port          = var.postgres_port
  postgres_root          = var.postgres_root
  postgres_root_password = var.postgres_root_password

  # Here is possible to override default database names and user mappings
  database_names = ["custom_db1", "custom_db2", "custom_db3", "custom_db4"]
  user_database_map = {
    "custom_user1" = "custom_db1"
    "custom_user2" = "custom_db2"
    "custom_user3" = "custom_db3"
    "custom_user4" = "custom_db4"
  }
}
