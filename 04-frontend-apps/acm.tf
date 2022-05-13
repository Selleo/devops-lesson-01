module "acm" {
  source  = "Selleo/acm/aws//modules/wildcard"
  version = "0.2.0"

  providers = {
    aws = aws.global
  }

  domain = "workshops.selleo.app"
}
