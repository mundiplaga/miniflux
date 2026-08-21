resource "google_cloud_run_v2_service" "default" {
  name                 = "miniflux"
  location             = var.region
  deletion_protection  = false
  ingress              = "INGRESS_TRAFFIC_ALL"
  invoker_iam_disabled = true

  scaling {
    max_instance_count = 2
  }

  template {
    service_account = google_service_account.miniflux_service_account.email
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
}

data "google_project" "project" {
}

resource "google_secret_manager_secret" "pg_url" {
  secret_id = "pg-url"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_iam_member" "pg_url_access" {
  secret_id  = google_secret_manager_secret.pg_url.id
  role       = "roles/secretmanager.secretAccessor"
  member     = google_service_account.miniflux_service_account.member
  depends_on = [google_secret_manager_secret.pg_url]
}
