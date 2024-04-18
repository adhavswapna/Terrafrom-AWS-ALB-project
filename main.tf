## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

## Create VPC
resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "demo-vpc"
  }
}

## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
## Create Subnets
resource "aws_subnet" "pub-subnet-1" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.aws_pub_subnet1
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-subnet-1"
  }
}


resource "aws_subnet" "pub-subnet-2" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.aws_pub_subnet2
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "pub-subnet-2"
  }
}

## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway 
## Create Internet Gatway 
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id
    tags = {
    Name = "demo-igw"
  }
}

## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
## Create route table
resource "aws_route_table" "demo-RT" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id  =  aws_internet_gateway.demo-igw.id

  }
}

## https://registry.terraform.io/providers/hashicorp/aws/3.75.1/docs/resources/route_table_association

resource "aws_route_table_association" "demo-RTA1" {
  subnet_id      = aws_subnet.pub-subnet-1.id
  route_table_id = aws_route_table.demo-RT.id
 
  
}

resource "aws_route_table_association" "demo-RTA2" {
  subnet_id      = aws_subnet.pub-subnet-2.id
  route_table_id = aws_route_table.demo-RT.id
  
}
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
## Create security group
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "demo-sg"
  }
}


## create s3 bucket
#  Generate a random suffix for the bucket name
resource "random_pet" "bucket_suffix" {
  length    = 2
  separator = "-"
}

# Create S3 bucket with a unique name
resource "aws_s3_bucket" "demo-s3" {
  bucket = "demo-s3-${random_pet.bucket_suffix.id}"
}
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl
# Configure public access block settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "demo-s3_public_access_block" {
  bucket = aws_s3_bucket.demo-s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# Create EC2 instance
resource "aws_instance" "demo-webserver1" {
  ami                    = var.aws_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id              = aws_subnet.pub-subnet-1.id
  user_data              = file("userdata1.sh")

  tags = {
    Name = "demo-webserver1"
  }
}

resource "aws_instance" "demo-webserver2" {
  ami                    = var.aws_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id              = aws_subnet.pub-subnet-2.id
  user_data              = file("userdata2.sh")
  tags = {
    Name = "demo-webserver2"
  }
}

## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
## create Application load balancer

resource "aws_lb" "demo-alb" {
  name               = "demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demo-sg.id]
  subnets            = [aws_subnet.pub-subnet-1.id, aws_subnet.pub-subnet-2.id]

  tags = {
    Environment = "web"
  }
}


##https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
## create target_group
resource "aws_lb_target_group" "demo-alb-tg" {
  name        = "demo-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.demo-vpc.id

  health_check {
    path = "/"
    port =  "traffic-port"
  }
  }

## https://registry.terraform.io/providers/hashicorp/aws/2.41.0/docs/resources/lb_target_group_attachment
  ## create target_group attachment
resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.demo-alb-tg.arn
  target_id        = aws_instance.demo-webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb_target_group.demo-alb-tg.arn
  target_id        = aws_instance.demo-webserver2.id
  port             = 80
  }

## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
## create listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.demo-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo-alb-tg.arn
  }
}  



