
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "public-subnet-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "public-subnet-1a"
  }
}

resource "aws_subnet" "private-subnet-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "private-subnet-1a"
  }
}

resource "aws_subnet" "public-subnet-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "public-subnet-1b"
  }
}

resource "aws_subnet" "private-subnet-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "private-subnet-1b"
  }
}
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gw"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
}

resource "aws_route_table_association" "public-rta-1a" {
  subnet_id      = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-rta-1b" {
  subnet_id      = aws_subnet.public-subnet-1b.id
  route_table_id = aws_route_table.public-rt.id
}
