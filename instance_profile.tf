resource "aws_iam_role" "medici_webserver_role" {
  name = "medici-ec2-ecr-rds-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "medici_webserver_ecr_read" {
  role       = aws_iam_role.medici_webserver_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


resource "aws_iam_policy" "medici_rds_describe" {
  name = "ec2-rds-describe-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "medici_rds_attach" {
  role       = aws_iam_role.medici_webserver_role.name
  policy_arn = aws_iam_policy.medici_rds_describe.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ecr-rds-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_instance_profile" "medici_webserver_ec2_profile" {
  name = "medici_webserver_ec2_profile"
  role = aws_iam_role.medici_webserver_role.name
}