variable "tags" {
  description = "Additional resource tags to apply to applicable resources. Format: {\"key\" = \"value\"}."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Default name for the resources."
  type        = string
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role used for lambda execution."
  type        = string
  default     = null
}

variable "handler" {
  description = "Lambda handler function."
  type        = string
}

variable "runtime" {
  description = "Lambda runtime."
  type        = string

  validation {
    condition     = trimprefix(var.runtime, "python") != var.runtime
    error_message = "Provided runtime is not supported."
  }
}

variable "timeout" {
  description = "Lambda timeout in mins."
  type        = string
  default     = 3
}

variable "environment" {
  description = "ENV variable mappings."
  type        = object({ variable = map(string) })
  default     = null
}

variable "description" {
  description = "Description of what the lambda function does."
  type        = string
  default     = null
}

variable "memory_size" {
  description = "Memory allocated to the lambda function."
  type        = number
  default     = null

}

variable "source_path" {
  description = "Location of the source file path."
  type        = string
}

variable "output_path" {
  description = "Location for the output file path."
  type        = string
  default     = null
}
