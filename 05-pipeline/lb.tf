module "load_balancer" {
  source  = "Selleo/backend/aws//modules/load-balancer"
  version = "0.11.0"

  name       = "workshop-05"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
}

