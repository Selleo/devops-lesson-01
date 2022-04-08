resource "aws_acm_certificate" "bez_sosu" {
  domain_name               = "bezsosu.com"
  subject_alternative_names = ["*.bezsosu.com"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
