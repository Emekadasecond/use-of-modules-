# Create frontend Security Group
resource "aws_security_group" "frontend-sg" {
  name        = "frontend-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "flex-sg-fe"
  }
}

# Create Backend Security Group
resource "aws_security_group" "backend-sg" {
  name        = "backend-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc
  ingress {
    description     = "MYSQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend-sg.id]
  }
  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "flex-sg-be"
  }
}

# key pair
resource "aws_key_pair" "key" {
  key_name   = "flex-keypair"
  public_key = tls_private_key.key.public_key_openssh 
}
 
 # RSA key of size 4096 bits
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "key" {
  content  = tls_private_key.key.private_key_pem
  filename = "flex-keypair.pem"
  file_permission = 400
}