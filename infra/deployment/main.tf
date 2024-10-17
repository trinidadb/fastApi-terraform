/*
In Terraform, modules and configurations are not automatically inherited across directories or files. 
Each directory acts as its own module, and if you want to reference another module (like the vpc directory),
you need to explicitly include it in your main configuration.
*/

module "network" {
  source         = "./network"  # Including the network configuration module
  app_port       = var.app_port
  container_port = var.container_port
  subnets_public = var.subnets_public
}