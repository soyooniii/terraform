# VPC 생성
resource "aws_vpc" "terraformVPC" {
  cidr_block           = "10.1.0.0/16"

  tags = {
    Name = "terraform-vpc"
  }
}

# Internet Gateway 생성
resource "aws_internet_gateway" "terraformIGW" {
  vpc_id = aws_vpc.terraformVPC.id

  tags = {
    Name = "terraform-igw"
  }
}