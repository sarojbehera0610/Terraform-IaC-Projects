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
terraform init
│
▼
terraform plan
│
▼
terraform apply
│
▼
terraform destroy

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

## Resources Provisioned in This Project

| File | Resource |
|---|---|
| `provider.tf` | AWS Provider configuration |
| `variables.tf` | All input variables centralized |
| `vpc.tf` | VPC, Public Subnets, IGW, Route Table |
| `sg.tf` | Security Group (SSH, HTTP, HTTPS) |
| `keypair.tf` | RSA Key Pair generation and .pem file |
| `ec2.tf` | EC2 Instance with Ubuntu AMI (data block) |
| `s3.tf` | Private S3 Bucket with versioning |
| `iam.tf` | IAM User with AdministratorAccess and Access Keys |
| `alb.tf` | Application Load Balancer, Target Group, Listener |
| `asg.tf` | Auto Scaling Group, Launch Template, CloudWatch Alarms |

---

## How to Use This Project

```bash
# Clone the repo
git clone https://github.com/sarojbehera0610/Terraform-IaC-Projects.git
cd Terraform-IaC-Projects/terraform-resources

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply

# Destroy when done
terraform destroy
```

---

## Author

**Saroj Behera**
DevOps Engineer | [sarojops.cloud](https://sarojops.cloud) | [GitHub](https://github.com/sarojbehera0610)
