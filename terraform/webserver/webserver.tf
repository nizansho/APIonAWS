module "security_group" {
    source = "../modules/security_group"
    security_group_name = "web_sg"
    security_group_ingress = [ 22, 80 ]
    security_group_egress = [ 0 ]
}

module "iam_ec2_role" {
  source = "../modules/iam/role"
  iam_role_name = "ec2_basic_role"
  assume_role_policy = {
    content = jsonencode({
      Version = "2025-05-25",
      Statement = [{
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }]
    })
  }
}

module "iam_profile" {
  source = "../modules/iam/profile"
  iam_role_name = module.iam_ec2_role.name
}

module "WebServer" {
    source = "../modules/ec2"
    ec2_name = "webserver"
    security_groups_list = [aws_security_group.web_sg.id]
    user_data_path = "./ec2-userdata.sh"
    iam_instance_profile = module.iam_profile.name
}