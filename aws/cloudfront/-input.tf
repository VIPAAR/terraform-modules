variable "acm_certificate_arn" {
  type = string
}

variable "aliases" {
  type = list(string)
}

variable "bucket_name" {
  default = ""
  type    = string
}

variable "comment" {
  default = ""
  type    = string
}

variable "compress" {
  default = false
  type    = string
}

variable "custom_error_responses" {
  default = []
  type    = any
}

variable "default_root_object" {
  default = "index.html"
  type    = string
}

variable "distribution_name" {
  type = string
}

variable "enabled" {
  default = true
  type    = string
}

variable "extra_origins" {
  default = []
  type    = any
}

variable "log_bucket" {
  type = string
}

variable "ordered_cache_behaviors" {
  default = []
  type    = any
}

variable "origin_bucket_cors" {
  default = []
  type    = any
}

variable "price_class" {
  default = "PriceClass_100"
  type    = string
}

variable "tags" {
  default = {}
  type    = map(string)
}

variable "viewer_tls_minimum_version" {
  default = "TLSv1.2_2018"
  type    = string
}

variable "web_acl_id" {
  default = ""
  type    = string
}

