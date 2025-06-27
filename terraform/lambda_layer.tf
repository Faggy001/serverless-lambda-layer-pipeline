data "archive_file" "lambda_layer" {
  type        = "zip"
  source_dir  = "${path.module}/../layer"
  output_path = "${path.module}/../layer-archive/layer.zip"
}

resource "aws_lambda_layer_version" "utils_layer" {
  layer_name          = "utils-layer"
  compatible_runtimes = ["python3.12"]
  filename            = "${path.module}/../layer-archive/layer.zip"
  source_code_hash    = filebase64sha256("${path.module}/../layer-archive/layer.zip")
}


