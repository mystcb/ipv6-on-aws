#
# Private Routing for the VPC
#

# IPv6 Egress-only Internet Gateway
resource "aws_egress_only_internet_gateway" "sample_ipv6_egress_igw" {
  vpc_id = aws_vpc.sample_vpc.id

  tags = {
    "Name" = "Sample-VPC-IPv6-Egress-Only-IGW"
  }
}

# Define two Elastic IP's for the NAT Gateways
resource "aws_eip" "natgwip" {
  count = 2
}

# Creation of the NAT Gateway for Subnet A
resource "aws_nat_gateway" "sample_natgw_subnet_a" {
  allocation_id = aws_eip.natgwip[0].id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "NAT GW - Subnet A"
  }

  # Ensure that the IGW is loaded before the NATGW is provisioned
  depends_on = [
    aws_internet_gateway.sample_igw
  ]
}

# Creation of the NAT Gateway for Subnet B
resource "aws_nat_gateway" "sample_natgw_subnet_b" {
  allocation_id = aws_eip.natgwip[1].id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "NAT GW - Subnet B"
  }

  # Ensure that the IGW is loaded before the NATGW is provisioned
  depends_on = [
    aws_internet_gateway.sample_igw
  ]
}

# Primary Sample Route Table for Private Subnet A
resource "aws_route_table" "private_rt_a" {
  vpc_id = aws_vpc.sample_vpc.id

  tags = {
    "Name" = "Private-Route-Table-A"
  }
}

# Primary Sample Route Table for Private Subnet B
resource "aws_route_table" "private_rt_b" {
  vpc_id = aws_vpc.sample_vpc.id

  tags = {
    "Name" = "Private-Route-Table-B"
  }
}

# Route for Subnet A to access the NAT Gateway
resource "aws_route" "private2natgwa" {
  route_table_id         = aws_route_table.private_rt_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.sample_natgw_subnet_a.id
}

# Route for Subnet B to access the NAT Gateway
resource "aws_route" "private2natgwb" {
  route_table_id         = aws_route_table.private_rt_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.sample_natgw_subnet_b.id
}

# Route for Subnet A to access the Egress-Only Internet Gateway
resource "aws_route" "private2ipv6egressigwa" {
  route_table_id              = aws_route_table.private_rt_a.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.sample_ipv6_egress_igw.id
}

# Route for Subnet B to access the Egress-Only Internet Gateway
resource "aws_route" "private2ipv6egressigwb" {
  route_table_id              = aws_route_table.private_rt_b.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.sample_ipv6_egress_igw.id
}

# Associate the route tables with the two private subnets
resource "aws_route_table_association" "private-rt-sb-association-a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt_a.id
}

resource "aws_route_table_association" "private-rt-sb-association-b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt_b.id
}