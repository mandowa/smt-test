module "vpc" {

  source = "./modules/vpc"

  name = "Terraform_managed_VPC"
  cidr = "10.156.176.0/20"

  azs              = ["ap-northeast-1a", "ap-northeast-1c","ap-northeast-1d"]
  intra_subnets    = ["10.156.176.0/24", "10.156.177.0/24","10.156.178.0/24"]
  database_subnets = ["10.156.179.0/24", "10.156.180.0/24", "10.156.181.0/24"]
  public_subnets   = ["10.156.182.0/24", "10.156.183.0/24","10.156.184.0/24"]

  public_subnet_suffix   = "CloudNative"
  intra_subnet_suffix    = "DMZ"
  database_subnet_suffix = "Trusted"

  enable_nat_gateway = false

  tags = {

    Terraform   = "true"
    Environment = "Testbed"
    ManagedBy = "Terraform"
  }
}

# data "aws_ram_resource_share" "tgw" {
#     provider = aws.main
#     name = "Sharing the PACI TGW with all the TCC Production accounts"
#     resource_owner = "SELF"
# }

# resource "aws_ram_resource_share_accepter" "receiver_accept" {
#   share_arn = data.aws_ram_resource_share.tgw.arn
# }