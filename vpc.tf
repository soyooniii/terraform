# VPC 생성
resource "aws_vpc" "terraform-vpc" {
  cidr_block           = "10.1.0.0/16"

  tags = {
    Name = "terraform-vpc"
  }
}

# Internet Gateway 생성
resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name = "terraform-igw"
  }
}

# EIP 생성
resource "aws_eip" "terraform-eip" {

  tags = {
    Name = "terraform-eip"
  }
}

# NAT 게이트웨이 생성
resource "aws_nat_gateway" "terraform-nat" {
  allocation_id = aws_eip.terraform-eip.id
  subnet_id     = aws_subnet.terraform-bastion.id

  tags = {
    Name = "terraform-nat"
  }

  depends_on = [aws_internet_gateway.terraform-igw]
}

# Bastion Subnet 생성
resource "aws_subnet" "terraform-bastion" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-bastion"
  }
}

# APP Subnet 생성
resource "aws_subnet" "terraform-app-1" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "terraform-app-1"
  }
}

resource "aws_subnet" "terraform-app-2" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.1.12.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "terraform-app-2"
  }
}

# DB Subnet 생성
resource "aws_subnet" "terraform-db-1" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "terraform-db-1"
  }
}

resource "aws_subnet" "terraform-db-2" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.1.13.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "terraform-db-2"
  }
}

# Security Group 생성
resource "aws_security_group" "terraform-bastion-sg" {
  name        = "terraform-bastion-sg"
  description = "only bastion sg"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-bastion-sg"
  }
}

resource "aws_security_group" "terraform-app-sg" {
  name        = "terraform-app-sg"
  description = "only app sg"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.1.1.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-app-sg"
  }
}