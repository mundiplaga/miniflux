resource "google_cloud_run_v2_service" "default" {
  name                = "miniflux"
  location            = var.region
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"

  scaling {
    max_instance_count = 2
  }

  template {
    containers {
      image = var.miniflux_image

      env {
        name  = "DATABASE_URL"
        value = var.pg_url
      }
      env {
        name  = "RUN_MIGRATIONS"
        value = "1"
      }
      env {
        name  = "CREATE_ADMIN"
        value = "1"
      }
      env {
        name  = "ADMIN_USERNAME"
        value = "admin"
      }
      env {
        name  = "ADMIN_PASSWORD"
        value = var.miniflux_admin_pw
      }
      #   env {
      #     name = "SECRET_ENV_VAR"
      #     value_source {
      #       secret_key_ref {
      #         secret = google_secret_manager_secret.secret.secret_id
      #         version = "1"
      #       }
      #     }
      #   }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
  #   depends_on = [google_secret_manager_secret_version.secret-version-data]
}

data "google_project" "project" {
}

# resource "google_secret_manager_secret" "secret" {
#   secret_id = "secret-1"
#   replication {
#     auto {}
#   }
# }

# resource "google_secret_manager_secret_version" "secret-version-data" {
#   secret = google_secret_manager_secret.secret.name
#   secret_data = "secret-data"
# }

# resource "google_secret_manager_secret_iam_member" "secret-access" {
#   secret_id = google_secret_manager_secret.secret.id
#   role      = "roles/secretmanager.secretAccessor"
#   member    = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
#   depends_on = [google_secret_manager_secret.secret]
# }
