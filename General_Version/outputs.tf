output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}


output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_name" {
  value = data.aws_region.current.name
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}

output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}

output "prod_vpc_id" {
  value = aws_vpc.prod_vpc.id
}

output "prod_vpc_cidr" {
  value = aws_vpc.prod_vpc.cidr_block
}
