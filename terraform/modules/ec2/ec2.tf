variable "ec2_config" {
  type = object({
    name = string,
    security_groups_list = list(string),
    user_data_path = string,
    iam_instance_profile = string
  })
}

resource "aws_instance" "ec2" {
    ami = "ami-0e820eb0af36bdc3e"
    instance_type = "t2.micro"
    subnet_id = tolist(data.aws_subnet_ids.default.ids)[0]
    
    vpc_security_group_ids = var.ec2_config.security_groups_list
    iam_instance_profile = var.ec2_config.iam_instance_profile

    user_data = var.ec2_config.user_data_path != null ? file(var.ec2_config.user_data_path) : ""

    tags = {
      Name = var.ec2_config.name
    }
}

output "private_ip" {
  value = aws_instance.ec2.private_ip
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}

output "instance_id" {
  value = aws_instance.ec2.id
}
