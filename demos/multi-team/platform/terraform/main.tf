resource "google_compute_global_address" "default" {
  project      = var.project_id 
  name         = "single-cluster-gateway-address"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

resource "google_certificate_manager_certificate_map" "default" {
  name        = "apps-cert-map"
  description = "certificate map"
  project = var.project_id
}