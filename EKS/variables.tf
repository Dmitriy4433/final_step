variable "name" {
  type = string
}
#variable "vpc_cidr" {
#}
#variable "private_subnets" {
#}
#variable "public_subnets" {
#}
variable "vpc_id" {
  type = string
}
variable "subnets_ids" {
  type = list(string)
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "region" {
  description = "aws region"
  default     = "eu-north-1"
  type        = string
}

### Backend vars
variable "iam_profile" {
  description = "AWS CLI profile (MFA)"
  type        = string
  default     = null
}

variable "zone_name" {
  type = string
}
