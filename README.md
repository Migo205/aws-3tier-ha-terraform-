# AWS Jenkins CI/CD Server Deployment with Terraform

A complete DevOps solution for deploying a secure, production-ready **Jenkins CI/CD server** on AWS using **Terraform** as Infrastructure as Code (IaC). This project provisions a custom VPC, EC2 instance with Ubuntu, automated Jenkins installation via user-data script, and essential networking/security components. Ideal for DevOps labs, CI/CD pipelines, and AWS certifications (Solutions Architect / DevOps Engineer).

## Project Overview

This repository automates the setup of a Jenkins master server in a custom VPC:
- **Networking**: Isolated VPC with public subnet, Internet Gateway, and route tables for outbound access
- **Compute**: Ubuntu EC2 instance with Elastic IP for static access
- **Security**: Security Group allowing HTTP (8080) and SSH (22) with least-privilege rules
- **Automation**: User-data script installs Java and Jenkins on instance boot
- **Outputs**: Jenkins URL, EC2 ID, VPC details for easy access and integration

The deployment ensures Jenkins is accessible via public IP, ready for pipeline configuration, and follows AWS best practices for security and modularity.

## Architecture Diagram

```mermaid
graph TD
    subgraph Internet["Internet"]
        Users[Users / DevOps Team]
    end
    
    subgraph Public["Public Subnet"]
        EC2[Jenkins EC2 Instance<br/>Ubuntu 22.04<br/>Port 8080: Jenkins<br/>Port 22: SSH]
        EIP[Elastic IP<br/>Static Public IP]
        IGW[Internet Gateway]
    end
    
    subgraph VPC["Custom VPC"]
        RT[Route Table<br/>0.0.0.0/0 → IGW]
        SG[Security Group<br/>Allow 8080 & 22]
    end
    
    Users -->|HTTP:8080| EC2
    Users -->|SSH:22| EC2
    EC2 --> EIP
    EIP --> IGW
    IGW --> RT
    RT --> Public
    
    classDef public fill:#e1f5fe
    classDef vpc fill:#f3e5f5
    class Public,VPC
Traffic Flow

Inbound: Users access Jenkins dashboard via HTTP 8080 or SSH for management
Outbound: Instance reaches internet for package updates (Java/Jenkins installation)
Security: Restricted to specific ports; no unnecessary exposure

Key Features & Best Practices

Modular IaC: Resources separated by concern (networking, security, compute)
Automation: User-data script handles Jenkins setup on first boot (Java + Jenkins installation)
Security: Custom Security Group with inbound rules only for Jenkins (8080) and SSH (22); outbound unrestricted for updates
Static Access: Elastic IP ensures consistent public endpoint
Cost-Effective: t2.micro instance; easy destroy to avoid charges
Parameterization: All values configurable via variables.tf
Verification: Outputs include Jenkins URL, EC2 ID, and VPC details

Deployment Instructions
Prerequisites

AWS account with EC2 and VPC permissions
Terraform ≥ 1.5
AWS CLI configured (aws configure)
SSH key pair named "terraform" (create via AWS Console if needed)

Quick Start
Bash# Clone repository
git clone https://github.com/Migo205/-aws-terraform-jenkins-ci.git
cd -aws-terraform-jenkins-ci

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Deploy (takes ~5-7 minutes)
terraform apply --auto-approve
Post-Deployment

Access Jenkins: Use the output URL (e.g., http://<EIP>:8080)
Retrieve Admin Password: SSH into the instance:Bashssh -i terraform.pem ubuntu@<EIP>
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Configure Jenkins: Paste the password in the setup wizard to complete installation

Testing

Visit Jenkins dashboard → Verify UI loads and initial setup completes
SSH test: ssh ubuntu@<EIP> → Confirm access
Pipeline Ready: Add Jenkinsfile for your CI/CD workflows

Cleanup
Destroy all resources to avoid charges:
Bashterraform destroy --auto-approve
Project Structure





























File/DirectoryDescriptionvariables.tfConfigurable inputs (CIDR, instance type, etc.) with defaultsnetwork.tfVPC, public subnet, IGW, route tablesecurity.tfJenkins Security Group (ports 8080/22)outputs.tfKey outputs: Jenkins URL, EC2 ID, VPC ID, SSH key namescript.shUser-data bash script for Java + Jenkins installation
Troubleshooting

Key Pair Error: Ensure "terraform" key pair exists in your AWS region
Instance Not Reachable: Check Security Group allows inbound 22/8080 from your IP
User-Data Failure: View logs: ssh ubuntu@<EIP> && sudo tail -f /var/log/cloud-init-output.log
Terraform State: Use terraform state list to inspect created resources

Future Enhancements

Integrate Auto Scaling for Jenkins agents
Add IAM roles for Jenkins (S3/ECR access)
Enable HTTPS with ACM certificate
CI/CD pipeline example (Jenkinsfile for building/deploying apps)
Monitoring with CloudWatch alarms

License
MIT License – Free to use, modify, and distribute for educational/commercial purposes.

Terraform v1.5+ | AWS Services: VPC, EC2, Security Groups | Region: us-east-1
