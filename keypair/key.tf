variable "keyname" {}




resource "tls_private_key" "keygen" {
  algorithm   = "RSA"
  ecdsa_curve = "2048"
}
    output "private"{
        value = tls_private_key.keygen.private_key_pem
    }
    output "public"{
        value = tls_private_key.keygen.public_key_pem
    }
     output "md5"{
        value = tls_private_key.keygen.public_key_fingerprint_md5
    }
resource "aws_key_pair" "key" {
  key_name   = "${var.keyname}"
  public_key = "${tls_private_key.keygen.public_key_openssh}"
}
resource "local_file" "keyfile" {
    content     = tls_private_key.keygen.private_key_pem
    filename = "./${var.keyname}.pem"
    file_permission = "0400"
}