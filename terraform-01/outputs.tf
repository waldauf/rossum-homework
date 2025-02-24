output "all_users_passwords" {
  value     = module.postgresql_users.all_users_passwords
  sensitive = true
}

