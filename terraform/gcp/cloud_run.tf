locals {
  secrets = [
    "pg-url",
    "pg-password",
    "sb-access-token",
    "miniflux-admin-password",
  ]
}

resource "google_service_account" "miniflux_service_account" {
  account_id   = "rt-miniflux"
  display_name = "rt-miniflux"
}

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
        name  = "LOG_FORMAT"
        value = "json"
      }
      env {
        name  = "LOG_LEVEL"
        value = "warning"
      }
      env {
        name = "DATABASE_URL"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.miniflux_secrets["pg-url"].secret_id
            version = "1"
          }
        }
      }
      env {
        name = "ADMIN_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.miniflux_secrets["miniflux-admin-password"].secret_id
            version = "1"
          }
        }
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

data "google_project" "project" {
}

resource "google_secret_manager_secret" "miniflux_secrets" {
  for_each  = toset(local.secrets)
  secret_id = each.value
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_iam_member" "secrets_access" {
  for_each  = google_secret_manager_secret.miniflux_secrets
  secret_id = google_secret_manager_secret.miniflux_secrets[each.key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = google_service_account.miniflux_service_account.member
}
