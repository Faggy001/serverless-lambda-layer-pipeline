output "bucket_name" {
  value = aws_s3_bucket.upload_bucket.bucket
}

output "lambda_name" {
  value = aws_lambda_function.lambda_func.function_name
}

output "layer_arn" {
  value = aws_lambda_layer_version.utils_layer.arn
}

output "sns_topic" {
  value = aws_sns_topic.alerts.arn
}

output "dynamodb_table" {
  value = aws_dynamodb_table.file_table.name
}