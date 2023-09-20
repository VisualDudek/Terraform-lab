
variable "name_prefix" {
  type        = string
  default     = "awsninja12"
  description = "Prefix added for name of every resource"
}

variable "number_of_servers" {
  type        = number
  description = "Number of machines to create"
  validation {
    condition     = var.number_of_servers > 0 && var.number_of_servers < 3
    error_message = "Number of servers should be between 1-2 inclucive"
  }
}

variable "distro" {
  type = string
  validation {
    condition     = var.distro == "ubuntu" || var.distro == "amazon"
    error_message = "Provide dostro: ubuntu or amazon, not ${var.distro}"
  }
}

variable "app_version" {
  type = string
}

variable "vpc_id" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}