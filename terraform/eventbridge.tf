resource "aws_cloudwatch_event_rule" "daily" {
  name                = "daily-report-schedule"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "target" {
  rule = aws_cloudwatch_event_rule.daily.name
  arn  = aws_lambda_function.report.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.report.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily.arn
}
resource "aws_cloudwatch_event_rule" "data_ingestion" {
  name        = "data-ingestion-rule"
  description = "Triggers data processor Lambda on incoming application events"

  event_pattern = jsonencode({
    source      = ["custom.application"]
    detail-type = ["data.created"]
  })
}

resource "aws_cloudwatch_event_target" "processor_target" {
  rule = aws_cloudwatch_event_rule.data_ingestion.name
  arn  = aws_lambda_function.processor.arn
}

resource "aws_lambda_permission" "allow_eventbridge_processor" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.data_ingestion.arn
}
