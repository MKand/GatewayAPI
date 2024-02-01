locals {
  targets = jsondecode(data.google_storage_bucket_object_content.clusters_info.content)
  config = jsondecode(data.google_storage_bucket_object_content.config_cluster_info.content)[0]
}

data "google_storage_bucket_object_content" "clusters_info" {
  name   = "platform-values/clusters.json"
  bucket = var.project_id
}

data "google_storage_bucket_object_content" "config_cluster_info" {
  name   = "platform-values/config_cluster.json"
  bucket = var.project_id
}

resource "google_service_account" "clouddeploy" {
  project = var.project_id
  account_id   = "clouddeploy-${var.service_name}"
  display_name = "Cloud Deploy Service Account"
}

resource "google_project_iam_member" "clouddeploy_container_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.clouddeploy.email}"
}

resource "google_project_iam_member" "clouddeploy_member_deploy_jobrunner" {
  project = var.project_id
  role    = "roles/clouddeploy.jobRunner"
  member  = "serviceAccount:${google_service_account.clouddeploy.email}"
}

resource "google_clouddeploy_target" "child_target_apps" {
  for_each = { for i, v in local.targets : i => v }
  location = var.pipeline_location
  name     = "child-target-${var.service_name}-${each.value.name}"
  execution_configs {
    usages            = ["RENDER", "DEPLOY"]
    service_account = google_service_account.clouddeploy.email
  }
  gke {
    cluster = each.value.id
  }

  project          = var.project_id
  require_approval = false
}

resource "google_clouddeploy_target" "config_target" {
  location = var.pipeline_location
  name     = "config-target-${var.service_name}"
  execution_configs {
    usages            = ["RENDER", "DEPLOY"]
    service_account = google_service_account.clouddeploy.email
  }
  gke {
    cluster = local.config.id
  }

  project          = var.project_id
  require_approval = false
}

resource "google_clouddeploy_target" "multi_target_apps" {
  location = var.pipeline_location
  name     = "multi-target-${var.service_name}"

  multi_target {
    target_ids =[ for v in local.targets : "child-target-${var.service_name}-${v.name}" ]
  }

  project          = var.project_id
  require_approval = false
}

resource "google_clouddeploy_delivery_pipeline" "primary" {
  location = var.pipeline_location
  name     = lower("${var.service_name}-pipeline")

  description = "Service delivery pipeline for the service ${var.service_name} for app clusters."
  project     = var.project_id

  serial_pipeline {

    stages {
        profiles  = []
        target_id = google_clouddeploy_target.multi_target_apps.target_id
    }
  }
  provider = google-beta
}


resource "google_clouddeploy_delivery_pipeline" "config" {
  location = var.pipeline_location
  name     = lower("config-${var.service_name}-pipeline")

  description = "Service delivery pipeline for the config service ${var.service_name} for app clusters."
  project     = var.project_id

  serial_pipeline {

    stages {
        profiles  = []
        target_id = google_clouddeploy_target.config_target.target_id
    }
  }
  provider = google-beta
}