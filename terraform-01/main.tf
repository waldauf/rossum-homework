variable "postgres_root" {
  type        = string
  description = "postgres super user"
}

variable "postgres_root_password" {
  type        = string
  description = "postgres super user password"
}

variable "postgres_host" {
  type        = string
  description = "postgres host"
}

variable "postgres_port" {
  type        = number
  description = "postgres port"
}

variable "user-ro" {
  type        = string
  description = "read only user for all databases"
  default     = "user-ro"
  sensitive   = true
}

variable "database_names" {
  type        = list(string)
  description = "list of database names to create"
  default     = ["app1_db", "app2_db", "app3_db"]
}


variable "user_database_map" {
  type        = map(string)
  description = "map of users to their corresponding databases"
  default = {
    "app1_user" = "app1_db"
    "app2_user" = "app2_db"
    "app3_user" = "app3_db"
  }
}

# Geneate random password for users
resource "random_password" "user_passwords" {
  for_each = toset(
    concat(
      keys(var.user_database_map),
      ["user-ro"]
  ))

  length  = 16
  special = true
}

output "all_users_passwords" {
  value     = { for user, password in random_password.user_passwords : user => password.result }
  sensitive = true
}


resource "postgresql_database" "databases" {
  for_each = toset(var.database_names)

  name  = each.key
  owner = var.postgres_root
}


