resource "aws_iam_user" "aws_deployment_user" {
  name = "AWS_DEPLOYMENT_USER"
}

# assume role policy to be addeded in TF

resource "aws_iam_role" "aws_deployment_role" {
  name               = "AWS_DEPLOYMENT_ROLE"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_deployment_user.json
}



resource "aws_iam_policy" "deployment_user_policy" {
  name = "aws_deployment_pipeline"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["ecr:CompleteLayerUpload",
        "ecr:GetAuthorizationToken",
        "ecr:UploadLayerPart",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
      "ecr:BatchCheckLayerAvailability"]
      Resource = ["${aws_ecr_repository.ecr_repo.arn}"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "deployment_user_policy_attachement" {
  role       = aws_iam_role.aws_deployment_role.name
  policy_arn = aws_iam_policy.deployment_user_policy.arn
}


### Instance Profile

resource "aws_iam_role" "web_server_instance_profile_role" {
  name               = "MEDICI_WEB_SERVER_INSTANCE_PROFILE"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_medici_web_server.json
}

resource "aws_iam_instance_profile" "web_server_instance_profile" {
  name = "medici_webserver_instance_profile"
  role = aws_iam_role.web_server_instance_profile_role.name
}

resource "aws_iam_role_policy_attachment" "medici_web_server_instance_profile_policy_attachement" {
  role       = aws_iam_role.web_server_instance_profile_role.name
  policy_arn = aws_iam_policy.deployment_user_policy.arn
}