variable "project" {
  description = "Project short name (e.g., ctds)"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "lifecycle_rule_enabled" {
  description = "Enable lifecycle rules for cost control"
  type        = bool
  default     = true
}
