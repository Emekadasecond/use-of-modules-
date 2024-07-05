output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "pub-1" {
  value = aws_subnet.public-subnet.id
}

output "pub-2" {
  value = aws_subnet.public-subnet-2.id
}

output "priv-1" {
  value = aws_subnet.private-subnet.id
}

output "priv-2" {
  value = aws_subnet.private-subnet-2.id
}