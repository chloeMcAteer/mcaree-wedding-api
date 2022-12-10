resource "aws_iam_role_policy" "upload_lambda_policy" {
  name   = "upload_lambda_policy"
  role   = aws_iam_role.upload_lambda_role.id
  policy = file("./lambda-iam-policies/lambda_policy.json")
}

resource "aws_iam_role" "upload_lambda_role" {
  name               = "upload_lambda_role"
  assume_role_policy = file("./lambda-iam-policies/lambda_assume_role_policy.json")
}
