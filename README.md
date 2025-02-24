# Assignment

Rationale: Currently we have multiple deployments that span across multiple cloud accounts. Each deployment has a separate terraform codebase, with some TF modules shared. As our deployments grow, managing each terraform configuration separately becomes less and less viable. We need to move to a more scalable solution and the goal of this assignment is to create a simple demo of some approach for the solution.

Please publish your solution in a publicly available git repository. All code, scripts and possibly documentation should be committed into this repository. If manual steps are performed (eg. start a docker-compose or terraform commands), they should be documented so everybody familiar with the technologies is able to reproduce the steps. Each task should be represented as one or more commits in the repository.

# TODO

## Task 1 - Single Deployment Setup

- [x] Create a docker-compose.yml file that:
 - [x] Runs a PostgreSQL database
 - [x] Makes it accessible only from localhost
 - [x] Sets up root password (can be visible in git)
- [] Create a Terraform module that:
  - [x] Creates 3 databases
  - [x] Creates 3 pairs of users (each with full access to one database)
  - [x] Creates 1 read-only user with access to all databases
  - [x] Manages secure passwords (must not be visible in git)
  - [x] Can use local terraform state

## Task 2 - Multiple Deployments

- [] Extend docker-compose.yml to:
  - [] Run multiple PostgreSQL instances (suggested 3)
  - [] Each instance on different ports
  - [] Each instance simulates a separate deployment/AWS account
- [] Apply the same Terraform configuration to each instance:
 - [] Same database and user structure
 - [] Unique passwords for each instance
 - [] Should be easily scalable to add more instances

## Key Requirements:

- [] Everything must run locally using Docker/Docker Compose
- [] No cloud services should be used
- [x] Solution must be in a public git repository
- [] All manual steps must be documented
- [] Each task should be separate commits
  - [] Print of all commits before squashing
  - [] Squash commits for each task

      
## NICE TO HAVE
- [ ] Password generation
  - Passwords for all users will be created by Terraform's `random_password` provider.
  - Need to have access to external storage where the password will be stored.
  - Passwords are stored in tfstate file.
  - Terraform statefile cannot be shared publicly, better to use backend storage.
- [ ] How to manage passwords - don't be public
  - If the passwords are stored in 3rd party service, we would use appropriate resource (i.e. Vault)
  - Can be managed by CICD pipeline where the password will be loaded from an external vault.
  - Passwords shouldn't be stored in tfstate file
- [ ] Terraform statefile should be stored in some shared repository.
  - In this case I removed it from git repository due to possible password leakage.
- [ ] GitHub Acton
  - [ ] Automatated steps:
    - [ ] Terraform format
    - [ ] Terraform check if syntax is correct
    - [ ] Terraform plan ... check if there are no errors, if so quit pipeline with error
  - [ ] Manual action
    - [ ] Run Terraform apply
  

# What doesn't work

- Set privileges for users. 



# How to use this Terraform script

## Prerequsities

Before you start check:
- docker
  - docker service is running: `systemctl status docker.service `
- podman

## Terraform

Before you start you need to initialize Terraform environment:
```
terraform init
```

## List of created users and passwords
This command work just in case that:
1. User & password pairs are printed to `terraform.tfstate` file.
2. You have access to `terraform.tfstate` file.

Command:
```bash
jq -r '.outputs.all_users_passwords.value | to_entries[] | "\(.key): \(.value)"' terraform.tfstate
```

## PostgreSQL

Connection for the `root`:
```bash
  psql -h localhost -U root -d postgres
```

Check if you can connect to PostgreSQL with each created user:
```
  psql -h localhost -U <user> -d <database>
```
* `-h` ... hostname
* `-U` ... user
* `-d` ... database name you connect to

Check if the databases are created (is assumed you are connected to db):
```
  postgres=# \l
```

Check if the users are created:
```
  postgres=# \du
```

Check privilegies for users:
```
  
```



# PostgreSQL basic commands

Connection to the server: `psql -h 127.0.0.1 -U root -d postgres`

## Table of commands

Source - PostgreSQL [documentation](https://www.postgresql.org/docs/12/ddl-priv.html#PRIVILEGE-ABBREVS-TABLE)

| `\l` | list all databases |
| `\c <db-name>` | switch to antoher database |
| `\du` | list all users |
| `\du <user>` | retrieve a specific user |
| `\dn` | list all schemas of the currently connected database |
|  `\dt` | list database tables |
| `\d <table-name` | describe a table |
| `\s` | display command history |
| `\s <file-name>` | save the command history to a file |
| `\i` | execute psql commands from a file |
| `\H` | switch the output to HTML format |
