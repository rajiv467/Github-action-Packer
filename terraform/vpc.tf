#Vpc
resource "aws_vpc" "myvpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    tags = {
      "Name" = "myvpc"
      Terraform = true
    }
}
data "aws_availability_zones" "available" {
  state = "available"
}


# Public Subnet
resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.vpc_public_subnet
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true
    tags = {
      "Name" = "Public-subnet"
    }
  
}

#Private Subnet
resource "aws_subnet" "private-subnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.vpc_private_subnet
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = true
    tags = {
      "Name" = "Private-subnet"
    }
  
}

#Internet Gateway

resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      "Name" = "my-igw"
    }
}


#Public TRoute Table

resource "aws_route_table" "public-route_table" {
    depends_on = [aws_internet_gateway.my-igw]
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block ="0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }
    tags = {
      "Name" = "Public-Route-Table"
    }
  
}

#Route Table Association

resource "aws_route_table_association" "public-route-table-association" {
    subnet_id = aws_subnet.public-subnet.id
    route_table_id = aws_route_table.public-route_table.id

  
}

#Elastic IP

resource "aws_eip" "my-eip" {
    vpc = true
    tags = {
      "Name" = "My-eip"
    }
}

#NAT Gatway
resource "aws_nat_gateway" "my-nat-gw" {
    allocation_id = aws_eip.my-eip.id
    subnet_id = aws_subnet.public-subnet.id
    depends_on = [aws_internet_gateway.my-igw]  
    tags = {
      "Name" = "My-Nat"
    }
}

resource "aws_route_table" "private-nat-table" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.my-nat-gw.id
    }
    tags = {
      "Name" = "Private_Nat-Route-Table"
    }
}

resource "aws_route_table_association" "private_nat_table_association" {
    subnet_id = aws_subnet.private-subnet.id
    route_table_id = aws_route_table.private-nat-table.id
  
}