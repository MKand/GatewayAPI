output "app_pipeline_id" {
  value = google_clouddeploy_delivery_pipeline.primary.id
}

output "pipeline_id" {
  value = google_clouddeploy_delivery_pipeline.config.id
}

