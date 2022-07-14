variable "allowed_user_arns" {
  type = list(string)
}

variable "allowed_user_names" {
  type = list(string)
}

variable "name" {
  type = string
}

variable "policy_arns" {
  default = []
  type    = list(string)
}

variable "policy_arn_count" {
  default = 0
  type    = number
}
