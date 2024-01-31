variable "project_id" {
  description = "Project ID"
}

variable "network_name" {
  description = "VPC name"
  default = "vpc"
}

variable "fleets" {
  description = "List of networking configurations per cluster-group"
  type = list(object({
    region       = string
    num_clusters = number
    subnet = object({
      name = string
      cidr = string
    })
  }))
  default = [
    {
      region       = "europe-west3"
      num_clusters = 1
      subnet = {
        name = "europe-west3"
        cidr = "10.1.0.0/17"
      }
    },
    {
      region       = "europe-west4"
      num_clusters = 1
      subnet = {
        name = "europe-west4"
        cidr = "10.2.0.0/17"
      }
    },
  ]
}

variable "gke_config" {
  description = "Networking configuration for the config cluster in the anthos fleet"
  type = object({
    name    = string
    region  = string
    subnet = object({
      name               = string
      ip_range           = string
      ip_range_pods_name = string
      ip_range_pods      = string
      ip_range_svcs_name = string
      ip_range_svcs      = string
    })
  })
  default = {
    name    = "gke-config"
    region  = "europe-west4"
    subnet = {
      name               = "config"
      ip_range           = "10.10.0.0/20" 
      ip_range_pods_name = "config-pods"
      ip_range_pods      = "10.11.0.0/18"
      ip_range_svcs_name = "config-svcs"
      ip_range_svcs      = "10.12.0.0/24"
    }
  }
}
