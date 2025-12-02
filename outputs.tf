# Website URL - Public access point
output "website_url" {
  value       = "http://${aws_lb.web.dns_name}"
  description = "Public URL to access the web application via the ALB"
}

# ALB DNS name
output "alb_dns_name" {
  value       = aws_lb.web.dns_name
  description = "DNS name of the Application Load Balancer"
}

# ALB ARN
output "alb_arn" {
  value       = aws_lb.web.arn
  description = "ARN of the Application Load Balancer"
}

# Target Group ARN
output "target_group_arn" {
  value       = aws_lb_target_group.web.arn
  description = "ARN of the ALB Target Group"
}

# RDS MySQL endpoint
output "rds_endpoint" {
  value       = aws_db_instance.main.endpoint
  description = "RDS instance endpoint (host:port)"
}

# RDS database name
output "rds_database_name" {
  value       = aws_db_instance.main.db_name
  description = "Name of the database created inside the RDS instance"
}

# RDS port (MySQL default)
output "rds_port" {
  value       = aws_db_instance.main.port
  description = "Port on which the RDS instance accepts connections (3306)"
}

# Web EC2 instances details
output "web_instances" {
  value = [
    for instance in aws_instance.web : {
      instance_id       = instance.id
      instance_name     = instance.tags["Name"]
      private_ip        = instance.private_ip
      availability_zone = instance.availability_zone
      public_ip         = instance.public_ip != "" ? instance.public_ip : "N/A (private instance)"
    }
  ]
  description = "List of web tier EC2 instances with their IDs, names, private IPs and AZs"
}

# VPC ID
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the main VPC"
}

# Public subnets IDs
output "public_subnet_ids" {
  value       = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  description = "IDs of the public subnets"
}

# Private subnets IDs
output "private_subnet_ids" {
  value       = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  description = "IDs of the private subnets"
}

# Project completion message
output "project_status" {
  value       = "3-Tier High-Availability Architecture deployed successfully (ALB + EC2 in 2 AZs + Multi-AZ RDS)"
  description = "Deployment confirmation message"
}