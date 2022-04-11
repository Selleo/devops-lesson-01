data "aws_route53_zone" "workshops" {
  name = "workshops.selleo.app"
}

resource "aws_acm_certificate" "workshops" {
  domain_name               = "workshops.selleo.app"
  subject_alternative_names = ["*.workshops.selleo.app"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "workshops_validation" {
  for_each = {
    for dvo in aws_acm_certificate.workshops.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.workshops.zone_id
}
