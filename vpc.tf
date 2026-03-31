
resource "aws_vpc" "medici_network" {
  cidr_block           = var.medici_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "medici_vpc_${var.environment}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.medici_network.id

  tags = {
    Name = "medici_igw_${var.environment}"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.medici_network.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "medici_public_a_${var.environment}"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.medici_network.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "medici_public_b_${var.environment}"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.medici_network.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "medici_private_a_${var.environment}"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.medici_network.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "medici_private_b_${var.environment}"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "medici_nat__${var.environment}"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.medici_network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "medici_public_rt_${var.environment}"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.medici_network.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "medici_private_rt_${var.environment}"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_rt.id
}
