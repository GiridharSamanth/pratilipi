
provider "aws" {
  access_key = "AKIAZIN2WSLKORJGMQ5X"
  secret_key = "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"
  region     = "ap-south-1"
}

resource "aws_launch_configuration" "redis-launch" {
  name_prefix   = "redis"
  image_id      = "ami-011bc98513bb0c97f"
  instance_type = "t2.micro"
  security_groups = "${aws_security_group.redis-sg.id}"
}


resource "aws_autoscaling_group" "redis-asg" {
  min_size = 1
  desired_capacity = 2
  max_size = 4
}
