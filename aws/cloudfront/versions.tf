
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.77.0"
      configuration_aliases = [aws.lambda_edge_region]
    }
  }
}
