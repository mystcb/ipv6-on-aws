#
# Subnets
#

# Public Subnet A
resource "aws_subnet" "public_a" {
  vpc_id               = aws_vpc.sample_vpc.id
  ipv6_cidr_block      = cidrsubnet(aws_vpc.sample_vpc.ipv6_cidr_block, 8, 0)
  cidr_block           = cidrsubnet(aws_vpc.sample_vpc.cidr_block, 4, 10)
  availability_zone_id = data.aws_availability_zones.available.zone_ids[0]
  tags = {
    "Name" = "Public-Subnet-A"
  }
}

# Public Subnet B
resource "aws_subnet" "public_b" {
  vpc_id               = aws_vpc.sample_vpc.id
  ipv6_cidr_block      = cidrsubnet(aws_vpc.sample_vpc.ipv6_cidr_block, 8, 1)
  cidr_block           = cidrsubnet(aws_vpc.sample_vpc.cidr_block, 4, 11)
  availability_zone_id = data.aws_availability_zones.available.zone_ids[1]
  tags = {
    "Name" = "Public-Subnet-B"
  }
}

# Private Subnet A
resource "aws_subnet" "private_a" {
  vpc_id               = aws_vpc.sample_vpc.id
  ipv6_cidr_block      = cidrsubnet(aws_vpc.sample_vpc.ipv6_cidr_block, 8, 2)
  cidr_block           = cidrsubnet(aws_vpc.sample_vpc.cidr_block, 4, 12)
  availability_zone_id = data.aws_availability_zones.available.zone_ids[0]
  tags = {
    "Name" = "Private-Subnet-A"
  }
}

# Private Subnet B
resource "aws_subnet" "private_b" {
  vpc_id               = aws_vpc.sample_vpc.id
  ipv6_cidr_block      = cidrsubnet(aws_vpc.sample_vpc.ipv6_cidr_block, 8, 3)
  cidr_block           = cidrsubnet(aws_vpc.sample_vpc.cidr_block, 4, 13)
  availability_zone_id = data.aws_availability_zones.available.zone_ids[1]
  tags = {
    "Name" = "Private-Subnet-B"
  }
}