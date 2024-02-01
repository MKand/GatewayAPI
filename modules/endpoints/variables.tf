variable "project_id" {
  description = "Project ID"
}

variable "service_name" {
  description = "Service name"
  default = "Unnamed"
}

variable "ip_address" {
  description = "ip address of the endpoint. If empty, will use multicluster gateway IP address"
  default = ""
}