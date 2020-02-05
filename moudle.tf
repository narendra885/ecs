
provider "aws" {
  region = "${var.AWS_REGION}"
  shared_credentials_file="/Users/AppsTekO20/.aws/credentials"
  #access_key=""
  #secret_key=""
}


module "VPC" {
  source = "./vpc"
  
}
module "ecr" {
  source = "./ecr"
  
}

module "ECS" {
  source = "./ecs"
  ECS_AMIS = "${var.ECS_AMIS}"
  AWS_REGION = "${var.AWS_REGION}"
  vpc_zone_identifier = ["${module.VPC.subnetmain-public-1}", "${module.VPC.subnetmain-public-2}"]
  keyname = "${var.keyname}"
  iam_instance_profile = "${module.iam.ecs-ec2-role}"
  security_groups =["${module.VPC.securitygroup}"]
  ECS_INSTANCE_TYPE = "${var.ECS_INSTANCE_TYPE}"
}
module "myapp" {
  source = "./myapp"
  MYAPP_SERVICE_ENABLE ="${var.MYAPP_SERVICE_ENABLE}"
  MYAPP_VERSION ="${var.MYAPP_VERSION}"
  iam_role = "${module.iam.ecs-service-role}"
 # depends_on = ["${module.iam.iam_policy_attachment}"]
  cluster = "${module.ECS.ecs_cluster}"
  subnets = ["${module.VPC.subnetmain-public-1}", "${module.VPC.subnetmain-public-2}"]
  security_groups = ["${module.VPC.elb-securitygroup}"]
  REPOURL = "${module.ecr.repositoryurl}"
}
module "s3" {
  source = "./s3"
  BucketName = "${var.BucketName}"
}
module "key" {
  source = "./keypair"
  keyname = "${var.keyname}"
}
module "iam" {
  source = "./iam"
  
}
