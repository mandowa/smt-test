provider "aws" {
  region = "ap-northeast-1"
  profile = "smt-test"
}
provider "aws" {
  alias = "main"
  region = "ap-northeast-1"
  profile = "main"
}

provider "aws" {
  alias = "assume"
  region ="ap-northeast-1"
  assume_role {
    role_arn = ""
  }
}

terraform {

  backend "s3" {

    bucket = "smt-test-terraform-tfstate"
    region = "ap-northeast-1"
    dynamodb_table = "terraform-state"
    key = "smt-test/terraform.tfstate"
    profile = "smt-test"
 }
}
