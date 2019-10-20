output "aws_db_security_group" {
  value = aws_security_group.sgprivatedb.id
}

output "aws_app_security_group" {
  value = aws_security_group.sgpublic.id
}