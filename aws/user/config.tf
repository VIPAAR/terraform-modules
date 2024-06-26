data "aws_caller_identity" "current" {
}

resource "aws_iam_user" "user" {
  name = var.name
}

data "aws_iam_policy_document" "user_profile_self_service" {
  statement {
    actions = [
      "iam:*AccessKey*",
      "iam:*LoginProfile",
      "iam:*SigningCertificate*",
    ]
    resources = [
      aws_iam_user.user.arn,
    ]
    sid = "AllowIndividualUserToManageTheirAccountInformation"
  }

  statement {
    actions = [
      "iam:CreateVirtualMFADevice",
    ]
    resources = [
      "arn:aws:iam::*:mfa/*",
    ]
    sid = "AllowUserToCreateMFADevices"
  }

  statement {
    actions = [
      "iam:DeactivateMFADevice",
      "iam:EnableMFADevice",
      "iam:ListMFADevices",
      "iam:ResyncMFADevice"
    ]
    resources = [
      aws_iam_user.user.arn,
    ]
    sid = "AllowIndividualUserToManageTheirMFA"
  }

  statement {
    actions = [
      "iam:GetRolePolicy",
      "iam:GetRoles",
      "iam:ListRoles",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
    ]
    sid = "AllowUserToViewRoles"
  }

  statement {
    actions = [
      "iam:ListGroups",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:group/*",
    ]
    sid = "AllowUserToListGroups"
  }
}

resource "aws_iam_user_policy" "user_profile_self_service" {
  name   = "UserProfileSelfService"
  policy = data.aws_iam_policy_document.user_profile_self_service.json
  user   = aws_iam_user.user.name
}

data "aws_iam_policy_document" "enforce_mfa" {
  statement {
    condition {
      test = "BoolIfExists"
      values = [
        "false",
      ]
      variable = "aws:MultiFactorAuthPresent"
    }
    effect = "Deny"
    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetMFADevice",
      "iam:ResyncMFADevice",
      "iam:ChangePassword",
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary",
      "iam:List*MFADevices",
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:GetUser",
    ]
    resources = [
      "*",
    ]
    sid = "DenyEverythingExceptForBelowUnlessMFAd"
  }

  statement {
    condition {
      test = "BoolIfExists"
      values = [
        "false",
      ]
      variable = "aws:MultiFactorAuthPresent"
    }
    effect = "Deny"
    actions = [
      "iam:EnableMFADevice",
      "iam:GetMFADevice",
      "iam:ResyncMFADevice",
      "iam:ListMFADevices",
      "iam:ChangePassword",
      "iam:GetAccountSummary",
    ]
    not_resources = [
      aws_iam_user.user.arn,
    ]
    sid = "DenyIamAccessToOtherAccountsUnlessMFAd"
  }
}

resource "aws_iam_user_policy" "enforce_mfa" {
  name   = "EnforceMFA"
  policy = data.aws_iam_policy_document.enforce_mfa.json
  user   = aws_iam_user.user.name
}

resource "aws_iam_user_policy_attachment" "manage_specific_credentials" {
  policy_arn = "arn:aws:iam::aws:policy/IAMSelfManageServiceSpecificCredentials"
  user       = aws_iam_user.user.name
}

resource "aws_iam_user_policy_attachment" "change_password" {
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
  user       = aws_iam_user.user.name
}

resource "aws_iam_user_policy_attachment" "manage_ssh_keys" {
  policy_arn = "arn:aws:iam::aws:policy/IAMUserSSHKeys"
  user       = aws_iam_user.user.name
}

resource "aws_iam_user_policy_attachment" "iam_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
  user       = aws_iam_user.user.name
}
