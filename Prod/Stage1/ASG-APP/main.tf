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
