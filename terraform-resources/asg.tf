# ──────────────────────────────────────────
# LAUNCH TEMPLATE
# Defines what EC2 instance ASG should launch
# ──────────────────────────────────────────
resource "aws_launch_template" "main" {
  name_prefix   = "${var.asg_name}-lt-"
  image_id      = data.aws_ami.ubuntu.id   # uses same data block from ec2.tf
  instance_type = var.instance_type
  key_name      = aws_key_pair.terraform_kp.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }

  # User data — runs on every new instance launch automatically
  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
    echo "<h1>Hello from $(hostname) - Terraform ASG</h1>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.asg_name}-instance"
    }
  }

  tags = {
    Name = "${var.asg_name}-launch-template"
  }
}

# ──────────────────────────────────────────
# AUTO SCALING GROUP
# ──────────────────────────────────────────
resource "aws_autoscaling_group" "main" {
  name                = var.asg_name
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  vpc_zone_identifier = [aws_subnet.public.id, aws_subnet.public2.id]

  # Attach to ALB target group
  target_group_arns = [aws_lb_target_group.main.arn]

  # Health check type — ELB means ALB health check controls instance replacement
  health_check_type         = "ELB"
  health_check_grace_period = 120   # wait 120 sec before checking health on new instance

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.asg_name}-instance"
    propagate_at_launch = true
  }

  depends_on = [aws_lb_listener.http]
}

# ──────────────────────────────────────────
# ASG SCALING POLICY — Scale Out (add instance)
# Triggers when CPU > 70%
# ──────────────────────────────────────────
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.asg_name}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1      # add 1 instance
  cooldown               = 300    # wait 300 sec before scaling again
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.asg_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Scale out when CPU > 70%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

# ──────────────────────────────────────────
# ASG SCALING POLICY — Scale In (remove instance)
# Triggers when CPU < 30%
# ──────────────────────────────────────────
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.asg_name}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1     # remove 1 instance
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.asg_name}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Scale in when CPU < 30%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}

# ──────────────────────────────────────────
# OUTPUTS
# ──────────────────────────────────────────
output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.main.name
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.main.id
}
