variable "associate_public_ip_address" {
  default = false
  type    = string
}

variable "ebs_block_devices" {
  default = []
  type    = list(string)
}

variable "ephemeral_block_devices" {
  default = []
  type    = list(string)
}

variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  default = ""
  type    = string
}

variable "name" {
  type = string
}

variable "placement_tenancy" {
  default = "default"
  type    = string
}

variable "policy_arns" {
  default = []
  type    = list(string)
}

variable "policy_arns_count" {
  default = 0
  type    = string
}

variable "root_block_device" {
  default = {}
  type    = map(string)
}

variable "security_groups" {
  default = []
  type    = list(string)
}

variable "user_data" {
  default = ""
  type    = string
}
