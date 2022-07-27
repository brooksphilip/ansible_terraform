resource "aws_subnet" "main" {
  vpc_id     = "vpc-a6064ddc"
  cidr_block = "172.31.2.0/24"

  tags = {
    Name = "Main"
  }
}