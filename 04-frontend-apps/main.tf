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

