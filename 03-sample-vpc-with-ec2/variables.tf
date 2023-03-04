variable "region" {
  description = "(Required) The AWS Region to create the Terraform State Backend resources in."
  type        = string
  default     = "eu-west-2"

  validation {
    # We are validating that the AWS region matches the expected format for a region identifier.
    # We're only checking that the rough structure matches, rather than looking up a list of regions.
    # The API will reject any invalid region names, so we're only trying to catch errors earlier here.
    condition     = can(regex("[a-z]{2}-[a-z]*-\\d", var.region))
    error_message = "The supplied AWS Region 'region' is not in a valid format and has failed to pass the defined regex."
  }
}

variable "vpc_cidr" {
  description = "(Required) The CIDR for the Sample VPC"
  type        = string
  default     = "192.168.0.0/20"
  validation {
    condition = anytrue([
      can(regex("10(?:\\.(?:[0-1]?[0-9]?[0-9])|(?:2[0-5]?[0-9])){3}\\/(3[0-2]|2[0-9]|1[0-9]|[8-9])", var.vpc_cidr)),
      can(regex("(172)\\.(1[6-9]|2[0-9]|3[0-1])(\\.(2[0-4][0-9]|25[0-5]|[1][0-9][0-9]|[1-9][0-9]|[0-9])){2}(\\/(1[6-9]|2[0-9]|3[0-2])\\/(3[0-2]|2[0-9]|1[0-9]|[8-9]))", var.vpc_cidr)),
      can(regex("(192)\\.(168)(\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])){2}\\/(3[0-2]|2[0-9]|1[0-9]|[8-9])", var.vpc_cidr))
    ])
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}