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

resource "aws_iam_role" "launch_template" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = var.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
  role       = aws_iam_role.launch_template.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.launch_template.name
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  count      = local.policy_arns_count
  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.launch_template.name
}

resource "aws_iam_instance_profile" "launch_template" {
  name = var.name
  role = aws_iam_role.launch_template.name
}

resource "aws_launch_template" "launch_template" {
  name                   = var.name
  ebs_optimized          = contains(local.ebs_optimized_instance_types, var.instance_type)
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  user_data              = base64encode(var.user_data)
  vpc_security_group_ids = var.security_groups

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = lookup(block_device_mappings.value, "device_name", null)
      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = lookup(block_device_mappings.value, "ebs", null) == null ? [] : ["ebs"]
        content {
          delete_on_termination = lookup(block_device_mappings.value.ebs, "delete_on_termination", null)
          encrypted             = lookup(block_device_mappings.value.ebs, "encrypted", null)
          iops                  = lookup(block_device_mappings.value.ebs, "iops", null)
          throughput            = lookup(block_device_mappings.value.ebs, "throughput", null)
          kms_key_id            = lookup(block_device_mappings.value.ebs, "kms_key_id", null)
          snapshot_id           = lookup(block_device_mappings.value.ebs, "snapshot_id", null)
          volume_size           = lookup(block_device_mappings.value.ebs, "volume_size", null)
          volume_type           = lookup(block_device_mappings.value.ebs, "volume_type", null)
        }
      }
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.launch_template.name
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
  }

  placement {
    tenancy = var.tenancy
  }
}
