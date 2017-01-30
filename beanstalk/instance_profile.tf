resource "aws_iam_instance_profile" "profile" {
  name  = "profile_${var.app_name}_${var.project}_${var.environment}"
  roles = ["${aws_iam_role.role.name}"]
}

resource "aws_iam_role" "role" {
  name = "role_${var.app_name}_${var.project}_${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
