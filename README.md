# PostgreSQL Multi-Deployment Management with Terraform

## Assignment

Rationale: Currently we have multiple deployments that span across multiple cloud accounts. Each deployment has a separate terraform codebase, with some TF modules shared. As our deployments grow, managing each terraform configuration separately becomes less and less viable. We need to move to a more scalable solution and the goal of this assignment is to create a simple demo of some approach for the solution.

Please publish your solution in a publicly available git repository. All code, scripts and possibly documentation should be committed into this repository. If manual steps are performed (eg. start a docker-compose or terraform commands), they should be documented so everybody familiar with the technologies is able to reproduce the steps. Each task should be represented as one or more commits in the repository.

### Key Requirements:

- [x] Everything must run locally using Docker/Docker Compose
- [x] No cloud services should be used
- [x] Solution must be in a public git repository
- [x] All manual steps must be documented
- [] Each task should be separate commits
  - [ ] Print of all commits before squashing
  - [ ] Squash commits for each task

### Task 1 - Single Deployment Setup

- [x] Create a docker-compose.yml file that:
  - [x] Runs a PostgreSQL database
  - [x] Makes it accessible only from localhost
  - [x] Sets up root password (can be visible in git)
- [x] Create a Terraform module that:
  - [x] Creates 3 databases
  - [x] Creates 3 pairs of users (each with full access to one database)
  - [x] Creates 1 read-only user with access to all databases
  - [x] Manages secure passwords (must not be visible in git)
  - [x] Can use local terraform state

### Task 2 - Multiple Deployments

- [x] Extend docker-compose.yml to:
  - [x] Run multiple PostgreSQL instances (suggested 3)
  - [x] Each instance on different ports
  - [x] Each instance simulates a separate deployment/AWS account
- [x] Apply the same Terraform configuration to each instance:
  - [x] Same database and user structure
  - [x] Unique passwords for each instance
  - [x] Should be easily scalable to add more instances

## General information

### Required tools
- `terraform` (version ~> 1.7)
- `docker`
- `docker-compose`

## Task 1: Single Deployment Setup

### Steps for reproducing:

1. Switch to the task 1 directory:
```bash
cd ./terraform-01
```

2. Run PostgreSQL instance as docker container:
```bash
cd docker
docker-compose up -d
docker-compose ps -a
cd ..
```

3. Run `terraform` for applying PostgreSQL configuration:
```bash
# Initialize Terraform (load all necessary providers)
terraform init

# Check the output if everything is alright
terraform plan -out postgres_configuration.tfplan

# Apply changes
terraform apply postgres_configuration.tfplan
```
 
4. View all users and their passwords from the `terraform.tfstate` file:
```bash
jq -r '.outputs.all_users_passwords.value | to_entries[] | "\(.key) => \(.value)"' terraform.tfstate
```

5. Verify PostgreSQL configuration:
```bash
# List all databases
PGPASSWORD="root" psql -h localhost -p 5432 -U root -d postgres -c "\l"

# List all users
PGPASSWORD="root" psql -h localhost -p 5432 -U root -d postgres -c "\du"
```

6. Clean up (when done):
```bash
terraform apply -destroy
cd docker
docker-compose down
sudo rm -rf postgres_data
cd ..
```

## Task 2: Multiple Deployments

### Steps for reproducing:

1. Switch to the task 2 directory:
```bash
cd ./terraform-02
```

2. Run all PostgreSQL instances as docker containers:
```bash
cd docker
docker-compose up -d
docker-compose ps -a
cd ..
```

Each instance is running on different ports:
  - DEV:  5432
  - TEST: 5433
  - PROD: 5434

3. Configure each environment (example for DEV):
```bash
# Switch to DEV configuration
cd clusters/dev

# Initialize Terraform
terraform init

# Plan changes
terraform plan -out postgres_configuration.tfplan

# Apply changes
terraform apply postgres_configuration.tfplan
```

Repeat for TEST and PROD environments by changing to the appropriate directory.
 
4. View passwords for a specific environment:
```bash
jq -r '.outputs.all_users_passwords.value | to_entries[] | "\(.key) => \(.value)"' terraform.tfstate
```

5. Verify PostgreSQL configuration (adjust port based on environment):
```bash
# For DEV environment (port 5432)
PGPASSWORD="root" psql -h localhost -p 5432 -U root -d postgres -c "\du"
PGPASSWORD="root" psql -h localhost -p 5432 -U root -d postgres -c "\l"

# For TEST environment (port 5433)
PGPASSWORD="root" psql -h localhost -p 5433 -U root -d postgres -c "\du"
PGPASSWORD="root" psql -h localhost -p 5433 -U root -d postgres -c "\l"

# For PROD environment (port 5434)
PGPASSWORD="root" psql -h localhost -p 5434 -U root -d postgres -c "\du"
PGPASSWORD="root" psql -h localhost -p 5434 -U root -d postgres -c "\l"
```

6. Clean up all environments:
```bash
# For each environment
cd clusters/dev
terraform apply -destroy
cd ../test
terraform apply -destroy
cd ../prod
terraform apply -destroy

# Remove containers and volumes
cd ../../docker
docker-compose down
sudo rm -rf postgres_data*
```

## Recommendations for Production Use

### Password Storage
- All passwords should be loaded during CD pipeline to:
  - Prevent possible leakage
  - Avoid manual manipulation
  - In this implementation, we prevent sharing by adding `terraform.tfstate` to `.gitignore` file

### Terraform State Management
- State should be stored in a remote backend to support team collaboration
- Remote state enables locking to prevent concurrent modifications

### CI/CD Pipeline Integration

**CI**
- Run formatting, validation, and security scans on each pull request
- Implement linting and policy checks to ensure best practices

**CD**
- Manage sensitive data like passwords as part of the CD pipeline
- Consider whether the `apply` process should be automated or require manual approval

