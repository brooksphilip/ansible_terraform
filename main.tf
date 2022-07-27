terraform {
  backend "s3" {
    bucket = "terraformstatephilipbrooks"
    access_key    = "<ACCESS_KEY>"
    secret_key = "<SECRET_KEY>
    region = "us-east-1"
    key    = "terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}



resource "aws_instance" "web" {
  ami                         = "ami-04bb231c2ecea338c"
  instance_type               = "t2.micro"
  key_name                    = <KEY_NAME>
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = "true"
  count                       = 2


  vpc_security_group_ids = [aws_security_group.web.id]
  tags = {
    Name = "MyFirstTerraform"
  }
}


resource "aws_security_group" "web" {
  name        = "web-security-group"
  description = "first terraform shit"
  vpc_id      = "vpc-a6064ddc"

  ingress {
    description = "allow ssh traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow http traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow https traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow http traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow https traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "address" {
  value = aws_instance.web.*.public_dns
}

