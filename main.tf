resource "aws_iam_user" "app" {
  name = "bw-app-prod"
}

resource "aws_iam_access_key" "app" {
  user = aws_iam_user.app.name
}

module "s3_assets" {
  source = "./modules/s3"

  user   = aws_iam_user.app.name
  bucket = "selleo-workshops-assets"
}

resource "aws_secretsmanager_secret" "api" {
  name = "/dev/api"
}
