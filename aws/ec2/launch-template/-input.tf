variable "associate_public_ip_address" {
  default = false
  type    = string
}

variable "block_device_mappings" {
  type = list(object({
    device_name  = optional(string)
    no_device    = optional(bool)
    virtual_name = optional(string)
    ebs = object({
      delete_on_termination = optional(bool)
      encrypted             = optional(bool)
      iops                  = optional(number)
      throughput            = optional(number)
      kms_key_id            = optional(string)
      snapshot_id           = optional(string)
      volume_size           = optional(number)
      volume_type           = optional(string)
    })
  }))

  default = []
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

variable "tenancy" {
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

variable "security_groups" {
  default = []
  type    = list(string)
}

variable "user_data" {
  default = ""
  type    = string
}
