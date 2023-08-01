resource "aws_inspector_resource_group" "windows" {
  tags = {
    Inspector = "true"
    OS        = "windows"
  }
}

resource "aws_inspector_assessment_target" "windows" {
  name               = "${var.account_name}-windows"
  resource_group_arn = aws_inspector_resource_group.windows.arn
}

resource "aws_inspector_assessment_template" "windows" {
  duration = 3600
  name     = "${var.account_name}-windows"
  rules_package_arns = [
    local.regional_rules_package_arns[data.aws_region.current.name]["runtime_behavior_analysis"],
    local.regional_rules_package_arns[data.aws_region.current.name]["common_vulnerabilities_and_exposures"],
    local.regional_rules_package_arns[data.aws_region.current.name]["cis_operating_system_security_configuration_benchmarks"],
  ]
  target_arn = aws_inspector_assessment_target.windows.arn
}
