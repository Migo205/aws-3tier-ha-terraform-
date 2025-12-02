# AWS region for the entire deployment
variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

# CIDR block for the main VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Name tag for the VPC
variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "3tier-vpc"
}

# Public subnet in AZ1 (used for ALB and NAT Gateway)
variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet in availability zone 1"
  type        = string
  default     = "10.0.10.0/24"
}

# Public subnet in AZ2 (used for ALB and NAT Gateway)
variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet in availability zone 2"
  type        = string
  default     = "10.0.20.0/24"
}

# Private subnet in AZ1 (used for web servers and RDS)
variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet in availability zone 1 (application tier)"
  type        = string
  default     = "10.0.100.0/24"
}

# Private subnet in AZ2 (used for web servers and RDS)
variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet in availability zone 2 (application tier)"
  type        = string
  default     = "10.0.200.0/24"
}

# Availability zone 1
variable "availability_zone_1" {
  description = "First availability zone (e.g., us-east-1a)"
  type        = string
  default     = "us-east-1a"
}

# Availability zone 2
variable "availability_zone_2" {
  description = "Second availability zone (e.g., us-east-1b)"
  type        = string
  default     = "us-east-1b"
}

# EC2 instance type for web servers
variable "instance_type" {
  description = "EC2 instance type for the web tier"
  type        = string
  default     = "t2.micro"
}