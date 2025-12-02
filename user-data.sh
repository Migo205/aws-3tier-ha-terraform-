#!/bin/bash
# Update package index and upgrade all packages
apt update -y && apt upgrade -y

# Install Apache web server
apt install apache2 -y

# Enable and start Apache service
systemctl enable apache2 --now

# Get current Availability Zone and Instance ID from Instance Metadata Service
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Create custom index.html showing server details (helps verify load balancing across AZs)
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>Web Server - 3-Tier Demo</title>
  <style>body {font-family: Arial, sans-serif; text-align: center; margin-top: 50px;}</style>
</head>
<body>
  <h1>Welcome! This is server $(hostname)</h1>
  <p><strong>Region:</strong> ${AWS_REGION}</p>
  <p><strong>Availability Zone:</strong> $AZ</p>
  <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
  <hr>
  <p>3-Tier Architecture with High Availability - ALB + Multi-AZ Web + Multi-AZ RDS</p>
</body>
</html>
EOF

# Restart Apache to serve the new page
systemctl restart apache2