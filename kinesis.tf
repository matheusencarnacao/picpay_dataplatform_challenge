resource "aws_kinesis_stream" "stream" {
    name = "stream"
    shard_count = 1
    retention_period = 24

    shard_level_metrics = [ 
        "IncomingBytes",
        "OutgoingBytes"
     ]  
}

resource "aws_kinesis_firehose_delivery_stream" "stream_to_s3" {
    name = "stream_to_s3"
    destination = "s3"
    kinesis_source_configuration {
      kinesis_stream_arn = aws_kinesis_stream.stream.arn
      role_arn = aws_iam_role.firehose_role.arn
    }

    s3_configuration {
      role_arn = aws_iam_role.firehose_role.arn
      bucket_arn = aws_s3_bucket.punk_responses.arn
      prefix = "raw/"
      cloudwatch_logging_options {
        enabled = true
        log_group_name=var.lambda_function_name
        log_stream_name = "stream_to_s3"
      }
    }
}

resource "aws_s3_bucket" "punk_responses" {
    bucket = "punk-responses"
    acl = "private"
}

resource "aws_iam_role" "firehose_role" {
    name = "firehose_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "firehose_stream_policy" {
    name = "firehose_stream_policy"
    role = aws_iam_role.firehose_role.id
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kinesis:Get*",
        "kinesis:DescribeStream"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

