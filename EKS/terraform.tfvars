# AWS account config
region      = "eu-north-1"
iam_profile = "mfa"

# General for all infrastructure
name = "dpon-finalstep"

vpc_id      = "vpc-03539758253935945"
subnets_ids = [
  "subnet-0fe8eea60beda7286",
  "subnet-03f841482dc0f0ed3",
  "subnet-06a0b2594ef01aa88",
]

tags = {
  Environment = "test-studen1"
  TfControl   = "true"
  Owner       = "dpon"
  Project     = "final-step"
}

# Твоя Route53 зона
zone_name = "devops8.test-danit.com"
