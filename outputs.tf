output "vpc_id" {
  value = aws_vpc.demo-vpc.id
}

output "subnet_ids" {
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

output "load_balancer_dns_name" {
  value = aws_lb.demo-alb.dns_name
}

output "load_balancer_target_group_arn" {
  value = aws_lb_target_group.demo-alb-tg.arn
}
