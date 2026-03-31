variable "environment" {
  default = "prod"
  type    = string
}

variable "project_name" {
  description = "Name of the project"
  default     = "medici_aws_infra"
}

variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "medici_vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  default     = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for private subnet A"
  default     = "10.0.3.0/24"
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for private subnet B"
  default     = "10.0.4.0/24"
}

variable "database_master_password" {
  default = "password"
}

variable "database_master_username" {
  default = "medici_admin"
}
