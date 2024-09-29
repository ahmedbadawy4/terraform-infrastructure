resource "aws_iam_role" "atlantis_role" {
  name = "atlantis-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "atlantis_policy" {
  name = "atlantis-policy"
  role = aws_iam_role.atlantis_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
          "dynamodb:*",
          "ec2:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "atlantis_profile" {
  name = "atlantis-instance-profile"
  role = aws_iam_role.atlantis_role.name
}
