# Subnet pública 1 para o NAT Gateway
resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = var.main_vpc
  cidr_block        = "172.31.128.0/20"  
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
    "kubernetes.io/role/elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"

  }
}

# Subnet privada 1a
resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = var.main_vpc
  cidr_block        = "172.31.96.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1",
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"

  }
}

# Subnet privada 1b
resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = var.main_vpc
  cidr_block        = "172.31.112.0/20"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-2",
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"

  }
}



# EIP para o NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "nat"
  }
}

# NAT Gateway na subnet pública
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name = "nat"
  }
}

# Tabela de rotas para a sub-rede privada
resource "aws_route_table" "private_rt" {
  vpc_id = var.main_vpc

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id  # Rota para o NAT Gateway
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.main_vpc

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}


resource "aws_route_table_association" "private-us-east-1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-us-east-1b" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public.id
}
