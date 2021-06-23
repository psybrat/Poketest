locals {
  AMAZON_ROLES_DIR="./AmazonRoles"
}


resource "aws_iam_role" "code_deploy_instance" {
  name               = "instance_role"
  assume_role_policy = file("${local.AMAZON_ROLES_DIR}/ec2_role.json")
}

resource "aws_iam_role_policy_attachment" "code_deploy_instance" {
  name = "instance_role_policy"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
  #  policy = file("${local.AMAZON_ROLES_DIR}/AmazonEC2RoleforAWSCodeDeploy.json")
  role = aws_iam_role.code_deploy_instance.name
}


resource "aws_iam_role" "code_deploy" {
  name               = "code_deploy_role"
  assume_role_policy = file("${local.AMAZON_ROLES_DIR}/codedeploy_role.json")
}

resource "aws_iam_role_policy_attachment" "code_deploy_policy" {
  name = "codedeploy_role_policy"
#  policy = file("${local.AMAZON_ROLES_DIR}/AWSCodeDeployRole.json")
  role = aws_iam_role.code_deploy.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}