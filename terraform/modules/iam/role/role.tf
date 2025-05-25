variable "iam_role_name" {
    type = string
}

variable "assume_role_policy" {
  type = object({
    content = object({
      Version = string,
      Statement = list(object({
      Effect = string,
      Principal = object({
        Service = string
      }),
      Action = string
    }))
    })
  })
}

resource "aws_iam_role" "iam_role" {
  name = var.iam_role_name
  assume_role_policy = var.assume_role_policy.content
}

resource "aws_iam_role_policy_attachment" "attach_ssm" {
  role       = var.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

output "role_name" {
  value = aws_iam_role.iam_role.name
}

