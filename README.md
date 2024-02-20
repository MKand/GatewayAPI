## Getting started

1. Clone this repo.
   ```bash
   git clone https://github.com/ameer00/Building-Reliable-Platforms-on-GCP-with-Google-SRE.git
   cd Building-Reliable-Platforms-on-GCP-with-Google-SRE
   ```
1. Checkout the *tf* branch

   ```bash
   git checkout tf
   ```
**NOTE** If you want to change any of the infrastructure defaults used in this repo, please follow instructions in the **Deploy the platform infrastructure** section and return to the next step.

1. Define your GCP project ID.

   ```bash
   export PROJECT_ID=<YOUR PROJECT ID>
   ```

1. Kick off build with terraform

   ```bash
   ./build.sh --build terraform
   ```

1. View build in the Console.

   ```bash
   https://console.cloud.google.com/cloud-build
   ```

   > This step can take 20-30 minutes to complete.

### Deploy the platform infrastructure.
To deploy the platform infrastructure, you change some of the default values for the infrastructure deployment to suit the needs of your environment.
1. infra/terraform/vpc/variables.tf:
   1. The variable "fleets" defines the GKE subnet locations, name-prefixes, subnet cidrs. These values can be changed to suit your needs. The GKE workload clusters will later be deployed in this vpc using the subnets created by this module.
   1. The variable "gke_config" defines the GKE subnet locations, name, subnet cidrs for the config clusters. These values can be changed to suit your needs. The GKE config cluster will later be deployed in this vpc using the subnets created by this module.

1. infra/terraform/gke/variables.tf: 
   1. The variable *kubernetes_version* is fixed at *1.27.3-gke.100*. This is the version that the repo is tested at. You can change this hard-coded version, but do not use *latest* as a value. This is because the clusters will be torn down and re-created by terraform if the *latest* version changes. 

## Go through demos

### Multicluster demo 
Run ../deployapp.sh

```
./deployapp.sh
```
This will kick off a pipeline module in *demos/multi-cluster/ci.yaml*
This pipeline deploys the necessary infrastructure for the application (endpoints and cloud-deploy pipeline). The latter deploys the necessary k8s configuration files (*demos/multi-cluster/app-repo/k8s*) to the workload cluster and the http route (*demos/multi-cluster/app-repo/k8s/httproute.yaml*) to the config cluster.

### Multi-team/ Gateway Features Demo
Follow *multi-team/Instructions.md*