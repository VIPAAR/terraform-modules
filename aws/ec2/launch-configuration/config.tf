data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = [
        "ec2.amazonaws.com",
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "launch_config" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = var.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
  role       = aws_iam_role.launch_config.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.launch_config.name
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  count      = local.policy_arns_count
  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.launch_config.name
}

resource "aws_iam_instance_profile" "launch_config" {
  name = var.name
  role = aws_iam_role.launch_config.name
}

resource "aws_launch_configuration" "launch_config" {
  associate_public_ip_address = var.associate_public_ip_address
  dynamic "ebs_block_device" {
    for_each = [var.ebs_block_devices]
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      no_device             = lookup(ebs_block_device.value, "no_device", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }
  ebs_optimized     = contains(local.ebs_optimized_instance_types, var.instance_type)
  enable_monitoring = true
  dynamic "ephemeral_block_device" {
    for_each = [var.ephemeral_block_devices]
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      device_name  = ephemeral_block_device.value.device_name
      virtual_name = ephemeral_block_device.value.virtual_name
    }
  }
  iam_instance_profile = aws_iam_instance_profile.launch_config.name
  image_id             = var.image_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  lifecycle {
    create_before_destroy = true
  }
  name_prefix       = var.name
  placement_tenancy = var.placement_tenancy
  dynamic "root_block_device" {
    for_each = [var.root_block_device]
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }
  security_groups = var.security_groups
  user_data       = var.user_data
}
