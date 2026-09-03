locals {
  required_apis = toset([
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "sql-component.googleapis.com",
  ])
}

terraform {
  required_version = "1.16.1"

  cloud {

    organization = "jared-bishop"

    workspaces {
      name = "gcp-miniflux"
    }
  }
}

resource "google_project_service" "required_apis" {
  for_each = local.required_apis
  project  = var.project_id
  service  = each.value

  disable_on_destroy = false
}
