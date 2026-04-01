resource "aws_iam_user" "aws_deployment_user" {
  name = "AWS_DEPLOYMENT_USER"
}
resource "aws_iam_user_policy_attachment" "ecr_access" {
  user       = aws_iam_user.aws_deployment_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_user_policy_attachment" "ec2_access" {
  user       = aws_iam_user.aws_deployment_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

