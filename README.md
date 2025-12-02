Markdown# ☁️ AWS Infrastructure Automation with Terraform

![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Infrastructure-FF9900?logo=amazonaws)
![Jenkins](https://img.shields.io/badge/CI%2FCD-Jenkins-D24939?logo=jenkins)
![License](https://img.shields.io/badge/License-MIT-green)

## 📖 Overview | نظرة عامة
This project represents a professional approach to **Infrastructure as Code (IaC)**. It automates the provisioning of a secure and scalable infrastructure on **AWS**, specifically designed to host a **Jenkins CI/CD Server**.

The goal is to eliminate manual configuration (ClickOps) and ensure **Idempotence** and consistency across environments.

---

## 🏗️ Architecture Diagram | البنية التحتية
Here is a visual representation of the resources created by the Terraform scripts and how they communicate:

```mermaid
graph TD
    User((👤 Admin)) -->|SSH / HTTP| IGW[Gateway]
    IGW -->|Traffic| VPC[☁️ AWS VPC]
    
    subgraph VPC [Virtual Private Cloud]
        subgraph Public_Subnet [🔓 Public Subnet]
            EC2[🖥️ EC2 Instance]
            Jenkins[⚙️ Jenkins Server]
        end
        
        SG[🛡️ Security Group] -.->|Allow Port 22/8080| EC2
    end

    EC2 -->|User Data Script| Jenkins
    
    style VPC fill:#e1f5fe,stroke:#01579b
    style Public_Subnet fill:#fff9c4,stroke:#fbc02d
    style Jenkins fill:#ffccbc,stroke:#bf360c
Note: The security.tf file defines the firewall rules (Security Groups) allowing access only to necessary ports (SSH & Jenkins UI).🔄 Provisioning Workflow | سير العملThis diagram explains the lifecycle of the infrastructure provisioning process:مقتطف الرمزsequenceDiagram
    participant Dev as 👨‍💻 DevOps Eng.
    participant Git as 🐙 GitHub
    participant TF as 🏗️ Terraform
    participant AWS as ☁️ AWS Cloud

    Dev->>Git: 1. Push Code (.tf files)
    Dev->>TF: 2. terraform init
    TF-->>Dev: Plugins Installed
    Dev->>TF: 3. terraform plan
    TF-->>Dev: Review Execution Plan 📋
    Dev->>TF: 4. terraform apply
    TF->>AWS: 🚀 Provision Resources (EC2, VPC, SG)
    AWS-->>TF: Resources ID / IP
    TF->>AWS: 📜 Run `jenkins_installation.sh`
    TF-->>Dev: ✅ Output: Public IP
📂 Project Structure | هيكل المشروعFile NameDescriptionmain.tfThe core configuration file defining the Provider (AWS) and main resources.variables.tfContains variable definitions to make the code reusable and dynamic.security.tfDefines aws_security_group rules to control inbound/outbound traffic.outputs.tfDisplays important info (like EC2 Public IP) after deployment.jenkins_installation.shBash script injected into EC2 user_data to install & start Jenkins automatically.🚀 Getting Started | طريقة التشغيلPrerequisitesTerraform installed locally.AWS CLI configured with valid credentials.StepsClone the repository:Bashgit clone [https://github.com/Migo205/terraform_iac.git](https://github.com/Migo205/terraform_iac.git)
cd terraform_iac
Initialize Terraform:Bashterraform init
Plan and Apply:Bashterraform plan
terraform apply -auto-approve
Access Jenkins:Copy the public_ip from the output and open in browser:http://<your-ec2-ip>:8080⚠️ Best Practices UsedModularization: Code is split into logical files (security, main, variables) for better readability.Automation: Jenkins installation is fully automated via shell scripting within Terraform.Security: State files (.tfstate) and secrets are excluded from Git via .gitignore.
