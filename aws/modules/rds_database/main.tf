resource "aws_db_subnet_group" "default" {
  name       = "aws_db_subnet_group"
  subnet_ids = var.subnet_group_id

  tags = {
    Name = "RDS subnet group"
  }
}


resource "aws_db_instance" "default" {
  identifier              = var.db_identifier
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  engine                  = var.database_engine
  engine_version          = var.database_engine_version
  instance_class          = var.instance_class
  name                    = var.db_name
  username                = var.db_username
  password                = var.db_password

  db_subnet_group_name    = aws_db_subnet_group.default.name
  publicly_accessible     = var.publicly_accessible
  vpc_security_group_ids  = var.db_security_group

  skip_final_snapshot     = "true"
}