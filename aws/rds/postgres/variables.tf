variable "allow_major_version_upgrade" {
  default     = false
  description = "Whether or not to allow upgrading between major version."
  type        = bool
}

variable "allocated_storage" {
  default     = 100
  description = "The allocated storage (in GiB)."
  type        = number
}

variable "apply_immediately" {
  default     = false
  description = "Changes to some db settings can be deferred until the next maintenance window. Setting this to true will instead apply the planned changes immediately."
  type        = bool
}

variable "auto_minor_version_upgrade" {
  default     = true
  description = "Whether to automatically apply minor version upgrades during the maintenance window."
  type        = bool
}

variable "blue_green_update_enabled" {
  default     = true
  description = "Whether to perform database updates using a blue/green deployment."
  type        = bool
}

variable "ca_cert_identifier" {
  default     = null
  description = "The identifier of the CA certificate for the DB instance."
  type        = string
}

variable "database_name" {
  description = "The name of the database to create when the DB instance is created."
  type        = string
}

variable "engine_version" {
  default     = "10.1"
  description = "The version of PostgreSQL used when the DB instance is created."
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
}

variable "instance_name" {
  default     = ""
  description = "The name of the instance to be created, if different than name."
  type        = string
}

variable "max_allocated_storage" {
  default     = null
  description = "Specifies the maximum storage (in GiB) that Amazon RDS can automatically scale to. By default, Storage Autoscaling is disabled. Must be greater than allocated_storage."
  type        = number
}

variable "name" {
  description = "The name of resources created, used either directly or as a prefix."
  type        = string
}

variable "parameters" {
  default     = []
  description = "A list of DB parameters to apply. Note that parameters may differ from a family to an other. Full list of all parameters can be discovered via aws rds describe-db-parameters after initial creation of the group."
  type        = list(map(string))
}

variable "performance_insights_enabled" {
  default     = true
  description = "Whether or not to enable Performance Insights on the instance."
  type        = bool
}

variable "performance_insights_retention_period" {
  default     = 7
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
  type        = number
  validation {
    condition     = contains([7, 731], var.performance_insights_retention_period)
    error_message = "Valid choices for Performance Insights retention period are 7 (7 days) or 731 (2 years)."
  }
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs for the aws_db_subnet_group."
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
}

variable "username" {
  description = "Username for the master DB user."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID of the DB's aws_security_group."
  type        = string
}
