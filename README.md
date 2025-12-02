Markdown# AWS 3-Tier High-Availability Web Application (Terraform IaC)

This repository deploys a production-ready **3-Tier Web Architecture** on AWS using Terraform. It implements a secure, scalable web application with high availability across multiple Availability Zones (AZs), featuring:

- Custom VPC with public and private subnets in 2 AZs
- 2 EC2 web servers (Ubuntu 22.04 LTS) in private subnets, bootstrapped with Apache via custom user-data
- Application Load Balancer (ALB) for public traffic distribution
- Multi-AZ encrypted MySQL RDS for the data tier
- NAT Gateways for outbound internet access from private instances
- Least-privilege Security Groups
- Automated health checks and failover

The setup ensures zero downtime, secure communication between tiers, and automatic scaling readiness. Ideal for DevOps, Cloud Engineering, or AWS Solutions Architect demonstrations.

## Architecture Overview

The architecture follows a classic 3-Tier pattern: Presentation (ALB + Web), Application (EC2), and Data (RDS). Traffic flows from the internet through the ALB to web servers in private subnets, which connect to RDS.

### High-Level Diagram

```mermaid
graph TD
    subgraph Internet["Internet"]
        Users[Users]
    end
    
    subgraph Public["Public Subnets (2 AZs)"]
        ALB[Application Load Balancer<br/>Port 80 HTTP]
        IGW[Internet Gateway]
        NAT1[NAT Gateway AZ1]
        NAT2[NAT Gateway AZ2]
    end
    
    subgraph Private["Private Subnets (2 AZs)"]
        Web1[EC2 Web Server 1<br/>Apache + Custom Index<br/>AZ1]
        Web2[EC2 Web Server 2<br/>Apache + Custom Index<br/>AZ2]
        RDS[(RDS MySQL<br/>Multi-AZ Encrypted<br/>DB: webapp)]
    end
    
    Users -->|HTTP/80| ALB
    ALB -->|HTTP/80| Web1
    ALB -->|HTTP/80| Web2
    Web1 -->|MySQL/3306| RDS
    Web2 -->|MySQL/3306| RDS
    Web1 --> NAT1 --> IGW
    Web2 --> NAT2 --> IGW
    
    classDef public fill:#e1f5fe
    classDef private fill:#f3e5f5
    classDef internet fill:#fff3e0
    class Public,Internet,Private
Traffic Flow Visualization

Inbound: Users → ALB (Public Subnet) → Health Check → Forward to Web Servers (Private Subnets)
Internal: Web Servers → RDS (Private Subnets) over secure port 3306
Outbound: Web Servers → NAT Gateway → Internet (for updates/packages only)

Architecture Flow
Key Features

High Availability: Deployed across 2 AZs (us-east-1a/b) for web and database layers
Security: Private subnets for app/DB tiers; ALB only exposes port 80; RDS restricted to web SG
Automation: User-data script installs Apache and generates dynamic index.html showing instance ID/AZ (verifies load balancing on refresh)
Encryption: EBS volumes and RDS storage encrypted at rest
Cost Optimization: t2.micro/t3.micro instances; NAT for outbound only
Monitoring: ALB health checks on / (200 OK); RDS Multi-AZ failover

Deployment Instructions
Prerequisites

AWS account with ALB permissions (request limit increase if new account)
Terraform ≥ 1.5 installed
AWS CLI configured (aws configure)

Quick Start
Bash# Clone the repository
git clone https://github.com/Migo205/my_repo.git
cd my_repo

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Deploy the full stack (~8-10 minutes)
terraform apply --auto-approve

# Access the application
echo "Website: $(terraform output -raw website_url)"
After deployment:

Open the output website_url in your browser
Refresh multiple times → Observe traffic alternating between AZ1 and AZ2 instances
RDS endpoint available for app integration: $(terraform output -raw rds_endpoint)

Customization
Edit variables.tf or create terraform.tfvars:
hclregion = "us-east-1"
instance_type = "t3.micro"
Re-apply: terraform apply
Cleanup
Destroy all resources to avoid charges:
Bashterraform destroy --auto-approve
Project Structure

















































File/DirectoryDescriptionprovider.tfAWS provider configurationvariables.tfInput variables (defaults for us-east-1, CIDRs, etc.)vpc.tfVPC, subnets, IGW, NAT Gateways, route tablessecurity-groups.tfALB, Web, RDS security groups with least privilege rulesec2.tf2 EC2 web instances with user-data bootstrappingalb.tfALB, target group, listener, and attachmentsrds.tfMulti-AZ MySQL RDS with DB subnet groupoutputs.tfKey outputs (website URL, RDS endpoint, instance details)user-data.shBootstrap script for Apache + dynamic index pagescreenshots/Deployment visuals (architecture, console views)
Screenshots
1. Terraform Apply Output
Terraform Deployment
2. ALB Load Distribution (Different AZ on Refresh)
ALB AZ Switching
3. EC2 Instances in Multi-AZ Setup
EC2 Multi-AZ
4. RDS Multi-AZ Configuration
RDS Multi-AZ
5. Security Groups Flow
SG Flow
Testing & Validation

Web Access: curl $(terraform output -raw website_url) → Returns custom HTML with instance/AZ details
Load Balancing: Refresh browser 5-10 times → Traffic should alternate between instances
RDS Connectivity: From EC2 (ssh tunnel): mysql -h $(terraform output -raw rds_endpoint) -u admin -p
Failover Test: (Advanced) Terminate one EC2 → ALB should route to the healthy instance

Troubleshooting

ALB Permission Error: New accounts need limit increase – create AWS Support case for "Application Load Balancer"
User-Data Failure: Check EC2 logs: sudo tail -f /var/log/cloud-init-output.log
RDS Connection: Verify SG allows 3306 from web_sg only

Future Enhancements

Add Auto Scaling Group (ASG) for dynamic scaling
Integrate CloudWatch alarms and monitoring
Enable HTTPS with ACM certificate
CI/CD with GitHub Actions + Terraform Cloud
Containerize with ECS/EKS

License
MIT License – Feel free to fork, modify, and use.

Built with Terraform v1.5+ | AWS Services: VPC, EC2, ALB, RDS | Region: us-east-1
