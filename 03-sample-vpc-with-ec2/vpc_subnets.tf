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