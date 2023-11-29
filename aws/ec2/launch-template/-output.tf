output "id" {
  value = aws_launch_configuration.launch_template.id
}

output "name" {
  value = aws_launch_configuration.launch_template.name
}

output "instance_role_arn" {
  value = aws_iam_role.launch_template.arn
}