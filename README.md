# AWS 3-Tier High-Availability Web Application Infrastructure

This repository contains **Terraform** code to provision a highly available, multi-AZ **3-Tier Web Application** architecture on **Amazon Web Services (AWS)**.

The infrastructure follows best practices for resilience and security, deploying:
* **Presentation Tier:** Application Load Balancer (ALB) in Public Subnets.
* **Application Tier:** Two EC2 Web Servers in separate Private Subnets.
* **Data Tier:** Multi-AZ RDS MySQL Database Instance in the Private Subnets.

---

## ✨ Key Features

* **High Availability (HA):** All core components (Web Servers, ALB, RDS) are distributed across **two Availability Zones (AZs)**.
* **Security:** Web servers and the database are isolated in **Private Subnets**. Access is controlled via dedicated Security Groups (SGs).
* **Outbound Internet Access:** Dedicated **NAT Gateways** (one per AZ) ensure web servers can perform updates and download packages without being publicly accessible.
* **Infrastructure as Code (IaC):** Full infrastructure lifecycle managed by **Terraform**.
* **Custom Web Server:** Web servers run a basic Apache web page showing the **Instance ID** and **Availability Zone** for easy load balancing verification.

---

## 📐 Architecture Diagram



---

## 🛠️ Components Provisioned

| Component | AWS Resource | Tier | High Availability | Details |
| :--- | :--- | :--- | :--- | :--- |
| **VPC & Networking** | `aws_vpc`, `aws_subnet`, `aws_route_table`, `aws_route_table_association` | Network | Multi-AZ | 2 Public Subnets, 2 Private Subnets across 2 AZs. |
| **Internet Access** | `aws_internet_gateway`, `aws_eip`, `aws_nat_gateway` | Network | Multi-AZ | 1 IGW for public subnets, 2 EIPs & 2 NAT Gateways for private subnets. |
| **Load Balancer** | `aws_lb`, `aws_lb_listener`, `aws_lb_target_group` | Presentation | Multi-AZ | Application Load Balancer (ALB) on HTTP port 80. |
| **Web Servers** | `aws_instance`, `data.aws_ami` | Application | Multi-AZ | 2 x `t2.micro` instances running Ubuntu 22.04 LTS (Apache installed via `user-data`). |
| **Database** | `aws_db_instance`, `aws_db_subnet_group` | Data | Multi-AZ | RDS MySQL 8.0 instance (`db.t3.micro`) with encrypted storage. |
| **Security** | `aws_security_group` | Security | N/A | Dedicated SGs for ALB, Web, and RDS to enforce least-privilege access. |

---

## 🔒 Security Group Rules Summary

| Security Group | Inbound Protocol:Port | Source | Purpose |
| :--- | :--- | :--- | :--- |
| **ALB SG** | HTTP:80 | `0.0.0.0/0` (Internet) | Allows public access to the Load Balancer. |
| **Web SG** | HTTP:80 | `ALB SG ID` | Allows traffic **only** from the Application Load Balancer. |
| **RDS SG** | MySQL:3306 | `Web SG ID` | Allows database connection **only** from the Web Servers. |

---

## 🚀 Getting Started

### Prerequisites

1.  **AWS Account:** You must have an active AWS account.
2.  **AWS CLI Configured:** Ensure the AWS CLI is configured with credentials and access to the target region (the default profile is used in `provider.tf`).
3.  **Terraform:** Install Terraform (v1.0+ recommended).

### Deployment Steps

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/Migo205/terraform_iac.git](https://github.com/Migo205/terraform_iac.git)
    cd terraform_iac
    ```

2.  **Initialize Terraform:**
    ```bash
    terraform init
    ```

3.  **Review the Plan:**
    ```bash
    terraform plan
    ```
    *(Optional: Adjust variables in `variables.tf` if needed, such as region, CIDR blocks, or instance type.)*

4.  **Apply the Configuration:**
    ```bash
    terraform apply
    ```
    Type `yes` to confirm the deployment.

### Accessing the Application

Once the deployment is complete, Terraform will output the public URL.

Check the outputs:
```bash
terraform output
The application can be accessed via the website_url output:http://<ALB-DNS-NAME>CleanupTo destroy all resources and avoid ongoing charges:Bashterraform destroy
Type yes to confirm the destruction.⚙️ Configuration DetailsThe default configuration uses the following values, defined in variables.tf:VariableDefault ValueDescriptionregionus-east-1AWS deployment region.vpc_cidr10.0.0.0/16Main VPC CIDR block.instance_typet2.microEC2 instance size for web servers.availability_zone_1us-east-1aFirst Availability Zone.availability_zone_2us-east-1bSecond Availability Zone.public_subnet_1_cidr10.0.10.0/24Public Subnet 1 CIDR.private_subnet_1_cidr10.0.100.0/24Private Subnet 1 CIDR..........(Note: The RDS password is set to SuperSecret1234 in main.tf for demonstration purposes. Always use a secrets manager or secure variable for production deployments.)
