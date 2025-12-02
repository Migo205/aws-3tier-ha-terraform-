# AWS 3-Tier High Availability Infrastructure with Terraform
A complete infrastructure as code project using Terraform to deploy a highly available 3-tier architecture on AWS. This project provides a secure, scalable, and production-ready environment for web applications.

## Architecture Overview

### Core Components
* **Web Tier:** Application Load Balancer (ALB) with Auto Scaling Groups of EC2 instances
* **Application Tier:** Internal Application Load Balancer (IALB) with EC2 instances in private subnets
* **Data Tier:** Multi-AZ RDS database with read replicas and automated backups
* **Networking:** Secure VPC architecture with public and private subnets across multiple availability zones

## Features
* **High Availability:** Multi-AZ deployment across 3 availability zones
* **Auto Scaling:** Automatic scaling of web and application tiers based on demand
* **Security:** Network segmentation, security groups, and IAM roles with least privilege
* **Disaster Recovery:** Automated backups and multi-AZ failover for database tier
* **Infrastructure as Code:** Complete environment defined in Terraform for reproducibility
* **Monitoring:** CloudWatch alarms and logging configured for all components

## Prerequisites

### Required Tools
* Terraform 1.0+
* AWS CLI 2.0+
* Git

### AWS Requirements
* AWS Account with appropriate permissions
* IAM user with programmatic access
* Key Pair for EC2 instances

## Quick Start
1. Clone Repository
`git clone https://github.com/Migo205/aws-3tier-ha-terraform-.git`
`cd aws-3tier-ha-terraform-`
2. Configure AWS Credentials
`aws configure`
`# Or set environment variables:`
`export AWS_ACCESS_KEY_ID="your-access-key"`
`export AWS_SECRET_ACCESS_KEY="your-secret-key"`
`export AWS_DEFAULT_REGION="us-east-1"`
3. Initialize Terraform
`terraform init`
4. Review Execution Plan
`terraform plan -var-file="terraform.tfvars"`
5. Deploy Infrastructure
`terraform apply -var-file="terraform.tfvars"`

## Project Structure
`aws-3tier-ha-terraform-/`
`├── main.tf             # Main Terraform configuration`
`├── variables.tf        # Variable definitions`
`├── outputs.tf          # Output values`
`├── terraform.tfvars    # Variable values (create from terraform.tfvars.example)`
`├── modules/`
`│   ├── networking/     # VPC, subnets, route tables`
`│   ├── compute/        # EC2 instances, ALB, Auto Scaling`
`│   ├── database/       # RDS configuration`
`│   └── security/       # Security groups, IAM roles`
`└── scripts/`
`    ├── user-data/      # Bootstrap scripts for EC2 instances`
`    └── monitoring/     # Monitoring and alert scripts`

## Configuration

### Required Variables
Create a `terraform.tfvars` file with the following variables:
`# AWS Configuration`
`aws_region = "us-east-1"`
`project_name = "my-3tier-app"`
`environment = "production"`
`# Network Configuration`
`vpc_cidr = "10.0.0.0/16"`
`availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]`
`# Instance Configuration`
`web_instance_type = "t3.medium"`
`app_instance_type = "t3.medium"`
`web_instance_count = 2`
`app_instance_count = 2`
`# Database Configuration`
`db_instance_class = "db.t3.medium"`
`db_name = "application_db"`
`db_username = "admin"`
`# db_password should be provided securely`

### Optional Variables
* `enable_cloudwatch_alarms`: Enable CloudWatch alarms (default: true)
* `enable_auto_scaling`: Enable Auto Scaling policies (default: true)
* `backup_retention_period`: RDS backup retention in days (default: 7)
* `monitoring_email`: Email for CloudWatch notifications

## Infrastructure Details

### Networking
* VPC with CIDR block configuration
* Public and private subnets in each availability zone
* Internet Gateway and NAT Gateway
* Route tables with appropriate routing
* VPC endpoints for AWS services

### Security
* Security groups for each tier with minimum required access
* IAM roles with instance profiles
* Database security with encryption at rest and in transit
* Network ACLs for additional layer of security

### Compute
* Launch templates for consistent instance configuration
* Auto Scaling groups with health checks
* Application Load Balancer (public facing)
* Internal Load Balancer (application tier)

### Database
* Amazon RDS (MySQL/PostgreSQL) with Multi-AZ deployment
* Automated backups with point-in-time recovery
* Read replicas for read scalability
* Parameter groups for database optimization

## Outputs
After deployment, Terraform will output:
* web_alb_dns_name: DNS name for the web load balancer
* vpc_id: VPC ID
* database_endpoint: RDS endpoint
* bastion_host_public_ip: Bastion host public IP (if enabled)
* cloudwatch_dashboard_url: CloudWatch dashboard URL

## Operations

### Scaling
`# Update Auto Scaling group desired capacity`
`terraform apply -var="web_instance_count=4" -var-file="terraform.tfvars"`

### Updates
`# Update infrastructure with new configuration`
`terraform plan -var-file="terraform.tfvars"`
`terraform apply -var-file="terraform.tfvars"`

### Destruction
`# Destroy all resources (use with caution)`
`terraform destroy -var-file="terraform.tfvars"`

## Monitoring and Maintenance

### CloudWatch Metrics
* CPU utilization for all instances
* Database connection count and latency
* Load balancer request count and latency
* Auto Scaling group metrics

### Logging
* VPC Flow Logs for network traffic
* CloudTrail for API calls
* RDS performance insights
* Application logs via CloudWatch Logs

## Security Considerations
* Secrets Management: Use AWS Secrets Manager or Parameter Store for database credentials
* Key Rotation: Implement regular key rotation for EC2 key pairs
* IAM Least Privilege: Regularly review IAM policies and permissions
* Security Updates: Enable automatic security updates for EC2 instances
* Network Monitoring: Monitor VPC Flow Logs for suspicious activity

## Cost Optimization
* Use Spot Instances for non-critical workloads
* Implement Auto Scaling to scale down during off-peak hours
* Use reserved instances for baseline capacity
* Clean up unused resources regularly
* Monitor cost using AWS Cost Explorer

## Troubleshooting

### Common Issues
* **Terraform State Errors**
    * Use `terraform init -reconfigure` to reinitialize
    * Check state file permissions
* **AWS Rate Limiting**
    * Implement exponential backoff in automation scripts
    * Contact AWS support for limit increases
* **Connection Issues**
    * Verify security group rules
    * Check route tables and NACLs
    * Validate VPC endpoints

### Log Locations
* Terraform logs: Check `terraform.tfstate` and `terraform.tfstate.backup`
* AWS CLI logs: `aws logs describe-log-groups`
* Instance logs: Connect via Session Manager or SSH

## Contributing
* Fork the repository
* Create a feature branch (`git checkout -b feature/improvement`)
* Commit changes (`git commit -am 'Add new feature'`)
* Push to branch (`git push origin feature/improvement`)
* Create Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Support
For issues, questions, or contributions:
* Check existing issues on GitHub
* Create a new issue with detailed description
* Contact maintainers for critical issues

## References
* AWS Terraform Provider Documentation
* AWS Well-Architected Framework
* Terraform Best Practices
