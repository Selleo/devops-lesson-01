resource "aws_kms_key" "ssh" {
  description             = "Used for SSH"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "ssh" {
  name          = "alias/ssh"
  target_key_id = aws_kms_key.ssh.key_id
}

# ssm document

module "ssm" {
  source  = "Selleo/ssm/aws//modules/ssm"
  version = "0.1.1"

  name    = "ssh-access"
  kms_arn = aws_kms_key.ssh.arn
}

# ssm iam

module "iam_ssm" {
  source  = "Selleo/iam/aws//modules/ssm"
  version = "0.3.1"

  kms_arn          = aws_kms_key.ssh.arn
  ssm_document_arn = module.ssm.arn
}

# iam ssm assignment

resource "aws_iam_policy" "ssm" {
  name        = "ssm"
  description = "Access EC2 via SSM"

  policy = module.iam_ssm.ssm_policy_rendered
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = module.ecs_cluster.instance_role
  policy_arn = aws_iam_policy.ssm.arn
}

resource "aws_iam_policy" "ssm_access" {
  name        = "ssm-access"
  description = "Allows IAM users to access EC2 via SSM"

  policy = module.iam_ssm.ssm_access_policy_rendered
}

