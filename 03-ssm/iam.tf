resource "aws_iam_user" "dev1" {
  name = "dev1"
}

resource "aws_iam_policy_attachment" "dev_ssm_access" {
  name       = "dev_ssm_access"
  users      = [aws_iam_user.dev1.name]
  policy_arn = aws_iam_policy.ssm_access.arn
}
