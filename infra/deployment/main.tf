/*
In Terraform, modules and configurations are not automatically inherited across directories or files. 
Each directory acts as its own module, and if you want to reference another module (like the "network" directory),
you need to explicitly include it in your main configuration.
*/

module "network" {
  source         = "./network"  # Including the network configuration module

  namespace      = var.namespace
  env            = var.env

  az_count       = var.az_count # 2 or 3
  vpc_cidr       = "10.0.0.0/16"
  subnets_public = var.subnets_public
  app_port       = var.app_port
  container_port = var.container_port
}