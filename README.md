# ☁️ AWS Infrastructure Provisioning with Terraform

[![Terraform Version](https://img.shields.io/badge/Terraform-v1.0+-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/Cloud-AWS-FF9900?logo=amazonaws)](https://aws.amazon.com/)
[![CI/CD Focus](https://img.shields.io/badge/Automation-Jenkins_Ready-D24939?logo=jenkins)](https://www.jenkins.io/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## 📖 Project Overview

This repository hosts an **Infrastructure as Code (IaC)** solution utilizing **Terraform** to provision a secure and scalable cloud environment on **Amazon Web Services (AWS)**.

The primary objective is to automate the deployment of foundational resources, including network components and an **EC2 instance pre-configured to host a Jenkins CI/CD server**. This demonstrates practices for **Idempotence** and environment consistency.

---

## 🏗️ Architecture Diagram

The following diagram illustrates the key AWS resources provisioned by this configuration and their communication flow:

```mermaid
graph TD
    User((👤 Administrator)) -->|SSH / HTTPS| IGW[Internet Gateway]
    IGW -->|Traffic| VPC[☁️ AWS VPC (main)]
    
    subgraph VPC [Virtual Private Cloud]
        subgraph Public_Subnet [Public Subnet]
            EC2[🖥️ EC2 Instance]
            Jenkins[⚙️ Jenkins Server]
        end
        
        SG[🛡️ Security Group] -.->|Allow Port 22/8080| EC2
    end

    EC2 -->|User Data Script| Jenkins
    
    style VPC fill:#e1f5fe,stroke:#01579b
    style Public_Subnet fill:#fff9c4,stroke:#fbc02d
    style Jenkins fill:#ffccbc,stroke:#bf360c
Note: Security Groups (defined in security.tf) restrict access to only the necessary ports (SSH, HTTP/Jenkins UI) for enhanced security.🔄 Provisioning WorkflowThis sequence diagram details the standard deployment process using the Terraform CLI:مقتطف الرمزsequenceDiagram
    participant Dev as DevOps Engineer
    participant Git as GitHub Repository
    participant TF as Terraform CLI
    participant AWS as AWS Provider

    Dev->>Git: 1. Push Code (.tf files)
    Dev->>TF: 2. terraform init
    TF-->>Dev: Provider Plugins Downloaded
    Dev->>TF: 3. terraform plan
    TF-->>Dev: Review Execution Plan
    Dev->>TF: 4. terraform apply
    TF->>AWS: 🚀 Creates/Updates Resources
    AWS-->>TF: Returns Resource IDs
    TF->>AWS: 📜 Run `jenkins_installation.sh` (User Data)
    TF-->>Dev: ✅ Output: Public IP
📂 Project Structure and ComponentsComponent FileResource Managed / PurposeKey Terraform Conceptmain.tfDefines core network resources (aws_vpc, aws_subnet) and the EC2 instance.Resourcessecurity.tfDefines aws_security_group rules to govern all inbound and outbound traffic.Networking & Securityvariables.tfCentralized location for input values (e.g., instance type, region).Variablesoutputs.tfProvides necessary post-deployment information, such as the public IP address.Outputsjenkins_installation.shA Bash script used as User Data to bootstrap the Jenkins server installation upon EC2 launch.Provisioners🚀 Getting StartedPrerequisitesAWS CLI configured with appropriate access credentials.Terraform CLI installed locally (tested with version 1.0+).Deployment StepsClone the Repository:Bashgit clone [https://github.com/Migo205/terraform_iac.git](https://github.com/Migo205/terraform_iac.git)
cd terraform_iac
Initialize the Working Directory:Bashterraform init
Review and Apply:Bashterraform plan
terraform apply -auto-approve
Access Jenkins:Use the public IP address provided in the output, append port 8080, and access the Jenkins UI: http://<output_public_ip>:8080🛡️ Security and Best PracticesState Management: The .tfstate file is strictly excluded via .gitignore as it contains sensitive state data. In production environments, remote backends (like AWS S3 with DynamoDB locking) must be used.Credentials: AWS credentials should be managed via environment variables or IAM roles, not committed to the repository.📜 LicenseDistributed under the MIT License. See LICENSE for details.Author: Abdulmajeed Mahmoud
