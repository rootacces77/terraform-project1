resource "aws_launch_template" "app_template" {
  name_prefix   = "ec2-app-template"
  image_id      = var.app_ami_id
  instance_type = var.app_instance_type

  iam_instance_profile {
    arn = var.app_ec2_profile_arn
  }

  vpc_security_group_ids = [var.app_ec2_sg_id]

  key_name = var.ec2_key_name

  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
              systemctl enable --now amazon-ssm-agent
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "ec2-app-instance"
      Environment = "PROD"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}