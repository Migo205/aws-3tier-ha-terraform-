# AWS 3-Tier High-Availability Web Application with Terraform

A fully automated, production-grade **3-Tier Architecture** deployed on AWS using Terraform (Infrastructure as Code).  
Designed for learning, interviews, certifications (AWS Solutions Architect / DevOps), and portfolio showcase.

## Architecture Overview

```mermaid
graph TD
    Internet[Internet Users] -->|HTTPS/HTTP| ALB[Application Load Balancer<br/>Public Subnets - 2 AZs]
    ALB -->|HTTP:80| Web1[EC2 Web Server 1<br/>Private Subnet - AZ1]
    ALB -->|HTTP:80| Web2[EC2 Web Server 2<br/>Private Subnet - AZ2]
    Web1 & Web2 -->|MySQL:3306| RDS[(Multi-AZ MySQL RDS<br/>Encrypted Storage)]
    Web1 --> NAT1[NAT Gateway AZ1] --> IGW[Internet Gateway]
    Web2 --> NAT2[NAT Gateway AZ2] --> IGW

Presentation Tier: Public ALB (only public-facing component)
Application Tier: 2 × EC2 instances (Ubuntu + Apache) in private subnets across 2 AZs
Data Tier: Multi-AZ encrypted MySQL RDS with automatic failover

Key Features & Best Practices Implemented

Full High Availability across 2 Availability Zones
Secure by design: Web & DB tiers have no public IPs
Least-privilege Security Groups
Encrypted root volumes and RDS storage
Outbound internet via NAT Gateways (private instances can update packages)
Dynamic user-data generates unique index.html per instance (displays Instance ID + AZ on every refresh → proves load balancing works)
Clean, modular, and fully commented Terraform code
Comprehensive outputs (website URL, RDS endpoint, instance details)

Deployment (One Command)
Bashgit clone https://github.com/Migo205/my_repo.git
cd my_repo
terraform init
terraform apply --auto-approve    # Takes ~8-10 minutes
After completion, open the URL from output:
Bashterraform output -raw website_url
Refresh the page multiple times → you will see traffic switching between the two instances in different AZs.
Cleanup (Avoid Charges)
Bashterraform destroy --auto-approve
Project Structure
text├── provider.tf           # AWS provider configuration
├── variables.tf          # All variables with sensible defaults
├── vpc.tf                # VPC, subnets, IGW, NAT, route tables
├── security-groups.tf    # ALB, Web, and RDS security groups
├── ec2.tf                # Web servers + user-data bootstrap
├── alb.tf                # ALB, target group, listener
├── rds.tf                # Multi-AZ MySQL RDS
├── outputs.tf            # Website URL, RDS endpoint, instance info
└── user-data.sh          # Apache installation + dynamic index page
Requirements

AWS account (ALB creation enabled — new accounts may need a quick limit request)
Terraform ≥ 1.5
AWS CLI configured

Note for New AWS Accounts
If you get the ALB permission error:
"This AWS account currently does not support creating load balancers"
→ Open a quick support case here:
https://console.aws.amazon.com/support/contacts?/load-balancer
Most requests are approved in under 10 minutes.
License
MIT License — Free to use, modify, and distribute.
