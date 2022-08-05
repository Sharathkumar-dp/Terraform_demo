##### Variables #######

variable "demo_region" {
  description = "Name of the region to create resource"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR range for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr" {
  description = "CIDR range for Subnet1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet2_cidr" {
  description = "CIDR range for Subnnet2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet1_az" {
  description = "Availability zone for subnet 1"
  type        = string
  default     = "us-east-1a"
}

variable "subnet2_az" {
  description = "Availability zone for subnet 2"
  type        = string
  default     = "us-east-1b"
}

variable "insta_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI id"
  type        = string
  default     = "ami-090fa75af13c156b4"
}

variable "keypair_name" {
  description = "Keypair name"
  type        = string
  default     = "demo_keypair"
}
