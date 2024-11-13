# The .tflint.hcl file is a configuration file for TFLint
# It contains various settings and configurations that guide TFLint in performing linting tasks
# These settings can include things like plugins (AWS, Azure, etc), rules and gloabl settings
# The file is meant to be placed alongside your Terraform code so that TFLint can use it for 
# linting and enforcing rules in your Terraform modules.

 plugin "aws" {
    enabled = true
    version = "0.34.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
