variable "vpc_cidr_block" {
  description = "Value of the Name tag for the vpc"
  default     = "10.0.0.0/16"
}


variable "aws_pub_subnet1" {
  description = "Value of the Name tag for the vpc"
  default     = "10.0.0.0/24"
}

variable "aws_pub_subnet2" {
  description = "Value of the Name tag for the vpc"
  default     = "10.0.1.0/24"
}
variable "instance_type" {
  description = "Value of the Name tag for the instance type"
  default     = "t2.micro"
}

variable "aws_ami" {
  description = "Value of the Name tag for the AMI"
  default     = "ami-080e1f13689e07408"
}