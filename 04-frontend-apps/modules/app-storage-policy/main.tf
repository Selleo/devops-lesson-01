resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket

  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  version = "2012-10-17"

  statement {
    sid = 1

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket}/apps/*"
    ]

    principals {
      type        = "AWS"
      identifiers = var.origin_access_identities
    }
  }
}

