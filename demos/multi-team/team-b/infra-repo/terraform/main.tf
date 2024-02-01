data "google_compute_global_address" "gtw-address" {
  name = "single-cluster-gateway-address"
  project      = var.project_id 
}

module "endpoint" {
    source = "git::https://github.com/MKand/GatewayAPI.git//modules/endpoints"
    project_id = var.project_id
    service_name = "${var.service_name}"
    ip_address = data.google_compute_global_address.gtw-address.address
}