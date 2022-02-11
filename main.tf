resource "aws_iam_user" "app" {
  name = "bw-app-prod"
}

resource "aws_iam_access_key" "app" {
  user = aws_iam_user.app.name
}

