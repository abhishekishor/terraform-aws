resource "aws_security_group" "load_balancer" {
  name        = "${var.env_code}-load_balancer"
  description = "Allow private traffics"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    description = "HTTP from Everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${var.env_code}-load_balancer"
  }

}

resource "aws_lb" "main" {

  name               = var.env_code
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = data.terraform_remote_state.level1.outputs.public_subnet_id

  tags = {

    Name = var.env_code

  }

}

resource "aws_lb_target_group" "main" {

  name     = var.env_code
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.level1.outputs.vpc_id

  health_check {

    enabled             = true
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = 200

  }

}

resource "aws_lb_target_group_attachment" "main" {

  count = length(aws_instance.private)

  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.private[count.index].id
  port             = 80

}

resource "aws_lb_listener" "main" {

  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn

  }

}