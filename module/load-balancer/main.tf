resource "aws_lb" "flex-lb" {
  name               = "flex-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups = var.fe-security_group

  enable_deletion_protection = false

  tags = {
    Name = "flex-lb"
  }
}


resource "aws_lb_target_group" "flex-tg" {
  name        = "flex-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc-id
  health_check {
    interval = 30
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 5
    //path = "/indextest.html"
  }
}

resource "aws_lb_listener" "flex-listener" {
  load_balancer_arn = aws_lb.flex-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flex-tg.arn
  }
}