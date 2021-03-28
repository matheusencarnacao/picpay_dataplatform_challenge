resource "aws_lambda_function" "punk_request" {
    filename = "punk_request.zip"
    function_name = var.lambda_function_name
    description = "Python Lambda Function that consume the Punk API"
    role = aws_iam_role.iam_for_lambda.arn
    handler = var.lambda_handler
    runtime = "python3.8"
    timeout = 60
    memory_size = 128
    depends_on = [ aws_iam_role_policy_attachment.lambda_logs ]
}

resource "aws_lambda_permission" "allow_cloudwatch_trigger" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:invokeFunction"
  function_name = aws_lambda_function.punk_request.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.cloudwatch_rule.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"
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


resource "aws_iam_policy" "lambda_logging" {
  name = "lambda-logging"
  path = "/"
  description = "IAM policy for logging from Lambda"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": "kinesis:PutRecords",
      "Resource": "*"
    }
  ]
}
EOF
}