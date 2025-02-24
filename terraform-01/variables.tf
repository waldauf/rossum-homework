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

variable "ro-user" {
  type        = string
  description = "read only user for all databases"
  default     = "ro-user"
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


