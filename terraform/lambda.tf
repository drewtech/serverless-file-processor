# Simple AWS Lambda Terraform Example
# requires 'index.js' in the same directory
# to test: run `terraform plan`
# to deploy: run `terraform apply`

variable "aws_region" {
  default = "ap-southeast-2"
}

variable "bucket_prefix" {
  default = "drewtechau"
}

variable serverless_role_arn{
    default = "arn:aws:iam::452268117598:role/LambdaServerlessRole"
}

provider "aws" {
  region = "${var.aws_region}"
}

data "archive_file" "lambda_zip" {
    type          = "zip"
    source_dir   = "../file_splitter/handler/"
    output_path   = "file_splitter.zip"
}

resource "aws_lambda_function" "file_splitter" {
  filename = "file_splitter.zip"
  function_name = "file_splitter"
  role = "${var.serverless_role_arn}"
  handler = "lambda_function.lambda_handler"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime = "python3.6"
  memory_size = 128
  timeout = 15       
}

resource "aws_s3_bucket" "s3_file_upload" {
  bucket = "${var.bucket_prefix}-uploaded-files"
  acl    = "private"

  tags = {
    Name        = "File Upload bucket"
    Environment = "Dev"
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.file_splitter.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.s3_file_upload.arn}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.s3_file_upload.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.file_splitter.arn}"
    events              = ["s3:ObjectCreated:*"]
    # filter_prefix       = "AWSLogs/"
    filter_suffix       = ".tf"
  }
}
