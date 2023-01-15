output "alb_security_group_id" {
  value=aws_security_grpup.alb_security_group.id
}

output "ecs_security_group_id" {
  value=aws_security_grpup.ecs_security_group.id
}