locals {
  AMAZON_ROLES_DIR="./AmazonRoles"
}


resource "aws_iam_role" "code_deploy_instance" {
  name               = "instance_role"
  assume_role_policy = file("${AMAZON_ROLES_DIR}/ec2_role.json")
}

resource "aws_iam_role_policy" "code_deploy_instance_policy" {
  name = "instance_role_policy"
  policy = file("${AMAZON_ROLES_DIR}/AmazonEC2RoleforAWSCodeDeploy.json")
  role = aws_iam_role.code_deploy_instance.id
}


resource "aws_iam_role" "code_deploy" {
  name               = "code_deploy_role"
  assume_role_policy = file("${AMAZON_ROLES_DIR}/codedeploy_role.json")
}

resource "aws_iam_role_policy" "code_deploy_policy" {
  name = "codedeploy_role_policy"
  policy = file("${AMAZON_ROLES_DIR}/AWSCodeDeployRole.json")
  role = aws_iam_role.code_deploy.id
}