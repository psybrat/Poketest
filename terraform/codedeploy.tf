resource "aws_codedeploy_app" "pokemon_deploy" {
  name = "pokemon_app_deploy"
}

resource "aws_codedeploy_deployment_group" "pokemon_dg" {
  app_name = aws_codedeploy_app.pokemon_deploy.name
  deployment_group_name = "pokemon_codedeploy_group"
  service_role_arn = aws_iam_role.code_deploy.arn

  deployment_style {
    deployment_type = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  auto_rollback_configuration {
    enabled = true
    events = ["DEPLOYMENT_FAILURE"]
  }

  autoscaling_groups = [aws_autoscaling_group.web.name]

  load_balancer_info {
    elb_info {
      name = aws_elb.web.name
    }
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
    }
    green_fleet_provisioning_option {
      action = "COPY_AUTO_SCALING_GROUP"
    }
  }
}