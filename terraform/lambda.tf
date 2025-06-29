
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../lambda-archive"
  output_path = "../lambda-archive/lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_func" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_exec_role.arn
  runtime          = "python3.11"
  handler          = "handler.handler"
  timeout          = 30
  memory_size      = 128

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256


  layers = [aws_lambda_layer_version.utils_layer.arn]

  environment {
    variables = {
      BUCKET_PATH     = "${var.bucket_name}/inbound/"
      DYNAMODB_TABLE  = var.dynamodb_table_name
      SNS_TOPIC_ARN   = aws_sns_topic.alerts.arn
    }
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_func.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.upload_bucket.arn
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.upload_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_func.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "inbound/"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
