locals {
  required_apis = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "secretmanager.googleapis.com",
  ])
}

resource "google_project_service" "required_apis" {
  for_each = local.required_apis
  project = var.project_id
  service = each.value

  disable_on_destroy = false
}