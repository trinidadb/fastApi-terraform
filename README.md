# Playing with FastAPI, Terraform and GitHub Actions
The objective of this project was to create a scalable API structure/template using the FastAPI framework. Containerize the application and deploy it on AWS in a single region and across one or multiple availability zones.

The AWS structure is as follows:

![image](https://github.com/user-attachments/assets/f5e5e2cf-be7e-46b9-abad-5237aa336bfa)

**By default two public subnets, each in one AZ*

When a push is done to the master branch, if the infrastructure had already been provisioned, the docker image is going to be updated in ECR/ECS.

For info on how to create a secret, refer to: https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions

## Warning
- Always ensure to destroy your infrastructure after usage. Forgetting to do so could incur high AWS fees.
- Never commit your AWS Account ID to git. Store it in an `.env` file and ensure `.env` is added to your `.gitignore`.

## Setup, Deploy, and Destroy

### Setup Environment Variables
Add an `.env` file containing your AWS account ID and region. Example file:
```dotenv
AWS_ACCOUNT_ID=1234567890
AWS_REGION=ap-southeast-1
```

### Configure Terraform Backend
Create a `backend.tf` file, and add it to both `/infra/setup/backend.tf` and `/infra/app/backend.tf`. Example file content:
```hcl
terraform {
  backend "s3" {
    region = "<AWS_REGION>"
    bucket = "<BUCKET_NAME>"
    key    = "<APP_NAME>/terraform.tfstate"
  }
}
```
Alternatively, you can skip this step to store your Terraform state locally.

### Deploy and Destroy Infrastructure/App
Use the `Makefile` to manage deployment and destruction tasks. To execute the full deployment process, which includes ECR creation, Docker build, tagging and pushing, and Fargate/ECS, IGW, and VPC setup, run:
```shell
make complete-deployment
```

To destroy your infrastructure and avoid additional AWS costs, use:
```shell
make destroy-service
```

## Project Enhancements
The next phase of this project will focus on using NAT gateways to reduce the use of public IPs, thereby lowering AWS billing costs. New components will be added, and further generalization is planned to enhance scalability.
