terraform {
  backend "gcs" {
    bucket  = "foundation-terraform-rair-market-dev"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project     = "rair-market-dev"
}

provider "hcp" {}

module "config" {
  source = "../../shared/env_config"
}

module "foundation" {
  source = "../../../modules/foundation"

  env_name = "dev"
  region = "us-west1"
  gcp_project_id = "rair-market-dev"
  vpc_cidr_block = module.config.env_config.dev.vpc_cidr_block
  mongo_atlas_org_id = module.config.mongo_atlas_org_id
  jenkins_internal_load_balancer_name = module.config.jenkins_internal_load_balancer_name
  rair_internal_load_balancer_name = module.config.rair_internal_load_balancer_name
}

module "hcp_cloud" {
  source = "../../../modules/hcp_cloud"
  env_name = "dev"
}

output "complete_output" {
  value = module.foundation.complete_output
}