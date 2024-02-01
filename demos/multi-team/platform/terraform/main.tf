resource "google_compute_global_address" "default" {
  project      = var.project_id 
  name         = "single-cluster-gateway-address"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}
