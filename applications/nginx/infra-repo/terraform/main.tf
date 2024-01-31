module "deploy-pipeline"{
    source = "git::https://github.com/ameer00/Building-Reliable-Platforms-on-GCP-with-Google-SRE.git//modules/deploy-pipeline?ref=tf_in_repo_examples"
    project_id = var.project_id
    service_name = var.service_name
    pipeline_location = var.pipeline_location
}

module "endpoint" {
    source = "git::https://github.com/ameer00/Building-Reliable-Platforms-on-GCP-with-Google-SRE.git//modules/endpoints?ref=tf_in_repo_examples"
    project_id = var.project_id
    service_name = "${var.service_name}"
}