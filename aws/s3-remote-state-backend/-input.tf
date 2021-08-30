variable "name_prefix" {
  type = string
}

variable "log_bucket_id" {
  type = string
}

variable "user_name_count" {
  type = number
}

variable "user_names" {
  type = list(string)
}
