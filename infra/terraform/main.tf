provider "aws" {
  version = "~> 4.0"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "backend-challenge-bucket-code"  # Substitua pelo nome do seu bucket
    key            = "terraform/state"              # Caminho do arquivo de estado
    region         = "us-east-1"                    # Substitua pela sua região
  }
}