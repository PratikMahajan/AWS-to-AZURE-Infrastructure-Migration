resource "aws_sns_topic" "default" {
  name = "email_request"
}

resource "aws_iam_role" "lambda" {
  name = "iam_for_lambda_with_sns"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "ses_attachment" {
  role  = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamoDB_attachment" {
  role  = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

data "archive_file" "dummy" {
  type = "zip"
  output_path = "${path.module}/lambda_function_payload.zip"

  source {
    content = "hello"
    filename = "dummy.txt"
  }
}

resource "aws_lambda_function" "func" {
  filename                       = "${data.archive_file.dummy.output_path}"
  function_name                  = var.lambda_function_name
  role                           = "${aws_iam_role.lambda.arn}"
  handler                        = var.lamba_handler
  runtime                        = var.lambda_runtime
  memory_size                    = var.lambda_memory_size
  source_code_hash               = filebase64sha256("${data.archive_file.dummy.output_path}")
  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions
  timeout                        = var.lambda_timeout
  environment {
    variables =  {
      DB_USER       = var.DB_USER
      DB_PASSWORD   = var.DB_PASSWORD
      DATABASE_NAME = var.DATABASE_NAME
      DB_HOST       = var.DB_HOST
      DOMAIN        = var.ses_domain_name
      TABLE         = var.dynamo_table_name
      TTLinSec      = var.TTL
    }
  }
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.func.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.default.arn}"
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = "${aws_sns_topic.default.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.func.arn}"
}


