

data "archive_file" "stop_scheduler" {
  type        = "zip"
  source_file = "lambda_function_payload.py"
  output_path = "lambda_function_payload.zip"
}



### IAM Role and Policy ###
# Allows Lambda function to describe, stop and start EC2 instances
resource "aws_iam_role" "ec2_start_stop_scheduler" {
  name               = "ec2_start_stop_scheduler"
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

resource "aws_lambda_function" "test_lambda" {
  filename      = data.archive_file.stop_scheduler.output_path
  function_name = "ec2_start_stop_scheduler"
  role          = aws_iam_role.ec2_start_stop_scheduler.arn
  handler       = "lambda_function.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  # source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.7"

  environment {
    variables = {
      instance = aws_instance.web[0].id
    }
  }
} 