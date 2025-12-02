# Security Group for the Application Load Balancer – allows inbound HTTP from anywhere
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow inbound HTTP traffic to ALB from the internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "HTTP access from anywhere"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Security Group for Web Tier EC2 instances – allows traffic only from the ALB
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP traffic only from the Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "HTTP from ALB only"
  }

  # Optional: SSH access (commented out – enable only if needed with your IP)
  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["YOUR_PUBLIC_IP/32"]
  #   description = "SSH access (temporary)"
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all outbound traffic (required for updates, package downloads, etc.)"
  }

  tags = {
    Name = "web-sg"
  }
}

# Security Group for RDS MySQL – allows MySQL traffic only from the web tier
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL (3306) inbound traffic only from web tier instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
    description     = "MySQL access from web servers only"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow RDS outbound traffic (updates, replication, etc.)"
  }

  tags = {
    Name = "rds-sg"
  }
}