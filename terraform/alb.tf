resource "aws_security_group" "lb" {
  name   = "eg-lb"
  vpc_id = "${aws_vpc.event-gateway.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Config load balancer
resource "aws_lb" "config" {
  name            = "eg-config"
  subnets         = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.lb.id}"]
}

resource "aws_lb_listener" "config" {
  load_balancer_arn = "${aws_lb.config.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.config.id}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "config" {
  name        = "eg-config"
  port        = "${var.config_port}"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.event-gateway.id}"
  target_type = "ip"

  health_check = {
    path = "/v1/status"
  }
}

# Events load balancer
resource "aws_lb" "events" {
  name            = "eg-events"
  subnets         = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.lb.id}"]
}

resource "aws_lb_listener" "events" {
  load_balancer_arn = "${aws_lb.events.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.events.id}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "events" {
  name        = "eg-events"
  port        = "${var.events_port}"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.event-gateway.id}"
  target_type = "ip"

  health_check {
    port = "${var.config_port}"
    path = "/v1/status"
  }
}
