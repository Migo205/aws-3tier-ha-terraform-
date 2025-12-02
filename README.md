AWS 3-Tier HA Terraform Infrastructure
A Terraform project for deploying a highly available 3-tier architecture on AWS with auto-scaling, multi-AZ deployment, and secure networking.

Features
3-Tier Architecture: Web, Application, and Database tiers

High Availability: Multi-AZ deployment across availability zones

Auto Scaling: Automatic scaling of web and application tiers

Security: Network segmentation with public/private subnets

Infrastructure as Code: Complete environment defined in Terraform

Quick Start
Prerequisites
Terraform 1.0+

AWS CLI configured

AWS Account with appropriate permissions

Deployment
Clone the repository:

bash
git clone https://github.com/Migo205/aws-3tier-ha-terraform-.git
cd aws-3tier-ha-terraform-
Configure variables in terraform.tfvars (use terraform.tfvars.example as template)

Initialize and deploy:

bash
terraform init
terraform plan
terraform apply
Architecture
Components
Web Tier: ALB + Auto Scaling Group (EC2 instances)

App Tier: Internal ALB + EC2 instances in private subnets

Data Tier: Multi-AZ RDS with automated backups

Networking: VPC with public/private subnets, NAT Gateway, Security Groups

Network Design
VPC with CIDR block

Public subnets for web tier

Private subnets for app and database tiers

Internet Gateway for public access

NAT Gateway for private instance internet access

Configuration
Key Variables
hcl
aws_region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
web_instance_type = "t3.medium"
app_instance_type = "t3.medium"
db_instance_class = "db.t3.medium"
Optional Features
Enable/disable CloudWatch monitoring

Configure Auto Scaling policies

Set backup retention period

Enable VPC Flow Logs

Project Structure
text
├── main.tf              # Main configuration
├── variables.tf         # Variable definitions
├── outputs.tf          # Output values
├── terraform.tfvars    # Variable values
├── modules/            # Reusable modules
└── scripts/            # Bootstrap scripts
Operations
Scaling
Update instance counts in variables and reapply:

bash
terraform apply -var="web_instance_count=4"
Updates
bash
terraform plan
terraform apply
Cleanup
bash
terraform destroy
Outputs
After deployment, access:

Web Load Balancer DNS name

Database endpoint

VPC ID and subnet details

CloudWatch dashboard (if enabled)

Security
Security groups with minimal required access

IAM roles with least privilege

Database encryption at rest

Network ACLs for additional security

Cost Optimization
Use Auto Scaling to adjust capacity

Implement monitoring for unused resources

Consider reserved instances for baseline capacity

Support
For issues or questions:

Check existing GitHub issues

Create a new issue with detailed description

License
MIT License - See LICENSE file for details.
