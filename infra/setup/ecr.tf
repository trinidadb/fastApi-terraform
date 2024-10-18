resource "aws_ecr_repository" "app-repo" {
  name = "${var.namespace}-${var.env}-repo"

  force_delete = true

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}