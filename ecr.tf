resource "aws_ecr_repository" "ecr_repo" {
  name                 = "medici_erc_${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}