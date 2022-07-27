# Runs at 8am during working days
resource "aws_cloudwatch_event_rule" "test_lambda" {
  name                = "trigger-lambda-scheduler"
  description         = "Trigger lambda scheduler"
  schedule_expression = "cron(0 20 ? * MON-FRI *)"

}

resource "aws_cloudwatch_event_target" "test_lambda" {
  arn  = aws_lambda_function.test_lambda.arn
  rule = aws_cloudwatch_event_rule.test_lambda.name
}

resource "aws_lambda_permission" "test_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  function_name = aws_lambda_function.test_lambda.function_name
  source_arn    = aws_cloudwatch_event_rule.test_lambda.arn
}
 