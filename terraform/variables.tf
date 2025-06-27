variable "region" {
  description = "AWS region"
  default     = "ca-central-1"
}

variable "profile" {
  description = "AWS CLI profile"
  default     = "default"
}

variable "bucket_name" {
  description = "S3 bucket name"
  default     = "groupb-layered-bucket"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  default     = "layered-lambda-handler"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  default     = "FileMetadata"
}

variable "notification_email" {
  description = "Email for SNS alerts"
  default     = "faggy29@gmail.com"
}