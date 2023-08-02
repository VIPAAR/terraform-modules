data "aws_iam_policy_document" "response_headers_assume_role" {
  count = length(var.custom_response_headers) == 0 ? 0 : 1

  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com",
      ]
      type = "Service"
    }
  }
}

data "aws_iam_policy_document" "response_headers" {
  count = length(var.custom_response_headers) == 0 ? 0 : 1

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
    sid = "AllowLogCreation"
  }
}

resource "aws_iam_role" "response_headers" {
  count = length(var.custom_response_headers) == 0 ? 0 : 1

  assume_role_policy = data.aws_iam_policy_document.response_headers_assume_role[0].json
  name               = "${var.distribution_name}-response-headers"
}

resource "aws_iam_role_policy" "response_headers" {
  count = length(var.custom_response_headers) == 0 ? 0 : 1

  name   = "${var.distribution_name}-response-headers"
  policy = data.aws_iam_policy_document.response_headers[0].json
  role   = aws_iam_role.response_headers[0].id
}

data "archive_file" "response_headers_zip" {
  count = length(var.custom_response_headers) == 0 ? 0 : 1

  type             = "zip"
  output_path      = "${path.module}/response-headers.zip"
  output_file_mode = "0644"

  source {
    content  = jsonencode(var.custom_response_headers)
    filename = "config.json"
  }

  source {
    content  = file("${path.module}/response-headers.js")
    filename = "function.js"
  }
}

resource "aws_lambda_function" "response_headers" {
  count = length(var.custom_response_headers) == 0 ? 0 : 1

  filename         = "${path.module}/response-headers.zip"
  function_name    = "${var.distribution_name}-response-headers"
  handler          = "function.handler"
  publish          = true
  role             = aws_iam_role.response_headers[0].arn
  runtime          = "nodejs12.x"
  source_code_hash = data.archive_file.response_headers_zip[0].output_base64sha256
  tags             = local.tags

  lifecycle {
    ignore_changes = [
      filename,
    ]
  }
}

resource "aws_lambda_permission" "response_headers" {
  count = length(var.custom_response_headers) == 0 ? 0 : 1

  action        = "lambda:GetFunction"
  function_name = aws_lambda_function.response_headers[0].function_name
  principal     = "edgelambda.amazonaws.com"
  statement_id  = "AllowExecutionFromCloudFront"
}
