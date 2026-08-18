resource "google_artifact_registry_project_config" "default" {
  location = var.region
  platform_logs_config {
    # Can't imagine needing these anytime soon.
    logging_state  = "DISABLED"
    # severity_level = "INFO"
  }
}

resource "google_artifact_registry_repository" "miniflux" {
  location      = var.region
  repository_id = "miniflux"
  description   = "miniflux docker repository"
  format        = "DOCKER"
}