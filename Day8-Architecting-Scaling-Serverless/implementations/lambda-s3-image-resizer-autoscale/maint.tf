provider "aws" {
  region = var.aws_region
}

# Create input S3 bucket
resource "aws_s3_bucket" "input_bucket" {
  bucket        = var.input_bucket
  force_destroy = true
}

# Create output S3 bucket
resource "aws_s3_bucket" "output_bucket" {
  bucket        = var.output_bucket
  force_destroy = true
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the IAM role
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_s3_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Effect = "Allow",
        Resource = [
          "${aws_s3_bucket.input_bucket.arn}/*",
          "${aws_s3_bucket.output_bucket.arn}/*"
        ]
      },
      {
        Action   = "logs:*",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Create Lambda function with reserved concurrency for autoscaling
resource "aws_lambda_function" "data_processing_lambda" {
  function_name = "data_processing_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"

  s3_bucket = "s3-fn-bucket-56g4dgr8"
  s3_key    = "lambda_function.zip"
  environment {
    variables = {
      INPUT_BUCKET  = aws_s3_bucket.input_bucket.bucket
      OUTPUT_BUCKET = aws_s3_bucket.output_bucket.bucket
    }
  }
  timeout = 30

  # Set reserved concurrency (optional, max concurrency can be set)
  reserved_concurrent_executions = 10
}

# Create S3 bucket notification for Lambda trigger
resource "aws_s3_bucket_notification" "s3_lambda_trigger" {
  bucket = aws_s3_bucket.input_bucket.id

  lambda_function {
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ".jpg"
    lambda_function_arn = aws_lambda_function.data_processing_lambda.arn
  }

  depends_on = [aws_lambda_permission.s3]
}

# Grant S3 permission to invoke Lambda
resource "aws_lambda_permission" "s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_processing_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.input_bucket.arn
}
