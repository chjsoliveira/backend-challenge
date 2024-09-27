resource "aws_ecr_repository" "auth_cloud_repo" {
  name                 = "authcloud"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "authcloud-repo"
  }
}
