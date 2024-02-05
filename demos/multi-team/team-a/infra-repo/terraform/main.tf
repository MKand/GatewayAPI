data "google_compute_global_address" "gtw-address" {
  name = "single-cluster-gateway-address"
  project      = var.project_id 
}

resource "google_certificate_manager_certificate" "default" {
  name        = "app-a-gtw-cert"
  project = var.project_id
  managed {
    domains = [
        "app-a.endpoints.${var.project_id}.cloud.goog"
      ]
  }
}

resource "google_certificate_manager_certificate_map_entry" "default" {
  name        = "app-a-gtw-cert"
  map         = "apps-cert-map" 
  certificates = [google_certificate_manager_certificate.default.id]
  hostname = "app-a.endpoints.${var.project_id}.cloud.goog"
  project = var.project_id
}

module "endpoint" {
    source = "git::https://github.com/MKand/GatewayAPI.git//modules/endpoints"
    project_id = var.project_id
    service_name = "${var.service_name}"
    ip_address = data.google_compute_global_address.gtw-address.address
}