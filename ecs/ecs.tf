# cluster
resource "aws_ecs_cluster" "example-cluster" {
  name = "example-cluster"
}

resource "aws_launch_configuration" "ecs-example-launchconfig" {
  name_prefix          = "ecs-launchconfig"
  image_id             = "${var.ECS_AMIS[var.AWS_REGION]}"
  instance_type        = "${var.ECS_INSTANCE_TYPE}"
  key_name             = "${var.keyname}"
  iam_instance_profile = "${var.iam_instance_profile}"
  security_groups      = "${var.security_groups}"
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=example-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs-example-autoscaling" {
  name                 = "ecs-example-autoscaling"
  vpc_zone_identifier  = "${var.vpc_zone_identifier}"
  launch_configuration = "${aws_launch_configuration.ecs-example-launchconfig.name}"
  min_size             = 1
  max_size             = 1
  tag {
    key                 = "Name"
    value               = "ecs-ec2-container"
    propagate_at_launch = true
  }
}

output "ecs_cluster" {
  value = "${aws_ecs_cluster.example-cluster.id}"
}
