provider "aws" {
  region = var.aws_region # Specify your AWS region
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

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

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "logs:*",
          "lambda:InvokeFunction"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "step_functions_role" {
  name = "step_functions_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "step_functions_policy" {
  name = "step_functions_policy"
  role = aws_iam_role.step_functions_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction",
          "s3:GetObject"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = var.data_bucket

  versioning {
    enabled = true
  }
  force_destroy = true
}

resource "aws_s3_bucket" "output_bucket" {
  bucket = var.output_bucket

  versioning {
    enabled = true
  }
  force_destroy = true
}

resource "aws_lambda_function" "extract_data" {
  filename         = "extract_data.zip"
  function_name    = "extract_data"
  role             = aws_iam_role.lambda_role.arn
  handler          = "extract_data.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("extract_data.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.data_bucket.bucket
    }
  }
}

resource "aws_lambda_function" "transform_data" {
  filename         = "transform_data.zip"
  function_name    = "transform_data"
  role             = aws_iam_role.lambda_role.arn
  handler          = "transform_data.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("transform_data.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.data_bucket.bucket
    }
  }
}

resource "aws_lambda_function" "load_data" {
  filename         = "load_data.zip"
  function_name    = "load_data"
  role             = aws_iam_role.lambda_role.arn
  handler          = "load_data.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("load_data.zip")

  environment {
    variables = {
      OUTPUT_BUCKET = aws_s3_bucket.output_bucket.bucket
    }
  }
}

resource "aws_lambda_permission" "allow_s3_to_invoke_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.extract_data.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data_bucket.arn
}

resource "aws_sfn_state_machine" "data_pipeline" {
  name     = "DataProcessingPipeline"
  role_arn = aws_iam_role.step_functions_role.arn
  definition = jsonencode({
    Comment : "A detailed data processing pipeline",
    StartAt : "ExtractData",
    States : {
      ExtractData : {
        Type : "Task",
        Resource : aws_lambda_function.extract_data.arn,
        Next : "TransformData"
      },
      TransformData : {
        Type : "Task",
        Resource : aws_lambda_function.transform_data.arn,
        Next : "LoadData"
      },
      LoadData : {
        Type : "Task",
        Resource : aws_lambda_function.load_data.arn,
        End : true
      }
    }
  })
}

output "innput_bucket" {

  value = var.data_bucket
  
}

output "output_bucket" {

  value = var.output_bucket
  
}
