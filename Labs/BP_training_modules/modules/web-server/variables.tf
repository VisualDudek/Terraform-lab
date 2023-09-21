variable "number_of_servers" {
  type        = number
  default     = 1
  description = "Number of instances to create"
  validation {
    condition     = var.number_of_servers > 0 && var.number_of_servers <= 3
    error_message = "Number of servers should be between 1-3 inclucive"
  }
}

variable "image_version" {
  type = string
}

variable "name_prefix" {
  type        = string
  default     = "awsninja12"
  description = "Prefix added for name of every resource"
}

variable "distro" {
  type = string
  validation {
    condition     = var.distro == "ubuntu" || var.distro == "amazon"
    error_message = "Provide dostro: ubuntu or amazon, not ${var.distro}"
  }
}

# Task 7
variable "vpc_id" {
  type = string
  description = "VPC where aws_instance should be created"
}

# Task 7
variable "public_subnet_ids" {
  type = list(string)
  description = "List of publuc subnets where aws_instance expected to be atached"
}

# Task 9
variable "sg_prexif_name" {
  type = string
  description = "Uniq prefix for SG name"
}