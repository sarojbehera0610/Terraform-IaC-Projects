# Terraform-IaC-Projects

A hands-on Infrastructure as Code (IaC) project using Terraform to provision and manage AWS resources.
All resources are modularly written in separate `.tf` files following Terraform best practices.

---

## What is Terraform?

Terraform is an open-source Infrastructure as Code tool developed by HashiCorp.
It allows you to define, provision, and manage cloud infrastructure using a declarative
configuration language called HCL (HashiCorp Configuration Language).
Instead of manually creating resources in the AWS Console, you write code and Terraform
handles the creation, update, and deletion of resources automatically.

---

## Why Use Terraform?

- Write infrastructure as code and version control it like application code
- Provision resources across multiple cloud providers (AWS, Azure, GCP) using one tool
- Reuse code using variables, modules, and workspaces
- Preview changes before applying using `terraform plan`
- Destroy entire infrastructure with a single command `terraform destroy`

---

## Advantages of Terraform

- **Declarative syntax** — you define what you want, Terraform figures out how to achieve it
- **State management** — tracks real infrastructure via `terraform.tfstate`
- **Provider ecosystem** — supports 1000+ providers (AWS, GitHub, Kubernetes, Datadog etc.)
- **Idempotent** — running the same code multiple times gives the same result
- **Plan before apply** — dry run shows exactly what will be created/changed/destroyed
- **Team collaboration** — state can be stored remotely in S3 for team use
- **Modular** — reusable modules reduce code duplication

---

## Disadvantages of Terraform

- **State file risk** — if `terraform.tfstate` is corrupted or lost, Terraform loses track of resources
- **Learning curve** — HCL syntax and provider docs take time to learn
- **No rollback** — Terraform does not automatically rollback failed applies
- **Drift detection** — manual changes in AWS Console cause state drift
- **Large plans** — complex infrastructure with many resources can produce large, hard-to-read plans

---

## Terraform Block Types

| Block | Purpose |
|---|---|
| `terraform {}` | Define required providers and Terraform version |
| `provider` | Configure the cloud provider (AWS region, credentials) |
| `resource` | Define infrastructure components (EC2, VPC, S3 etc.) |
| `variable` | Declare input variables to make code reusable |
| `output` | Print values after apply (IP address, ARN, DNS etc.) |
| `data` | Fetch existing resource info from AWS (latest AMI etc.) |
| `locals` | Define local computed values within a module |
| `module` | Reuse a group of resources as a single unit |

---

## What Problems Terraform Solves

- **Manual provisioning** — no more clicking through AWS Console for every resource
- **Configuration drift** — infrastructure defined in code is consistent across environments
- **No documentation** — the `.tf` files themselves are the documentation
- **Slow onboarding** — new team members can provision entire environments with one command
- **Human errors** — code review catches mistakes before they reach production
- **Repeatability** — same code deploys identical infrastructure in dev, staging, production

---

## Terraform Installation

### On Windows

1. Go to https://developer.hashicorp.com/terraform/downloads
2. Download the **Windows AMD64** zip file
3. Extract the `terraform.exe` file
4. Move `terraform.exe` to `C:\Terraform\`
5. Add `C:\Terraform` to System Environment Variables → Path
6. Open new terminal and verify:

```bash
terraform version
```

### On Linux / Ubuntu (CLI)

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install terraform -y

terraform version
```

---

## Terraform Lifecycle

| Command | What it does |
|---|---|
| `terraform init` | Downloads provider plugins, initializes `.terraform/` directory |
| `terraform plan` | Shows what will be created, changed, or destroyed — dry run |
| `terraform apply` | Actually provisions the infrastructure on AWS |
| `terraform destroy` | Destroys all resources managed by the current state file |
| `terraform output` | Prints output values defined in `.tf` files |
| `terraform fmt` | Formats all `.tf` files to standard HCL style |
| `terraform validate` | Validates syntax of all `.tf` files |

---

## Terraform Data Types

| Type | Example | Usage |
|---|---|---|
| `string` | `"ap-south-1"` | Text values like region, name |
| `number` | `3` | Counts, port numbers, sizes |
| `bool` | `true` / `false` | Flags like `enable_dns_hostnames` |
| `list` | `["a", "b", "c"]` | Multiple values of same type |
| `map` | `{ Name = "web" }` | Key-value pairs like tags |
| `object` | Complex structured type | Used in modules and locals |
| `any` | Accepts any type | Used when type is flexible |

---

## Important Files and Directories

### `.terraform/` directory
Created after running `terraform init`. Contains downloaded provider plugins
(like `hashicorp/aws`). This folder is large and should be added to `.gitignore`.
Never commit this folder to GitHub.

### `.terraform.lock.hcl`
Lock file created after `terraform init`. Records the exact provider versions
used (e.g. `hashicorp/aws 6.47.0`). Always commit this file to GitHub so
teammates use the same provider versions.

### `terraform.tfstate`
The most critical file. Terraform stores the current state of all provisioned
resources here. It maps your `.tf` code to real AWS resources.
- Never edit this file manually
- Never delete this file (Terraform will lose track of resources)
- For teams, store this remotely in S3 with DynamoDB locking

### `terraform.tfstate.backup`
Automatic backup of the previous `terraform.tfstate` created before every
`terraform apply`. Useful for recovery if the current state gets corrupted.

