resource "aws_lambda_function" "processor" {
  function_name = "${var.project_name}-processor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "data_processor.lambda_handler"
  runtime       = "python3.10"

  filename         = "../lambda/data_processor.zip"
  source_code_hash = filebase64sha256("../lambda/data_processor.zip")
environment {
  variables = {
    BUCKET_NAME = aws_s3_bucket.data_bucket.bucket
  }
}
}

resource "aws_lambda_function" "report" {
  function_name = "${var.project_name}-daily-report"
  role          = aws_iam_role.lambda_role.arn
  handler       = "daily_report.lambda_handler"
  runtime       = "python3.10"

  filename         = "../lambda/daily_report.zip"
  source_code_hash = filebase64sha256("../lambda/daily_report.zip")
}
