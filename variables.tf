variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "cloudnative_subnets" {
  description = "Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "trusted_subnets" {
  description = "Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "dmz_subnets" {
  description = "Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}