output "id" {
  value = aws_launch_configuration.launch_config.id
}

output "name" {
  value = aws_launch_configuration.launch_config.name
}

output "instance_role_arn" {
  value = aws_iam_role.launch_config.arn
}
