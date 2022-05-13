module "app1" {
  source = "./modules/app"

  app_id          = "dashboard"
  s3_bucket       = module.app_storage.id
  certificate_arn = module.acm.arn
  aliases         = ["dashboard.workshops.selleo.app"]
}

module "app2" {
  source = "./modules/app"

  app_id          = "devpath"
  s3_bucket       = module.app_storage.id
  certificate_arn = module.acm.arn
  aliases         = ["devpath.workshops.selleo.app"]
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
