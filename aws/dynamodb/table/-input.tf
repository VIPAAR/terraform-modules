variable "attributes" {
  type = list(object({
    name = string
    type = string
  }))
}

variable "autoscaling_service_role_arn" {
  type = string
}

variable "billing_mode" {
  default = "PROVISIONED"
  type    = string
}

variable "global_secondary_indexes" {
  default = []
  type    = any
}

variable "global_secondary_indexes_count" {
  default = 0
  type    = string
}

variable "hash_key" {
  type = string
}

variable "local_secondary_indexes" {
  default = []
  type    = any
}

variable "name" {
  type = string
}

variable "pitr_enabled" {
  default = "true"
  type    = string
}

variable "read_capacity" {
  default = {
    max = 1
    min = 1
  }
  type = map(string)
}

variable "range_key" {
  default = ""
  type    = string
}

variable "stream_view_type" {
  default = ""
  type    = string
}

variable "tags" {
  default = {}
  type    = map(string)
}

variable "ttl_attribute_name" {
  default = ""
  type    = string
}

variable "write_capacity" {
  default = {
    max = 1
    min = 1
  }
  type = map(string)
}