---

## Terraform Workspaces

Workspaces allow you to manage **multiple environments (dev, test, prod)** using
the same Terraform code with completely separate state files. Each workspace has
its own `terraform.tfstate` so resources never conflict.

### Workspace Commands

```bash
# List all workspaces
terraform workspace list

# Create new workspaces
terraform workspace new dev
terraform workspace new test
terraform workspace new prod

# Show current active workspace
terraform workspace show

# Switch to a workspace
terraform workspace select dev

# Delete a workspace (switch away first)
terraform workspace select default
terraform workspace delete dev
```

### How workspaces prevent conflict

Inside `.tf` files, use `terraform.workspace` to get the current workspace name:

```hcl
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = terraform.workspace == "prod" ? "t3.small" : "t3.micro"

  tags = {
    Name        = "${terraform.workspace}-ec2-instance"
    Environment = terraform.workspace
  }
}
```

- `dev` workspace → creates `dev-ec2-instance` with its own state
- `prod` workspace → creates `prod-ec2-instance` with its own state
- `test` workspace → creates `test-ec2-instance` with its own state
- No conflicts because each workspace has a separate `terraform.tfstate`

### Workspace state file location
terraform.tfstate.d/
├── dev/
│   └── terraform.tfstate
├── prod/
│   └── terraform.tfstate
└── test/
└── terraform.tfstate

---

## Remote Backend — Store State in S3

By default Terraform stores `terraform.tfstate` locally. For teams, store it
remotely in S3 so everyone shares the same state.

### Step 1 — Create S3 bucket in AWS Console

- Bucket name: `saroj-terraform-remote-backend-2026`
- Region: `ap-south-1`
- Enable versioning: Yes
- Block all public access: Yes

### Step 2 — Add backend block in `terraform` block

```hcl
terraform {
  backend "s3" {
    bucket  = "saroj-terraform-remote-backend-2026"
    key     = "workspace/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
```

### Step 3 — Initialize to migrate state to S3

```bash
terraform init
# When asked "copy existing state to new backend?" → type yes

terraform plan
terraform apply
```

### Benefits of Remote Backend

| Local State | Remote Backend S3 |
|---|---|
| Stored on your laptop | Stored in S3 — accessible by team |
| No versioning | Versioning enabled — full history |
| Lost if laptop crashes | Safe in S3 with replication |
| No locking | DynamoDB locking prevents simultaneous apply |
| Not shareable | Shareable across team |

---

## Terraform Import

Import is used when a resource **already exists in AWS** (created manually via
Console) and you want Terraform to start managing it without recreating it.

### How Import Works

1. Write the resource block in your `.tf` file first
2. Run `terraform import` with the real AWS resource ID
3. Terraform pulls the real state into `terraform.tfstate`
4. Run `terraform plan` to verify no drift

### Import Commands

```bash
# Syntax
terraform import <resource_type>.<resource_name> <aws_resource_id>

# Import existing EC2 instance
terraform import aws_instance.ec2 i-0abc1234567890def

# Import existing S3 bucket
terraform import aws_s3_bucket.main saroj-existing-bucket

# Import existing VPC
terraform import aws_vpc.main vpc-0abc1234567890def

# Import existing Security Group
terraform import aws_security_group.sg sg-0abc1234567890def

# Import existing IAM user
terraform import aws_iam_user.admin_user terraform-admin-user

# Import existing Key Pair
terraform import aws_key_pair.kp terraform-keypair

# After import — always verify
terraform plan
```

### Important rules for Import

- Resource block must exist in `.tf` file before importing
- Import only brings state — it does NOT generate `.tf` code automatically
- Always run `terraform plan` after import to check for drift
- If plan shows changes, update your `.tf` code to match real resource

---

## Resources Provisioned in This Project

| Folder | Contents |
|---|---|
| `terraform-resources/` | Flat `.tf` files — VPC, EC2, SG, S3, IAM, ALB, ASG, keypair |
| `terraform-modules/vpc-module/` | Reusable VPC module with dev/prod/test tfvars |
| `terraform-modules/ec2-module/` | Reusable EC2 module with dev/prod/test tfvars |
| `terraform-modules/s3-module/` | Reusable S3 module with dev/prod/test tfvars |
| `terraform-modules/alb-module/` | Reusable ALB module with dev/prod/test tfvars |
| `terraform-modules/iam-module/` | Reusable IAM module with dev/prod/test tfvars |
| `terraform-modules/asg-module/` | Reusable ASG module with dev/prod/test tfvars |
| `terraform-workspace/` | Workspace demo — dev/test/prod EC2 with remote backend |

---

## How to Use This Project

```bash
# Clone the repo
git clone https://github.com/sarojbehera0610/Terraform-IaC-Projects.git

# Flat resources
cd Terraform-IaC-Projects/terraform-resources
terraform init
terraform plan
terraform apply

# Any module
cd Terraform-IaC-Projects/terraform-modules/vpc-module
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# Workspace
cd Terraform-IaC-Projects/terraform-workspace
terraform init
terraform workspace new dev
terraform workspace select dev
terraform apply

# Destroy when done
terraform destroy
```

---

## Author

**Saroj Behera**
DevOps Engineer | [sarojops.cloud](https://sarojops.cloud) | [GitHub](https://github.com/sarojbehera0610)
