
################################## Create VPC##########################################
resource "aws_vpc" "redis-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "redis-vpc"
  }
}


################################## Create Subnet##########################################
resource "aws_subnet" "redis-subnet" {
  vpc_id     = aws_vpc.redis-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "redis-subnet"
  }
}


################################## Create subnet##########################################
resource "aws_internet_gateway" "redis-igw" {
  vpc_id = aws_vpc.redis-vpc.id

  tags = {
    Name = "redis-igw"
  }
}


################################## Create Route table##########################################
resource "aws_route_table" "redis-route" {
  vpc_id = aws_vpc.redis-vpc.id

  route {
    cidr_block = "10.0.0.0/24"
    gateway_id = aws_internet_redis-igw.id
  }

  route {
    ipv6_cidr_block        = "0.0.0.0/0"
    internet_gatewway_redis-igw_id = 
  }

  tags = {
    Name = "redis-route"
  }
}
