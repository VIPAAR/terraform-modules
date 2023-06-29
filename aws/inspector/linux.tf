resource "aws_inspector_resource_group" "linux" {
  tags = {
    Inspector = "true"
    OS        = "linux"
  }
}

resource "aws_inspector_assessment_target" "linux" {
  name               = "${var.account_name}-linux"
  resource_group_arn = aws_inspector_resource_group.linux.arn
}

resource "aws_inspector_assessment_template" "linux" {
  duration = 3600
  name     = "${var.account_name}-linux"
  rules_package_arns = [
    local.regional_rules_package_arns[data.aws_region.current.name]["security_best_practices"],
    local.regional_rules_package_arns[data.aws_region.current.name]["runtime_behavior_analysis"],
    local.regional_rules_package_arns[data.aws_region.current.name]["common_vulnerabilities_and_exposures"],
  ]
  target_arn = aws_inspector_assessment_target.linux.arn
}
