resource "aws_security_group" "my-asg-sg" {
  name = "my-asg-sg"
  vpc_id = "${aws_vpc.redis-vpc.id}"

# allow ingress of port 22
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # personal-ip
  }
  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #private-ip
  }
  ingress {
    from_port = 16379
    to_port = 16379
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # private-ip
  }
  # allow egress of all ports
  egress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # private-ip
  }
  egress {
    from_port = 16379
    to_port = 16379
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
   Name = "My VPC Security Group"
   Description = "My VPC Security Group"
}
}
