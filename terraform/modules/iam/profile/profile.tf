variable "iam_role_name" {
  type = string
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "ec2-instance-profile"
  role = var.iam_role_name
}

output "name" {
  value = aws_iam_instance_profile.iam_profile.name
}