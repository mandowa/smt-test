module "vpc" {

  source = "./modules/vpc"

  name = "Terraform_managed_VPC"
  cidr = "10.156.176.0/20"
  #cidr = var.cidr

  azs              = ["ap-northeast-1a", "ap-northeast-1c","ap-northeast-1d"]
  #DMZ Subnets
  intra_subnets    = ["10.156.176.0/24", "10.156.177.0/24","10.156.178.0/24"]

  #Trusted Subnets
  database_subnets = ["10.156.179.0/24", "10.156.180.0/24", "10.156.181.0/24"]

  #CloudNative Subnets
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

data "aws_ram_resource_share" "tgw" {
    provider = aws.main
    #name = "Sharing the Prod TGW with all the TCC Production accounts"
    name = "Terraform_TGW_Sharing"
    resource_owner = "SELF"
}

resource "aws_ram_principal_association" "prod" {
    provider = aws.main
    principal = "420009094734"
    resource_share_arn = data.aws_ram_resource_share.tgw.arn

}
# data "aws_ec2_transit_gateway" "main" {
#       filter {
#             name = "owner-id"
#             values = ["981045337300"]
#       }
#     depends_on = [aws_ram_principal_association.prod]
# }

resource "aws_ec2_transit_gateway_vpc_attachment" "test" {
  subnet_ids                                      = module.vpc.public_subnets
  transit_gateway_id                              = "tgw-0362f7e9557d90d2b"
  vpc_id                                          = module.vpc.vpc_id
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "TGW-Prod"
    Side = "creator"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.ap-northeast-1.s3"

  tags = {
    Environment = "test"
  }
}

# resource "aws_vpc_endpoint_route_table_association" "private_s3" {
#   vpc_endpoint_id = aws_vpc_endpoint.s3.id
#   route_table_id  = module.vpc.private_route_table
#   depends_on = [aws_vpc_endpoint.s3]
# }

# resource "aws_ram_resource_share_accepter" "receiver_accept" {
#     share_arn = data.aws_ram_resource_share.tgw.arn
# }

# output "TGW_arn" {
#   value = data.aws_ram_resource_share.tgw.arn
# }