resource "aws_ecs_cluster" "main" {
  name = "eg-ecs-cluster"
}

resource "aws_cloudwatch_log_group" "eg" {
  name = "eg-ecs-group"
}

resource "aws_ecs_task_definition" "eg" {
  family                   = "eg"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"

  container_definitions = <<EOF
[
  {
    "name": "event-gateway",
    "image": "${var.eg_image}",
    "command": ["-db-hosts", "${module.etcd.etcd_clients}", "-log-level", "${var.log_level}"],
    "networkMode": "awsvpc",  
    "portMappings": [
      {
        "containerPort": ${var.config_port}
      },
      {
        "containerPort": ${var.events_port}
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.eg.name}",
            "awslogs-region": "${var.aws_region}",
            "awslogs-stream-prefix": "ecs"
        }
    }
  }
]
EOF
}

resource "aws_ecs_service" "config" {
  name            = "eg-config"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.eg.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.config-service-sg.id}"]
    subnets         = ["${aws_subnet.private.*.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.config.id}"
    container_name   = "event-gateway"
    container_port   = "${var.config_port}"
  }

  depends_on = [
    "aws_lb_listener.config",
  ]
}

resource "aws_ecs_service" "events" {
  name            = "eg-events"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.eg.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.event-service-sg.id}"]
    subnets         = ["${aws_subnet.private.*.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.events.id}"
    container_name   = "event-gateway"
    container_port   = "${var.events_port}"
  }

  depends_on = [
    "aws_lb_listener.events",
  ]
}

resource "aws_security_group" "config-service-sg" {
  name        = "eg-config-service"
  description = "Allow only into config API"
  vpc_id      = "${aws_vpc.event-gateway.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.config_port}"
    to_port         = "${var.config_port}"
    security_groups = ["${aws_security_group.lb.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "event-service-sg" {
  name        = "eg-event-service"
  description = "Allow only into events API"
  vpc_id      = "${aws_vpc.event-gateway.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.events_port}"
    to_port         = "${var.events_port}"
    security_groups = ["${aws_security_group.lb.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
