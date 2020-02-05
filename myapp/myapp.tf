# app

data "template_file" "myapp-task-definition-template" {
  template = "${file("E:/terraform scripts/my scripts/maliecs/ECS Moudle/myapp/templates/app.json.tpl")}"
  vars = {
    REPOSITORY_URL = replace(var.REPOURL, "https://", "")
    APP_VERSION    = var.MYAPP_VERSION
  }
}

resource "aws_ecs_task_definition" "myapp-task-definition" {
  family                = "myapp"
  container_definitions = data.template_file.myapp-task-definition-template.rendered
}
data "aws_ecs_task_definition" "mytask" {
  task_definition = "${aws_ecs_task_definition.myapp-task-definition.family}"
}
resource "aws_ecs_service" "myapp-service" {
  count           = var.MYAPP_SERVICE_ENABLE
  name            = "myapp"
  cluster         = "${var.cluster}"
  task_definition = "${aws_ecs_task_definition.myapp-task-definition.family}:${max("${aws_ecs_task_definition.myapp-task-definition.revision}","${data.aws_ecs_task_definition.mytask.revision}")}"
  desired_count   = 1
  iam_role        = "${var.iam_role}"
 # depends_on      = "${var.depends_on}"

  load_balancer {
    elb_name       = aws_elb.myapp-elb.name
    container_name = "myapp"
    container_port = 80
  }
  
}

# load balancer
resource "aws_elb" "myapp-elb" {
  name = "myapp-elb"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    target              = "HTTP:80/"
    interval            = 60
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  subnets         = "${var.subnets}"
  security_groups = "${var.security_groups}"

  tags = {
    Name = "myapp-elb"
  }
}

