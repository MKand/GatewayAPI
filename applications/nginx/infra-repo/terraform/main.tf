module "deploy-pipeline"{
    source = "git::https://github.com/MKand/GatewayAPI.git//modules/deploy-pipeline"
    project_id = var.project_id
    service_name = var.service_name
    pipeline_location = var.pipeline_location
}

module "endpoint" {
    source = "git::https://github.com/MKand/GatewayAPI.git//modules/endpoints"
    project_id = var.project_id
    service_name = "${var.service_name}"
}