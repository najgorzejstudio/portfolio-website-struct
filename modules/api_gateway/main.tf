resource "aws_api_gateway_rest_api" "resume_api" {
    name = "resume_api"
    description = "Resume site api connecting visit counter to dynamodb"
    
    endpoint_configuration {
      types = [ "REGIONAL" ]
    }
}

resource "aws_api_gateway_resource" "resume_api_resource" {
    parent_id   = aws_api_gateway_rest_api.resume_api.root_resource_id
    path_part   = "counter-path"
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
  
}

resource "aws_api_gateway_method" "resume_method" {
    authorization = "NONE"
    http_method   = "POST"
    resource_id   = aws_api_gateway_resource.resume_api_resource.id
    rest_api_id   = aws_api_gateway_rest_api.resume_api.id

}

resource "aws_api_gateway_integration" "lambda_integration"{
    http_method = aws_api_gateway_method.resume_method.http_method
    resource_id = aws_api_gateway_resource.resume_api_resource.id
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    type        = "AWS_PROXY"

    integration_http_method = "POST"
    uri = var.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    
    triggers = {
      redeployment = sha1(jsonencode([
        aws_api_gateway_resource.resume_api_resource.id,
        aws_api_gateway_method.resume_method.id,
        aws_api_gateway_integration.lambda_integration.id
      ]))
    }

    lifecycle {
      create_before_destroy = true
    }

    depends_on = [ 
        aws_api_gateway_integration.lambda_integration
     ]
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.resume_api.id
  stage_name    = "prod"
}

resource "aws_lambda_permission" "api_lambda_permission" {
    action        = "lambda:InvokeFunction"
    function_name = var.lambda_function_name
    principal     = "apigateway.amazonaws.com"
    statement_id  = "AllowExecutionFromAPIGateway"
    source_arn    = "${aws_api_gateway_rest_api.resume_api.execution_arn}/*/*/*" 
}

resource "aws_api_gateway_method_settings" "throttle" {
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    stage_name  = aws_api_gateway_stage.prod.stage_name
    method_path = "*/*"

    settings {
      throttling_rate_limit  = 5
      throttling_burst_limit = 10
    }
}