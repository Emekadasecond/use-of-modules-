output "fe-sg" {
  value = aws_security_group.frontend-sg.id
}

output "be-sg" {
  value = aws_security_group.backend-sg.id
}

output "pub-key" {
  value = aws_key_pair.key.id
}

