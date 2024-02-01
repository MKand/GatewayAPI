module "endpoint" {
    source = "git::https://github.com/MKand/GatewayAPI.git//modules/endpoints"
    project_id = var.project_id
    service_name = "${var.service_name}"
    ip_address = var.ip_address
}