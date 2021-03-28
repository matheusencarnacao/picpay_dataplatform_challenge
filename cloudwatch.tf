resource "aws_cloudwatch_event_rule" "cloudwatch_rule" {
    name = "five_minutes_rule"
    description = "The cloudWatch fires every five minutes"
    schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "event_target" {
    rule = aws_cloudwatch_event_rule.cloudwatch_rule.name
    target_id = var.lambda_function_name
    arn = aws_lambda_function.punk_request.arn
}