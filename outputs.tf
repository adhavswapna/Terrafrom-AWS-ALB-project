output "vpc_id" {
  value = aws_vpc.demo-vpc.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.pub-subnet-1.id,
    aws_subnet.pub-subnet-2.id
  ]
}

output "internet_gateway_id" {
  value = aws_internet_gateway.demo-igw.id
}

output "route_table_id" {
  value = aws_route_table.demo-RT.id
}

output "security_group_id" {
  value = aws_security_group.demo-sg.id
}

output "s3_bucket_id" {
  value = aws_s3_bucket.demo-s3.id
}

output "web_server1_public_ip" {
  value = aws_instance.demo-webserver1.public_ip
}

output "web_server2_public_ip" {
  value = aws_instance.demo-webserver2.public_ip
}

output "load_balancer_dns_name" {
  value = aws_lb.demo-alb.dns_name
}
