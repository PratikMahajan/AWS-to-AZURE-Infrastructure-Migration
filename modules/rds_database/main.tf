resource "aws_db_instance" "default" {
  identifier           = var.db_identifier
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.database_engine
  engine_version       = var.database_engine_version
  instance_class       = var.instance_class
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password

  db_subnet_group_name = var.subnet_group
  publicly_accessible  = var.publicly_accessible
}