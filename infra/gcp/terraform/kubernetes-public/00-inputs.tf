/*
This file defines:
- Required Terraform version
- Required provider versions
- Storage backend details
- GCP project configuration
*/

locals {
  prow_owners = "k8s-infra-prow-oncall@kubernetes.io"
}

terraform {
  required_version = "~> 1.0.0"

  backend "gcs" {
    bucket = "k8s-infra-tf-public-clusters"
    prefix = "kubernetes-public/aaa" // $project_name/$cluster_name
  }

  required_providers {
    google = {
      version = "~> 3.74.0"
    }
    google-beta = {
      version = "~> 3.74.0"
    }
  }
}

// This configures the source project where we should install the cluster
data "google_project" "project" {
  project_id = "kubernetes-public"
}
