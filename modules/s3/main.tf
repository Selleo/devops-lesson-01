resource "aws_s3_bucket" "this" {
  bucket = var.bucket
}

resource "aws_iam_user_policy" "this" {
  name = "s3-access-${var.bucket}"
  user = var.user

  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "AllowListing"

    actions = [
      "s3:ListBucket",
    ]

    resources = [aws_s3_bucket.this.arn]
  }

  statement {
    sid = "ManageObjects"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
}
