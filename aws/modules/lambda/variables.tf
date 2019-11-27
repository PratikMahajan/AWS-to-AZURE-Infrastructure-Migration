variable "sns_topic_name" {}
variable "s3_bucket_name_lambda" {}
variable "lambda_function_name" {}
variable "lamba_handler" {}
variable "lambda_runtime" {}
variable "lambda_memory_size" {}
variable "lambda_reserved_concurrent_executions" {}
variable "lambda_timeout" {}
variable "DB_USER" {
default = ""
}
variable "DB_PASSWORD" {
default = ""
}
variable "DATABASE_NAME" {
default = ""
}
variable "DB_HOST" {
default = ""
}
variable "TTL" {
default = ""
}
variable "ses_domain_name" {
default = ""
}
variable "dynamo_table_name" {
default = ""
}
variable "vpc_subnets" {
default = []
}
variable "aws_lambda_security_group" {
default = ""
}
