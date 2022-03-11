module "ecs_cluster" {
  source  = "Selleo/backend/aws//modules/ecs-cluster"
  version = "0.6.0"

  name_prefix        = "workshop-02"
  region             = "eu-west-3"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnets
  instance_type      = "t3.small"
  security_groups    = [aws_security_group.ecs_default.id]
  loadbalancer_sg_id = module.load_balancer.loadbalancer_sg_id

  autoscaling_group = {
    min_size         = 1
    max_size         = 3
    desired_capacity = 2
  }
}

resource "aws_security_group" "ecs_default" {
  name        = "workshop-02-ecs"
  description = "Default ECS SG"
  vpc_id      = module.vpc.vpc_id
}

module "ecs_service" {
  source  = "Selleo/backend/aws//modules/ecs-service"
  version = "0.6.0"

  name           = "rails-api"
  vpc_id         = module.vpc.vpc_id
  ecs_cluster_id = module.ecs_cluster.ecs_cluster_id
  desired_count  = 2
  instance_role  = module.ecs_cluster.instance_role

  container_definition = {
    cpu_units      = 256
    mem_units      = 512
    command        = ["/app/web"],
    image          = "qbart/go-http-server-noop:latest",
    container_port = 4567
    envs = {
      "APP_ENV" = "production"
    }
  }
}
