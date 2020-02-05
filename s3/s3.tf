
variable "BucketName" {
  
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "${var.BucketName}"
  acl    = "private"

  tags = {
    Name = "Terraform state"
  }
}

