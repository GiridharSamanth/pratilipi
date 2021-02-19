

variable "instance_count" {
  default = "5"
}


variable "instance_type" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_tags" {
  type = "list"
  default = ["redis-master2", "redis-master3", "redis-slave1", "redis-slave2", "redis-slave3"]
}
