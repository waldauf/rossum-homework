###############################################################################
### OUTPUT OF ALL USERS & PASSWD PAIRS ########################################
###############################################################################

output "all_users_passwords" {
  value     = { for user, password in random_password.user_passwords : user => password.result }
  sensitive = true
}


