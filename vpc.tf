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

# EIP 생성
resource "aws_eip" "terraformEIP" {

  tags = {
    Name = "terraform-eip"
  }
}

# NAT 게이트웨이 생성
resource "aws_nat_gateway" "terraformNAT" {
  allocation_id = aws_eip.terraform-eip.id
  subnet_id     = aws_subnet.terraformSN-Bastion.id

  tags = {
    Name = "terraform-nat"
  }

  depends_on = [aws_internet_gateway.terraformIGW]
}

# Bastion Subnet 생성
resource "aws_subnet" "terraformSN-Bastion" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraformSN-Bastion"
  }
}

# APP Subnet 생성
resource "aws_subnet" "terraformSN-App-1" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "terraformSN-App-1"
  }
}

resource "aws_subnet" "terraformSN-App-2" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.1.12.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "terraformSN-App-2"
  }
}

# DB Subnet 생성
resource "aws_subnet" "terraformSN-DB-1" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "terraformSN-DB-1"
  }
}

resource "aws_subnet" "terraformSN-DB-2" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.1.13.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "terraformSN-DB-2"
  }
}

# Security Group 생성
resource "aws_security_group" "terraformSG-bastion" {
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
    Name = "terraformSG-bastion"
  }
}

resource "aws_security_group" "terraformSG-App" {
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

  ingress {
    description      = "web application"
    from_port        = 8080
    to_port          = 8080
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
    Name = "terraformSG-App"
  }
}


resource "aws_security_group" "terraformSG-DB" {
  name        = "terraform-db-sg"
  description = "only db sg"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 3306
    to_port          = 3306
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
    Name = "terraformSG-DB"
  }
}