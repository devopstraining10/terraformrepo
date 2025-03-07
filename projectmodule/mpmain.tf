provider "aws" {
  region = "us-east-1"
}

###create vpc
 
 resource "aws_vpc" "prod-vpc" {
    cidr_block = var.vpc_cidr_block
 tags = {
  Name = "prod-vpc"
 }
 }

 ##create igw

 resource "aws_internet_gateway" "prod-igw" {
    vpc_id = aws_vpc.prod-vpc.id
   tags = {
     Name = "prod-igw"
    
   }
 }

 ## create subnet

 resource "aws_subnet" "prod-subnet" {
    vpc_id = aws_vpc.prod-vpc.id
   cidr_block = var.sn_cidr_block

   tags = {
     Name = "prod-subnet"

   }
 }

 ## create rt

 resource "aws_route_table" "prod-rt" {
    vpc_id = aws_vpc.prod-vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prod-igw.id

    }
 }

 ### rt association

 resource "aws_route_table_association" "prod-rt-association" {
  subnet_id      = aws_subnet.prod-subnet.id
  route_table_id = aws_route_table.prod-rt.id

  
}

# create sg
resource "aws_security_group" "prod-sg" {
  vpc_id = aws_vpc.prod-vpc.id


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    
    ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "prod-ni" {
  subnet_id       = aws_subnet.prod-subnet.id
  private_ips     = ["10.81.1.11"]
  security_groups = [aws_security_group.prod-sg.id]

  
}

resource "aws_eip" "prod-eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.prod-ni.id
  associate_with_private_ip = "10.81.1.11"
  }

  resource "aws_instance" "ser10" {
  ami = var.ami
  key_name = var.key_name
  instance_type = var.instance_type     

user_data = "${file("shellscript.sh")}"

  network_interface {
   network_interface_id = aws_network_interface.prod-ni.id
   device_index = 0
}

  tags = {
    Name = "ser10"
  }

}

variable "ami" {
  
}

variable "key_name" {
  
}

variable "instance_type" {
  
}

variable "vpc_cidr_block" {
  
}

variable "sn_cidr_block" {
  
}