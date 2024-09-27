resource "aws_ecr_repository" "auth_cloud_repo" {
  name                 = "AuthCloud"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "AuthCloud-repo"
  }
}
