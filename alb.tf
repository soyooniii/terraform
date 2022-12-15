resource "aws_lb" "terraformAlb" {
  name               = "terraform-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraform-app-sg.id]
  subnet_mapping {
    subnet_id            = aws_subnet.terraform-app-1.id
  }

  subnet_mapping {
    subnet_id            = aws_subnet.terraform-app-2.id
  }
}

resource "aws_lb_target_group" "terraform-was-alb-tg" {
  name     = "terraform-alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform-vpc.id

    load_balancing_algorithm_type = "least_outstanding_requests"

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }

  health_check {
    healthy_threshold   = 3
    interval            = 10
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.project-was-alb
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.terraform-alb.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraform-alb-tg.arn
  }
}