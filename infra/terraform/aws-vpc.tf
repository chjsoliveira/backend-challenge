resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = var.main_vpc
  cidr_block        = "172.31.36.0/24" 
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = var.main_vpc
  cidr_block        = "172.31.37.0/24" 
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.main_vpc

  tags = {
    Name = "private-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.main_vpc

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}


# (Opcional) Criação de uma rota para a sub-rede privada (se necessário)
resource "aws_route_table" "private_rt" {
  vpc_id = var.main_vpc

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_1a_association" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_subnet_1b_association" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.private_rt.id
}
