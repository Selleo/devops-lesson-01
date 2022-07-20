module "ecs" {
  source  = "Selleo/backend/aws//modules/ecs-cluster"
  version = "0.17.0"
  # source = "../../terraform-aws-backend/modules/ecs-cluster"

  name_prefix          = "workshop-05"
  region               = "eu-west-3"
  key_name             = aws_key_pair.workshop.key_name
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.public_subnets
  instance_type        = "t3.small"
  lb_security_group_id = module.load_balancer.security_group_id

  cloudinit_scripts = [
    <<SH
    echo "Hello" > main.txt
    SH
  ]
}

module "api" {
  source  = "Selleo/backend/aws//modules/ecs-service"
  version = "0.17.0"
  # source = "../../terraform-aws-backend/modules/ecs-service"

  name           = "api"
  vpc_id         = module.vpc.vpc_id
  ecs_cluster_id = module.ecs.cluster_id
  desired_count  = 1
  instance_role  = module.ecs.instance_role

  container = {
    image     = module.ecr.url_tagged_latest
    port      = 4000
    cpu_units = 128
    mem_units = 64

    envs = {
      APP_ENV = "dev"
    }
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = module.load_balancer.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = module.api.lb_target_group_id
    type             = "forward"
  }
}

