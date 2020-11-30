variable "account_name" {
  type = "string"
}

variable "log_bucket" {
  type = "string"
}

variable "cis_benchmark_alerts" {
  type    = "list"
  default = []
}
