module "acm" {
  source  = "Selleo/acm/aws//modules/wildcard"
  version = "0.1.0"

  domain = "workshops.selleo.app"
}
