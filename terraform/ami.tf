resource "aws_ami_from_instance" "redis-ami" {
  name               = "redis-ami"
  source_instance_id = "i-xxxxxxxx"
}
