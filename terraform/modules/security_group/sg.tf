variable "security_group_ingress" {
    type = list(number)
    default = [ ]
}

variable "security_group_egress" {
    type = list(number)
    default = [ ]
}

variable "security_group_name" {
  type = string
}

resource "aws_security_group" "security_group" {
    name = var.security_group_name

    dynamic ingress {
        iterator = port
        for_each = var.security_group_ingress
        content {
            from_port = port.value
            to_port = port.value
            protocol = "TCP"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    dynamic egress {
        iterator = port
        for_each = var.security_group_egress
        content {
            from_port = port.value
            to_port = port.value
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }  
}

output "sg_name" {
    value = aws_security_group.security.name
}