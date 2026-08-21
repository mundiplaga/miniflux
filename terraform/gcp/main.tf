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

# terraform {
#   backend "remote" {
#     organization = "jared-bishop"

#     workspaces {
#       name = "gcp-miniflux"
#     }
#   }
# }

terraform {
  required_version = "1.15.9"

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

resource "google_service_account" "miniflux_service_account" {
  account_id   = "rt-miniflux"
  display_name = "rt-miniflux"
}