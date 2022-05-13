module "app_storage" {
  source = "./modules/app-storage"

  bucket = "selleo-applications"
}

module "app_storage_policy" {
  source = "./modules/app-storage-policy"

  bucket = module.app_storage.id

  origin_access_identities = [
    module.app1.oai_iam_arn,
    module.app2.oai_iam_arn
  ]
}
