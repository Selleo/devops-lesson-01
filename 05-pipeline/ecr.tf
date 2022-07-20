module "info" {
  source  = "Selleo/context/null"
  version = "0.3.0"

  namespace = "kudos"
  stage     = "development"
  name      = "api"
}

module "ecr" {
  source = "Selleo/ecr/aws//modules/repository"

  context = module.info.context
}

resource "aws_ecr_repository_policy" "ecr" {
  repository = module.ecr.name

  policy = jsonencode({
    Version : "2008-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : "*",
        Action : [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy"
        ]
      }
    ]
  })
}
