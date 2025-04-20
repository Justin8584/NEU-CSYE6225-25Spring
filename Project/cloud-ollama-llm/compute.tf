# Compute resources for the project (launch templates, EC2, autoscaling group etc.)

# launch template for Ollama EC2 instance

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "template_file" "ollama_deploy" {
  template = templatefile("${path.module}/ollama_deploy.sh", {
    ollama_model = var.ollama_model
  })
}

resource "aws_launch_template" "ollama_launch_template" {
  name_prefix   = "${var.project_name}-ollama-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.ollama_instance_type
  user_data     = base64encode(data.template_file.ollama_deploy.rendered)
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [
      aws_security_group.ollama_sg.id
    ]
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  tags = {
    Name = "${var.project_name}-ollama-launch-template"
  }
}

data "template_file" "webui_deploy" {
  template = templatefile("${path.module}/webui_deploy.sh", {
    ollama_model = var.ollama_model
    dns_name     = aws_lb.main.dns_name
  })
}

# EC2 instance for webui
resource "aws_instance" "webui" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.webui_instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.webui_sg.id]
  subnet_id                   = module.vpc.public_subnets[0]
  user_data                   = base64encode(data.template_file.webui_deploy.rendered)

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  depends_on = [aws_lb.main]

  tags = {
    Name = "${var.project_name}-webui"
  }
}

# Autoscaling group for Ollama EC2 instance
resource "aws_autoscaling_group" "ollama_asg" {
  name                = "${var.project_name}-ollama-asg"
  desired_capacity    = var.ollama_min_size
  max_size            = var.ollama_max_size
  min_size            = var.ollama_min_size
  vpc_zone_identifier = module.vpc.public_subnets

  launch_template {
    id      = aws_launch_template.ollama_launch_template.id
    version = "$Latest"
  }

  # target group attachment
  target_group_arns         = [aws_lb_target_group.ollama_target_group.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  instance_refresh {
    strategy = "Rolling"
    preferences {
      instance_warmup        = 300
      min_healthy_percentage = 80
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ollama-asg"
    propagate_at_launch = true
  }
}
