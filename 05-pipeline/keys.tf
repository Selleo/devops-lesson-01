resource "tls_private_key" "workshop" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "workshop" {
  key_name   = "workshop-05"
  public_key = tls_private_key.workshop.public_key_openssh
}
