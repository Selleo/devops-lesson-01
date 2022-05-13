resource "aws_iam_user" "ci" {
  name = "apps-ci"
}

resource "aws_iam_access_key" "ci" {
  user = aws_iam_user.ci.name
}

resource "aws_iam_policy_attachment" "ci_app1" {
  name       = "ci-app-1"
  users      = [aws_iam_user.ci.name]
  policy_arn = module.app1.deployment_policy_id
}

resource "aws_iam_policy_attachment" "ci_app2" {
  name       = "ci-app-2"
  users      = [aws_iam_user.ci.name]
  policy_arn = module.app2.deployment_policy_id
}

