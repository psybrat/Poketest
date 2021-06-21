locals {
  AMAZON_ROLES_DIR="./AmazonRoles"
}


resource "aws_iam_role" "code_deploy_instance" {
  name               = "pokemon_CodeDeployInstance_role"
  assume_role_policy = "${file("${AMAZON_ROLES_DIR}/AmazonEC2RoleforAWSCodeDeploy.json")}"
}

resource "aws_iam_role" "code_deploy" {
  name               = "pokemon_CodeDeploy_role"
  assume_role_policy = "${file("${AMAZON_ROLES_DIR}/AWSCodeDeployRole.json")}"
}
