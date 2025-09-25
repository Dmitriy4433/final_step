# AWS account config
region      = "eu-north-1"
iam_profile = "mfa"

# General for all infrastructure
# This is the name prefix for all infra components
name = "dpon-finalstep"


vpc_id      = "vpc-03539758253935945"
subnets_ids = ["subnet-0fe8eea60beda7286", "subnet-03f841482dc0f0ed3", "subnet-06a0b2594ef01aa88"]


#vpc_id      = "vpc-0b3c6a5edabcbc866"
#subnets_ids = ["subnet-09147e169de2bbedd", "subnet-014fb3015844ed798", "subnet-09e5991259d455b0f"]

#vpc_id       = "vpc-06df0f1ed4e799adb"
#subnets_ids  = ["subnet-0f77887c9e69fc162", "subnet-07bea859869364a5e", "subnet-0c31f62635097ce22"]


tags = {
  Environment = "test-studen1"
  TfControl   = "true"
  Owner       = "dpon"
  Project     = "final-step"
}

zone_name = "devops8.test-danit.com"
