variable "ssm_bastion_input_map" {
  description = "Inputs for SSM Bastion."
  type = object({
    deploy_ssm_bastion = bool
    ami_name_filter    = string
    swap_volume_size   = string
    instance_type      = string
  })
  default = {
    deploy_ssm_bastion = false
    ami_name_filter    = "amzn2-ami-hvm-2.0.20240109.0-x86_64-ebs"
    swap_volume_size   = "2"
    instance_type      = "t3.micro"
  }
}

module "ssm_bastion" {
  source = "./modules/ssm_bastion"
  count  = var.ssm_bastion_input_map.deploy_ssm_bastion ? 1 : 0

  subnet_id        = module.filmdrop.private_subnet_ids[0]
  ami_name_filter  = var.ssm_bastion_input_map.ami_name_filter
  vpc_id           = module.filmdrop.vpc_id
  key_name         = module.ssm_bastion_key_pair.key_pair_name
  swap_volume_size = var.ssm_bastion_input_map.swap_volume_size
  instance_type    = var.ssm_bastion_input_map.instance_type
  vpc_cidr_range   = module.filmdrop.vpc_cidr
}

module "ssm_bastion_key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name_prefix    = "fd-ssm-bastion-key-par-"
  create_private_key = true
}
