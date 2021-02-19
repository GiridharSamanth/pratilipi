resource "aws_instance" "redis-master1" {
  ami           = "ami-073c8c0760395aab8"
  instance_type = "t2.micro"
  vpc_id = "vpc_id"
  security_groups = ["${aws_security_group.test_security_grp.name}"]
  tags = {
   Name = "redis-master1"
 }
}
