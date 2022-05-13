resource "aws_s3_bucket" "applications" {
  bucket = "selleo-applications"
}

resource "aws_s3_bucket_acl" "applications" {
  bucket = aws_s3_bucket.applications.id
  acl    = "private"
}

module "app1" {
  source = "./modules/app"

  comment         = "Sample app1"
  certificate_arn = module.acm.arn
  s3_origin = {
    bucket_regional_domain_name = aws_s3_bucket.applications.bucket_regional_domain_name
    path                        = "/apps/dashboard"
  }
  aliases = ["dashboard.workshops.selleo.app"]
}

module "app2" {
  source = "./modules/app"

  comment         = "Sample app2"
  certificate_arn = module.acm.arn
  s3_origin = {
    bucket_regional_domain_name = aws_s3_bucket.applications.bucket_regional_domain_name
    path                        = "/apps/devpath"
  }
  aliases = ["devpath.workshops.selleo.app"]

  custom_error_responses = [
    {
      error_code            = 403
      error_caching_min_ttl = 0
      response_code         = 200
      response_page_path    = "/"
    }
  ]
}

data "aws_iam_policy_document" "applications" {
  version = "2012-10-17"

  statement {
    sid = 1

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.applications.arn}/apps/dashboard/*",
      "${aws_s3_bucket.applications.arn}/apps/devpath/*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        module.app1.oai_iam_arn,
        module.app2.oai_iam_arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "applications" {
  bucket = aws_s3_bucket.applications.id

  policy = data.aws_iam_policy_document.applications.json
}

data "aws_route53_zone" "workshops" {
  name = "workshops.selleo.app"
}

resource "aws_route53_record" "app1" {
  zone_id = data.aws_route53_zone.workshops.zone_id
  name    = "dashboard"
  type    = "A"

  alias {
    name                   = module.app1.domain_name
    zone_id                = module.app1.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app2" {
  zone_id = data.aws_route53_zone.workshops.zone_id
  name    = "devpath"
  type    = "A"

  alias {
    name                   = module.app2.domain_name
    zone_id                = module.app2.hosted_zone_id
    evaluate_target_health = true
  }
}
