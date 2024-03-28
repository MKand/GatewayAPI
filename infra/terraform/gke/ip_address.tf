resource "google_compute_address" "ip_address" {
  name = "gateway-address"
  project = var.project_id
}