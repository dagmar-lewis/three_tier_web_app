output "vpc_id" {
  description = "VPC id."
  value = aws_vpc.main.id
}

output "public_subnets_ids" {
  description = "A list of IDS for the public subnets"
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnets_ids" {
  description = "A list of IDS for the private subnets"
  value = [for s in aws_subnet.private : s.id]
}

output "db_private_subnets_ids" {
  description = "A list of IDS for the private subnets"
  value = [for s in aws_subnet.db-private : s.id]
}



