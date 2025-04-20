# Output values

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = module.vpc.public_subnets
}

output "ollama_launch_template_id" {
  value = aws_launch_template.ollama_launch_template.id
}

output "ollama_asg_name" {
  value = aws_autoscaling_group.ollama_asg.name
}

output "webui_instance_public_ip" {
  value = aws_instance.webui.public_ip
}
