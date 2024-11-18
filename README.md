# Playing with FastAPI, Terraform and GitHub Actions
This project aimed to create a scalable API structure/template using the FastAPI framework. Containerize the application and deploy it on AWS in a single region and across one or multiple availability zones.

The AWS structure is as follows:

![image](https://github.com/user-attachments/assets/f5e5e2cf-be7e-46b9-abad-5237aa336bfa)

**By default two public subnets, each in one AZ*

When a push is made to the master branch, if the infrastructure has already been provisioned, the docker image will be updated in ECR/ECS.

For information on how to create a secret, refer to: [using secrets in GitHub Actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)

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

Github actions can't connect to services running locally on your machine. GitHub-hosted runners don’t have direct access to services running on localhost of your local machine.

Alternatively, set up a self-hosted runner on your local machine where SonarQube is running. This way, the localhost connection should work since both the runner and SonarQube are on the same machine.

runs-on: self-hosted


https://circleci.com/blog/git-tags-vs-branches/


ENVs

https://medium.com/@sreekanth.thummala/choosing-the-right-git-branching-strategy-a-comparative-analysis-f5e635443423
https://medium.com/novai-devops-101/github-flow-vs-trunk-based-development-a-comprehensive-comparison-48990f8785de
https://www.reddit.com/r/devops/comments/1ebi0e2/how_are_you_guys_dealing_with_github_monorepo/
https://nvie.com/posts/a-successful-git-branching-model/
https://trunkbaseddevelopment.com/
https://aulab.es/articulos-guias-avanzadas/92/el-comando-git-pull-en-git#:~:text=El%20pull%20con%20rebase%20es,el%20historial%20actualizado%20del%20repositorio.
https://statusneo.com/trunk-based-development/
