#
# Public Routing for the VPC
#

# Creation of the IGW in the sample VPC
resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample_vpc.id

  tags = {
    "Name" = "Sample-VPC-IGW"
  }
}

# Primary Sample Route Table (Public)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.sample_vpc.id

  tags = {
    "Name" = "Public-Route-Table"
  }
}

# Route entry specifically to allow access to the Internet Gateway
resource "aws_route" "public2igw" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sample_igw.id
}

# Associate the route tables with the two public subnets
resource "aws_route_table_association" "public-rt-sb-association-a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public-rt-sb-association-b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}