# Assignment

Rationale: Currently we have multiple deployments that span across multiple cloud accounts. Each deployment has a separate terraform codebase, with some TF modules shared. As our deployments grow, managing each terraform configuration separately becomes less and less viable. We need to move to a more scalable solution and the goal of this assignment is to create a simple demo of some approach for the solution.

Please publish your solution in a publicly available git repository. All code, scripts and possibly documentation should be committed into this repository. If manual steps are performed (eg. start a docker-compose or terraform commands), they should be documented so everybody familiar with the technologies is able to reproduce the steps. Each task should be represented as one or more commits in the repository.

# TODO

## Task 1 - Single Deployment Setup

- [ ] Create a docker-compose.yml file that:
 - [ ] Runs a PostgreSQL database
 - [ ] Makes it accessible only from localhost
 - [ ] Sets up root password (can be visible in git)
- [ ] Create a Terraform module that:
  - [ ] Creates 3 databases
  - [ ] Creates 3 pairs of users (each with full access to one database)
  - [ ] Creates 1 read-only user with access to all databases
  - [ ] Manages secure passwords (must not be visible in git)
  - [ ] Can use local terraform state

## Task 2 - Multiple Deployments

- [ ] Extend docker-compose.yml to:
  - [ ] Run multiple PostgreSQL instances (suggested 3)
  - [ ] Each instance on different ports
  - [ ] Each instance simulates a separate deployment/AWS account
- [ ] Apply the same Terraform configuration to each instance:
 - [ ] Same database and user structure
 - [ ] Unique passwords for each instance
 - [ ] Should be easily scalable to add more instances

## Key Requirements:

- [ ] Everything must run locally using Docker/Docker Compose
- [ ] No cloud services should be used
- [ ] Solution must be in a public git repository
- [ ] All manual steps must be documented
- [ ] Each task should be separate commits

      
## NICE TO HAVE
- [ ] Password for the database users can be created by Terraform's `random` provider.
  - Need to have access to external storage where the password will be stored.
  - Password will be stored in tfstate file.
- [ ] How to manage passwords - don't be public
  - Can be managed by CICD pipeline where the password will be loaded from an external vault.
  - Terraform statefile cannot be shared publicly, better to use backend storage.
- [ ] Terraform statefile should be stored in some shared repository.
  - In this case I removed it from git repository due to possible password leakage.
- [ ] GitHub Acton
  - [ ] Automatated steps:
    - [ ] Terraform format
    - [ ] Terraform check if syntax is correct
    - [ ] Terraform plan ... check if there are no errors, if so quit pipeline with error
  - [ ] Manual action
    - [ ] Run Terraform apply
  





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

## PostgreSQL

Check if you can connect to PostgreSQL:
```
  psql -h 127.0.0.1 -U root -d postgres
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
