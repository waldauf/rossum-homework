# Geneate random password for users
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "user_passwords" {
  for_each = toset(
    concat(
      keys(var.user_database_map),
      ["ro-user"]
  ))

  length  = 16
  special = true
}


###############################################################################
### CREATING DATABASES IN Postgres ############################################
###############################################################################

# Create databases
# https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_database
resource "postgresql_database" "databases" {
  for_each = toset(var.database_names)

  name = each.key
  # Set as owner app_user or root ... what is recommanded way?
  # owner = var.postgres_root
  owner = lookup(var.user_database_map, each.key, var.postgres_root)
}

###############################################################################
### CREATING USERS IN Postgres ################################################
###############################################################################

# Create app users
# https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_role
resource "postgresql_role" "app_users" {
  for_each = var.user_database_map

  name     = each.key
  login    = true
  password = random_password.user_passwords[each.key].result
}

# Create readonly user
resource "postgresql_role" "ro-user" {
  name     = var.ro-user
  login    = true
  password = random_password.user_passwords[var.ro-user].result
}



###############################################################################
### GRANT PRIVILEGES IN Postgres ##############################################
###############################################################################


# Grant privileges to app users
# https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_grant
resource "postgresql_grant" "app_privileges" {
  for_each = var.user_database_map

  database    = each.value
  role        = each.key
  schema      = "public"
  object_type = "database"
  privileges  = ["ALL"]

  depends_on = [
    postgresql_database.databases,
    postgresql_role.app_users
  ]
}

# Grant privilege to readonly user for CONNECT to all databases
resource "postgresql_grant" "ro_privileges" {
  for_each = var.user_database_map

  database    = each.value
  role        = var.ro-user
  schema      = "public"
  object_type = "database"
  privileges  = ["CONNECT"]

  depends_on = [
    postgresql_database.databases,
    postgresql_role.ro-user
  ]
}

# Grant privilege to readonly user for USAGE of all schemas
resource "postgresql_grant" "ro_schema_privileges" {
  for_each = var.user_database_map

  database    = each.value
  role        = var.ro-user
  schema      = "public"
  object_type = "schema"
  privileges  = ["USAGE"]

  depends_on = [
    postgresql_database.databases,
    postgresql_role.ro-user
  ]
}

# Grant privilege to readonly user for SELECT to all tables
resource "postgresql_grant" "ro_table_privileges" {
  for_each = var.user_database_map

  database    = each.value
  role        = var.ro-user
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT"]

  depends_on = [
    postgresql_database.databases,
    postgresql_role.ro-user
  ]
}


###############################################################################
### OUTPUT OF ALL USERS & PASSWD PAIRS ########################################
###############################################################################

output "all_users_passwords" {
  value     = { for user, password in random_password.user_passwords : user => password.result }
  sensitive = true
}

