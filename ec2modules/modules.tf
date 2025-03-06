provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ser" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name

  tags = {
    Name = "ser"
  }


}

variable "ami" {
  
}

variable "instance_type" {
  
}

variable "key_name" {
  
}

