# RDS data base
resource "aws_db_instance" "db-main" {
  allocated_storage    = 10
  db_name              = "wordpress"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "admin123"
  parameter_group_name = "default.mysql8.0"
  vpc_security_group_ids = [ var.security_groups ]
  db_subnet_group_name = aws_db_subnet_group.db-subnet.id
  multi_az = true
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "db-subnet" {
  name       = "db-subnet"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "flexdbg"
  }
}