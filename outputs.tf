output "aws_iam_role" {
  description = "Outputs of the IAM role created for lambda."

  value = {
    this = var.iam_role_arn == null ? aws_iam_role.this : null
  }
}

output "aws_lambda_function" {
  description = "Outputs of the lambda function."

  value = {
    this = aws_lambda_function.this
  }
}
