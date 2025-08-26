

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-${var.env}-main"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_nat_gateway" "private" {
  
  allocation_id = aws_eip.name.id
  connectivity_type = "public"
  subnet_id         =  aws_subnet.public[keys(aws_subnet.public)[0]].id

}


resource "aws_eip" "name" {
  domain       = "vpc"
  tags = {
    name = "${var.project_name}-eip"
  }
}

resource "aws_subnet" "public" {
  for_each          = toset(var.public_subnets_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = element(var.azs, index(var.public_subnets_cidrs, each.value) % length(var.azs))

  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet-${replace(each.value, "/[^a-zA-Z0-9]/", "-")}"
  }
}

resource "aws_subnet" "private" {
  for_each          = toset(var.private_subnets_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = element(var.azs, index(var.private_subnets_cidrs, each.value) % length(var.azs))

  tags = {
    Name = "${var.project_name}-private-subnet-${replace(each.value, "/[^a-zA-Z0-9]/", "-")}"
  }
}

resource "aws_route_table" "public" {
  vpc_id   = aws_vpc.main.id
  
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
      }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id   = aws_vpc.main.id
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.private.id
      }

  tags = {
    Name = "${var.project_name}-private-route-table"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
  
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}




resource "aws_subnet" "db-private" {
  for_each          = toset(var.db_private_subnets_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = element(var.azs, index(var.db_private_subnets_cidrs, each.value) % length(var.azs))

  tags = {
    Name = "${var.project_name}-db-private-subnet-${replace(each.value, "/[^a-zA-Z0-9]/", "-")}"
  }
}

resource "aws_security_group" "aurora_sg" {
  vpc_id = aws_vpc.main.id
  name   = "${var.project_name}-aurora-sg"

  ingress {
    from_port   = 5432 
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.db_private_subnets_cidrs 
  }
}


