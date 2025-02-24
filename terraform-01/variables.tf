variable "postgres_host" {
  type    = string
  default = "localhost"
}

variable "postgres_port" {
  type    = number
  default = 5432
}

variable "postgres_root" {
  type        = string
  description = "PostgreSQL superuser username"
}

variable "postgres_root_password" {
  type        = string
  description = "PostgreSQL superuser password"
  sensitive   = true
}
