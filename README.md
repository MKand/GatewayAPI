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
**NOTE** If you want to change any of the infrastructure defaults used in this repo, please follow instructions in the **Customize the platform infrastructure** section and return to the next step.

1. Define your GCP project ID.

   ```bash
   export PROJECT_ID=<YOUR PROJECT ID>
   ```

1. Kick off build with terraform

This step creates the:
1. VPC and subnets
1. Fleet made up of GKE autopilot clusters (3): Two clusters are used to host workloads whereas the last one is used as a config cluster to host the Gateway related resources.
1. ACM Repo: This repo is used to synchronize cluster configuration across the GKE fleet. The GKE multicluster gateway is deployed through [Config Sync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview) on the clusters. The configuration can be found in the *infra/acm* folder.
1. Static IP address: to be used by the Loadbalancer created by the gateway.
1. Endpoint used as a URL for the multi-cluster app deployment.
 
This step also enables the necessary APIs and ensures that the GKE gateway is created and ready to use.

   ```bash
   ./buildplatform.sh
   ```

1. View build in the Console.

   ```bash
   https://console.cloud.google.com/cloud-build
   ```

   > This step can take 20-30 minutes to complete.
   

### Customise the platform infrastructure.
To deploy the platform infrastructure, you change some of the default values for the infrastructure deployment to suit the needs of your environment.
1. infra/terraform/vpc/variables.tf:
   1. The variable "fleets" defines the GKE subnet locations, name-prefixes, subnet cidrs. These values can be changed to suit your needs. The GKE workload clusters will later be deployed in this vpc using the subnets created by this module.
   1. The variable "gke_config" defines the GKE subnet locations, name, subnet cidrs for the config clusters. These values can be changed to suit your needs. The GKE config cluster will later be deployed in this vpc using the subnets created by this module.

1. infra/terraform/gke/variables.tf: 
   1. The variable *kubernetes_version* is fixed at *1.27.3-gke.100*. This is the version that the repo is tested at. You can change this hard-coded version, but do not use *latest* as a value. This is because the clusters will be torn down and re-created by terraform if the *latest* version changes. 

## Go through demos

### Multicluster demo 
The multicluster deploys the same *whereami* app across both the clusters uses a single MCG to load balance traffic across them. You will be directed to the backend that is hosted closest to your location.

The multicluster gateway uses [Multicluster services](https://cloud.google.com/kubernetes-engine/docs/concepts/multi-cluster-services) to create service imports in the cluster hosting the gateway configuration. 

We need to configure the httproute to listen to the right hostname which will be *whereami.endpoints.$PROJECT_ID.cloud.goog*. Naviagate to *multi-cluster/app-repo/k8s/httproute.yaml and update the hostnames section with the endpoint url created in your project. You'll just need to replace <project-id> with the right value for that.

Run ./deplpy-multicluster-app.sh

```sh
./deploy-multicluster-app.sh
```
This will kick off a pipeline module in *demos/multi-cluster/ci.yaml*
This pipeline deploys the necessary infrastructure for the application (endpoints and cloud-deploy pipeline). The latter deploys the necessary k8s configuration files (*demos/multi-cluster/app-repo/k8s*) to the workload cluster and the http route (*demos/multi-cluster/app-repo/k8s/httproute.yaml*) to the config cluster.


### Multi-team/ Gateway Features Demo
Follow *multi-team/Instructions.md*