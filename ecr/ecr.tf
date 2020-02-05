resource "aws_ecr_repository" "myapp" {
  name = "python"
}

output "repositoryurl" {
  value = "${aws_ecr_repository.myapp.repository_url}"
}
