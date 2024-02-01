resource "google_sourcerepo_repository" "acm-repo" {
  name = "config"
  project = var.project_id
}

resource "google_sourcerepo_repository" "gateway-repo" {
  name = "gateway"
  project = var.project_id
}

resource "google_artifact_registry_repository" "repo" {
  location      = "europe-west4"
  repository_id = "demos"
  description   = "docker repository for demos for gatewayAPI"
  format        = "DOCKER"
  project = var.project_id
  docker_config {
    immutable_tags = false
  }
}

