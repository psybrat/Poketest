locals {
  AMAZON_ROLES_DIR="./AmazonRoles"
}


resource "aws_iam_role" "code_deploy_instance" {
  name               = "instance_role"
  assume_role_policy = file("${local.AMAZON_ROLES_DIR}/ec2_role.json")
}

resource "aws_iam_role_policy_attachment" "code_deploy_instance" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
  role = aws_iam_role.code_deploy_instance.name
}

resource "aws_iam_instance_profile" "code_deploy_instance" {
  name = "ec2-instance-profile-for-CodeDeploy"
  role = aws_iam_role.code_deploy_instance.name
}

resource "aws_iam_policy" "code_deploy_instance" {
  name = "IAM-policy-CD-instance"
  policy = file("${local.AMAZON_ROLES_DIR}/AmazonEC2RoleforAWSCodeDeploy.json")
}


resource "aws_iam_role" "code_deploy" {
  name               = "code_deploy_role"
  assume_role_policy = file("${local.AMAZON_ROLES_DIR}/codedeploy_role.json")
}

resource "aws_iam_role_policy_attachment" "code_deploy_policy" {
  role = aws_iam_role.code_deploy.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}