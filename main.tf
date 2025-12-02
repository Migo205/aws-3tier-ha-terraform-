# Main VPC for the 3-tier architecture
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

# Latest Ubuntu 22.04 LTS AMI (official Canonical images)
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

# Two web servers in separate private subnets (high availability across AZs)
resource "aws_instance" "web" {
  count = 2

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = element([aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id], count.index)
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    AWS_REGION = var.region
  }))

  root_block_device {
    encrypted   = true
    volume_size = 8
  }

  tags = {
    Name = "web-instance-${count.index + 1}"
  }
}

# Target Group for the Application Load Balancer
resource "aws_lb_target_group" "web" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = { Name = "web-target-group" }
}

# Public-facing Application Load Balancer
resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]

  tags = { Name = "web-alb" }
}

# HTTP listener on port 80 (forward traffic to target group)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Attach both web instances to the target group
resource "aws_lb_target_group_attachment" "web" {
  count            = 2
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}

# DB Subnet Group for RDS (uses both private subnets)
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]

  tags = { Name = "main-db-subnet-group" }
}

# Multi-AZ MySQL RDS instance (encrypted storage)
resource "aws_db_instance" "main" {
  identifier        = "webapp-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_encrypted = true
  multi_az          = true

  db_name             = "webapp"
  username            = "admin"
  password            = "SuperSecret1234"
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = { Name = "webapp-db" }
}