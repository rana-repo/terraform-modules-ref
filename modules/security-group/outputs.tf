output "alb_security_group_id" {
  value= aws_security_group.alb_security_group.id
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs_security_group.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds-sg.id
}

output "efs_security_group_id" {
  value = aws_security_group.efs.id
}

output "webserver_security_group_id" {
  value = aws_security_group.webserver_sg.id
}