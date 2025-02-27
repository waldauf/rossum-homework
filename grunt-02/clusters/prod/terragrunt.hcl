include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/postgresql_users"
}

inputs = {
  postgres_host = "localhost"
  postgres_port = "5434"
}
