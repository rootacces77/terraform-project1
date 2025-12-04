resource "aws_autoscaling_group" "app" {
  name                      = "app-asg"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1

  # Subnet *IDs* where EC2 instances will run
  vpc_zone_identifier       = var.app_private_subnet_ids

  # Attach to ALB target group
  target_group_arns         = [var.asg_target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 60

  launch_template {
    id      = var.app_template_id  
    version = "$Latest"
  }

  termination_policies = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "app-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = false
  }
}


resource "aws_autoscaling_policy" "scale_out_cpu80" {
  name                   = "app-scale-out-cpu80"
  autoscaling_group_name = aws_autoscaling_group.app.name

  policy_type        = "SimpleScaling"
  adjustment_type    = "ChangeInCapacity"
  scaling_adjustment = 1

  cooldown = 300
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "app-asg-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 80

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  period              = 60
  evaluation_periods  = 3
  datapoints_to_alarm = 3

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [aws_autoscaling_policy.scale_out_cpu80.arn]
}

# Scale IN by -1 only when avg CPU <= 30% for 10 minutes (wait before killing extra instance)
resource "aws_autoscaling_policy" "scale_in_cpu_low" {
  name                   = "app-scale-in-cpu-low"
  autoscaling_group_name = aws_autoscaling_group.app.name

  policy_type        = "SimpleScaling"
  adjustment_type    = "ChangeInCapacity"
  scaling_adjustment = -1

  cooldown = 900
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "app-asg-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = 30

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  period              = 60
  evaluation_periods  = 10
  datapoints_to_alarm = 10

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [aws_autoscaling_policy.scale_in_cpu_low.arn]
}