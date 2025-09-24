terraform {
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14"
    }
  }

  backend "s3" {
    bucket         = "terraformbucket-test-state"   
    key            = "terraformbucket-test-state/terraform.tfstate"
    region         = "us-east-2"                    
    use_lockfile = true
  }
}

