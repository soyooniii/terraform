resource "aws_autoscaling_group" "terraform-asg" {
  name = "terraform-asg"
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  health_check_grace_period = 40
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier = [aws_subnet.terraform-app-1.id, aws_subnet.terraform-app-2.id]

  launch_template {
    id      = aws_launch_template.terraform-app-tem.id
  }
}

resource "aws_autoscaling_attachment" "terraformAsgAttachment" {
  autoscaling_group_name = "terraform-asg"
  lb_target_group_arn    = aws_lb_target_group.terraform-alb-tg.arn
}

resource "aws_autoscaling_policy" "terraform-asg-policy" {
  autoscaling_group_name = "terraform-asg"
  name                   = "terraform-asg-policy"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
    disable_scale_in = true
  }
}