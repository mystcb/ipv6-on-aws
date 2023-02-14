# Creation of the sample VPC for the region
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "sample_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = "Sample-VPC"
  }
}