resource "aws_route53_record" "app1" {
  zone_id = module.acm.zone_id
  name    = "dashboard"
  type    = "A"

  alias {
    name                   = module.app1.domain_name
    zone_id                = module.app1.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app2" {
  zone_id = module.acm.zone_id
  name    = "devpath"
  type    = "A"

  alias {
    name                   = module.app2.domain_name
    zone_id                = module.app2.hosted_zone_id
    evaluate_target_health = true
  }
}
