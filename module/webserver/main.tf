# launch_template
resource "aws_launch_template" "flex-launch_template" {
  image_id             = "ami-064983766e6ab3419"
  instance_type        = "t3.micro"
  key_name             = var.key
  
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.fe-sg
  }
  user_data = base64encode(local.userdata1)
  tags = {
    Name = "flex-launch_template"
  }
}


# #Auto scaling group  
resource "aws_autoscaling_group" "ASG" {
  name = "ASG"
  max_size = 4
  min_size = 1
  desired_capacity = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  launch_template {
    id = aws_launch_template.flex-launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.vpc_zone_identifiers
  target_group_arns = var.tg-arn
  tag {
    key = "Name"
    value = "asg"
    propagate_at_launch = true
  }
}

# Auto-scaling Group policy 
resource "aws_autoscaling_policy" "ASG_policy" {
  autoscaling_group_name = aws_autoscaling_group.ASG.name
  name = "ASG_policy"
  adjustment_type = "ChangeInCapacity"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

