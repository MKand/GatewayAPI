variable "project_id" {
  description = "Project ID"
}

variable "service_name" {
  description = "Name of the service"
  type = string
  default = "unnamed"
}

variable "pipeline_location" {
  description = "Pipeline location."
  type        = string
  default     = "us-central1"
}

