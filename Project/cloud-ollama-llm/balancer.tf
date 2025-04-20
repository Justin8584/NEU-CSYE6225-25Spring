# Load balancer configuration

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# http listener for the load balancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ollama_target_group.arn
  }
}

# Target group for the Ollama EC2 instance
resource "aws_lb_target_group" "ollama_target_group" {
  name     = "${var.project_name}-ollama-tg"
  port     = 11434
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/api/tags"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
    Name = "${var.project_name}-ollama-tg"
  }
}

# Listener rule for the Ollama EC2 target group
resource "aws_lb_listener_rule" "ollama_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ollama_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}
