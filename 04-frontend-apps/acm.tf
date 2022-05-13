module "acm" {
  source  = "Selleo/acm/aws//modules/wildcard"
  version = "0.1.0"

  providers = {
    aws = aws.global
  }

  domain = "workshops.selleo.app"
}
