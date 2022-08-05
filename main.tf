##### RESOURCES ######

resource "aws_vpc" "demo_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "demo_vpc"
  }
}

resource "aws_subnet" "demo_pub_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.subnet1_cidr
  availability_zone = var.subnet1_az
  tags = {
    Name = "pub-sub"
  }
}

resource "aws_subnet" "demo_pri_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.subnet2_cidr
  availability_zone = var.subnet2_az
  tags = {
    Name = "pri-sub"
  }
}

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id
  tags = {
    Name = "demo_igw"
  }
}

resource "aws_eip" "demo_eip" {
  vpc = true
  tags = {
    Name = "demo-eip"
  }
}

resource "aws_nat_gateway" "demo_nat" {
  subnet_id     = aws_subnet.demo_pub_subnet.id
  allocation_id = aws_eip.demo_eip.id
  tags = {
    Name = "demo_nat"
  }
}

resource "aws_route_table" "demo_pub_rt" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }
  tags = {
    Name = "demo_pub_rt"
  }
}

resource "aws_route_table" "demo_pri_rt" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.demo_nat.id
  }
  tags = {
    Name = "demo_pri_rt"
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.demo_pub_subnet.id
  route_table_id = aws_route_table.demo_pub_rt.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.demo_pri_subnet.id
  route_table_id = aws_route_table.demo_pri_rt.id
}

resource "aws_security_group" "demo_sg" {
  name   = "demo_security_group"
  vpc_id = aws_vpc.demo_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
         from_port   = 0
         to_port     = 0
         protocol    = "-1"
         cidr_blocks = ["0.0.0.0/0"]
       }
  tags = {
    Name = "demo_sg"
  }
}

resource "aws_instance" "demo_instance1" {
  ami                         = var.ami_id
  instance_type               = var.insta_type
  vpc_security_group_ids      = [aws_security_group.demo_sg.id]
  key_name                    = var.keypair_name
  associate_public_ip_address = "true"
  depends_on                  = [aws_key_pair.demo_key]
  subnet_id                   = aws_subnet.demo_pub_subnet.id
  tags = {
    Name = "demo_instance1"
  }
  user_data = "${file("userdata.sh")}"

}

resource "aws_instance" "demo_instance2" {
  ami                    = var.ami_id
  instance_type          = var.insta_type
  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  key_name               = var.keypair_name
  depends_on             = [aws_key_pair.demo_key]
  subnet_id              = aws_subnet.demo_pri_subnet.id
  tags = {
    Name = "demo_instance2"
  }
  user_data = "${file("userdata.sh")}"
}
resource "tls_private_key" "demo_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "demo_key" {
  key_name   = var.keypair_name
  public_key = tls_private_key.demo_ssh.public_key_openssh
}

resource "local_file" "file" {
  content  = tls_private_key.demo_ssh.private_key_pem
  filename = "keypair_name"
}