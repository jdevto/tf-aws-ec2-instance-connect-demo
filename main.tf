# Generate a random suffix for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  name = "ec2-instance-connect-demo-${random_string.suffix.result}"
}

# Get the current AWS region
data "aws_region" "current" {}

# Fetch the EC2 Instance Connect Managed Prefix List
data "aws_ec2_managed_prefix_list" "ec2_instance_connect" {
  name = "com.amazonaws.${data.aws_region.current.name}.ec2-instance-connect"
}

# Create VPC
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = local.name
  }
}

# Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name}-public"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = local.name
  }
}

# Create Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = "${local.name}-public-rt"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create Security Group for EC2 Instance
resource "aws_security_group" "ssh" {
  name        = "${local.name}-sg"
  description = "Allow SSH and SSM access"
  vpc_id      = aws_vpc.example.id

  # Allow SSH traffic only from EC2 Instance Connect managed prefix list
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.ec2_instance_connect.id]
    description     = "Allow SSH via EC2 Instance Connect"
  }

  # Allow HTTPS for AWS SSM
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS for AWS Systems Manager"
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-sg"
  }
}

# Create IAM Role for EC2 Instance Connect and SSM
resource "aws_iam_role" "ssm_instance_role" {
  name = "${local.name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach Policies to IAM Role
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_instance_role.name
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${local.name}-ssm-profile"
  role = aws_iam_role.ssm_instance_role.name
}

# Fetch Latest Amazon Linux 2 AMI
data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# Create EC2 Instance with EC2 Instance Connect
resource "aws_instance" "jumphost1" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ssh.id]

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Set hostname
    hostnamectl set-hostname jumphost1

    echo "EC2 Instance Connect setup complete."
  EOF

  tags = {
    Name = "${local.name}-jumphost1"
  }
}

# Fetch Latest Amazon Linux 2023 AMI
data "aws_ami" "amzn2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

# Create EC2 Instance with Amazon Linux 2023
resource "aws_instance" "jumphost2" {
  ami                         = data.aws_ami.amzn2023.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ssh.id]

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Set hostname
    hostnamectl set-hostname jumphost2

    # Install & Start AWS SSM Agent (required for Session Manager)
    # Amazon Linux 2023 does NOT come with the SSM Agent pre-installed
    dnf install -y amazon-ssm-agent
    systemctl enable --now amazon-ssm-agent

    echo "EC2 Instance Connect and SSM setup complete."
  EOF

  tags = {
    Name = "${local.name}-jumphost2"
  }
}
