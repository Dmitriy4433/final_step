terraform {
  backend "s3" {
    bucket = "dpon-tf-final-state"
    # Example
    #key            = "eks/terraform.tfstate"
    key     = "final-step/dev/eks.tfstate"
    encrypt = true
    # Example
    dynamodb_table = "dpon-tf-locks"
    # dynamo key LockID
    # Params tekan from -backend-config when terraform init
    region  = "eu-north-1"
    profile = "mfa"
  }
}

