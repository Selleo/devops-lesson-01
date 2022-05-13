# required

variable "bucket" {
  type        = string
  description = "S3 bucket name"
}

variable "origin_access_identities" {
  type        = list(string)
  description = "List of CloudFront origin access identities for S3 bucket policy"
}

