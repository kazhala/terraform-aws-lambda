module "lambda" {
  source = "../../"

  name        = "test-example"
  handler     = "main.lambda_handler"
  runtime     = "python3.8"
  source_path = "${path.module}/lambda/main.py"

  environment_variables = {
    hello = "no"
  }
}
