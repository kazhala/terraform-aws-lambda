locals {
  file_type_mapping = {
    python = "py"
  }

  file_path_without_extension = trimsuffix(var.source_path, local.file_type_mapping[regex("(.*)\\d\\.\\d", var.runtime)[0]])
  output_path                 = var.output_path == null ? "${local.file_path_without_extension}.zip" : var.output_path
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.iam_role_arn == null ? 1 : 0

  name_prefix        = "${var.name}-lambda-"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_id" "this" {
  byte_length = 8
}

data "archive_file" "this" {
  type             = "zip"
  source_file      = var.source_path
  output_path      = var.output_path
  output_file_mode = "0666"
}

resource "aws_lambda_function" "this" {
  function_name    = "${var.name}-${random_id.this.hex}"
  filename         = var.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  handler          = var.handler
  role             = var.iam_role_arn == null ? aws_iam_role.this[0].arn : var.iam_role_arn
  runtime          = var.runtime
  timeout          = var.timeout
  description      = var.description
  memory_size      = var.memory_size

  dynamic "environment" {
    for_each = var.environment == null ? {} : var.environment

    content {
      variables = environment.variables
    }
  }

  tags = var.tags
}
