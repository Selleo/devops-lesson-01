resource "aws_kms_key" "ssh" {
  description             = "Used for SSH"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "ssh" {
  name          = "alias/ssh"
  target_key_id = aws_kms_key.ssh.key_id
}

resource "aws_iam_policy" "ssm" {
  name        = "ssm"
  description = "Access EC2 via SSM"

  policy = templatefile("./tpl/ssm_policy.json", {
    kms_arn = aws_kms_key.ssh.arn
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = module.ecs_cluster.instance_role
  policy_arn = aws_iam_policy.ssm.arn
}

resource "aws_iam_policy" "ssm_access" {
  name        = "ssm-access"
  description = "Allows IAM users to access EC2 via SSM"

  policy = templatefile("./tpl/ssm_access_policy.json", {
    ec2_tag_key   = "ssm-agent"
    ec2_tag_value = "true"
    kms_arn       = aws_kms_key.ssh.arn
  })
}

# resource "aws_ssm_document" "ssm" {
#   name          = "ssh"
#   document_type = "Session"

#   content = jsonencode({
#     schemaVersion = "2.2"
#     # kmsKeyId = aws_kms_key.ssh.key_id
#   })
# }
