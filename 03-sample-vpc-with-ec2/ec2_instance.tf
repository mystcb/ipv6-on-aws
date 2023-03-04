#
# Test EC2 Instance with IPv4 Address
#

#
# Security group for the Test server and its rules below!
#
resource "aws_security_group" "test_sg" {
  name                   = "Test-SG"
  description            = "Security Group for the Test EC2 instance"
  revoke_rules_on_delete = true
  tags = {
    "Name" = "Test-SG"
  }
  vpc_id = aws_vpc.sample_vpc.id
}

# Egress traffic outbound
# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "test_sg_outbound_allow" {
  description       = "Allow traffic to the internet"
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test_sg.id
}

# SSH access for Test Instance
# tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "test_sg_vpn_ssh_allow" {
  description       = "Allow Administration access over SSH"
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test_sg.id
}

# Build the EC2 instance using Amazon Linux 2
resource "aws_instance" "test" {
  ami                     = data.aws_ami.amazon_linux_2.id # Dynamically chosen Amazon Linux AMI
  ebs_optimized           = true                           # EBS Optimised instance
  instance_type           = "t4g.nano"                     # Using a Graviton based instance here
  disable_api_termination = true                           # Always good practice to stop pet instances being terminated

  # Networking settings, setting the private IP to the 10th IP in the subnet, and attaching to the right SG and Subnets
  source_dest_check      = false
  private_ip             = cidrhost(aws_subnet.public_a.cidr_block, 10)
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.test_sg.id]

  # This requires that the metadata endpoint on the instance uses the new IMDSv2 secure endpoint
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Sets the size of the EBS root volume attached to the instance
  root_block_device {
    volume_size           = "8"   # In GB
    volume_type           = "gp3" # Volume Type
    encrypted             = true  # Always best practice to encrypt
    delete_on_termination = true  # Make sure that the volume is deleted on termination
  }

  # Name of the instance, for the console
  tags = {
    "Name" = "Sample-EC2-Instance"
  }

  # Ensures the Internet Gateway has been setup before deploying the instance
  depends_on = [
    aws_internet_gateway.sample_igw
  ]
}

# Set the Elastic IP for the instance, incase it needs to be swapped
resource "aws_eip" "test_eip" {
  vpc                       = true
  instance                  = aws_instance.test.id
  associate_with_private_ip = cidrhost(aws_subnet.public_a.cidr_block, 10)
  depends_on = [
    aws_internet_gateway.sample_igw
  ]
}