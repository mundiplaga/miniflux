resource "google_monitoring_notification_channel" "default" {
  display_name = "SLO - Availability Alert"
  type         = "email"
  labels = {
    email_address = var.email_address
  }
}

# Google's Terraform provider does not provide a programatic way to create SLO's for non AppEngine services
# so I've opted to import then manage it.

# import {
#   id = "projects/${var.project_id}/services/${var.slo_service_id}"
#   to = google_monitoring_service.miniflux
# }

resource "google_monitoring_service" "miniflux" {
  service_id   = var.slo_service_id
  display_name = "miniflux"
  basic_service {
    service_labels = {
      location     = var.region
      service_name = "miniflux"
    }
    service_type = "CLOUD_RUN"
  }
}

# Ongoing provider issues with SLOs. I attempted an import of an SLO created in
# the UI, however it's state does not contain a "service" field, which is 
# required for this terraform resource. 

# resource "google_monitoring_slo" "request_based_slo" {
#     calendar_period     = "WEEK"
#     deletion_policy     = "DELETE"
#     display_name        = "99% - Availability - Calendar week"
#     goal                = 0.99
#     id                  = "projects/80024592637/services/dBXFKZf0QCSKlkxzNxyw5g/serviceLevelObjectives/GHSBuJOuRHW5GOJHQSy4jA"
#     name                = "projects/80024592637/services/dBXFKZf0QCSKlkxzNxyw5g/serviceLevelObjectives/GHSBuJOuRHW5GOJHQSy4jA"
#     project             = "bishop-sre-example"
#     rolling_period_days = 0
#     slo_id              = "GHSBuJOuRHW5GOJHQSy4jA"
#     user_labels         = {}

#     basic_sli {
#         location = []
#         method   = []
#         version  = []

#         availability {
#             enabled = true
#         }
#     }
# }

resource "google_monitoring_slo" "request_based_slo" {
  service         = google_monitoring_service.miniflux.service_id
  goal            = 0.99
  calendar_period = "WEEK"
  basic_sli {
    availability {
    }
  }
}

resource "google_monitoring_alert_policy" "cpu" {
  display_name          = "Container CPU utilization"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.default.id]
  severity              = "WARNING"
  alert_strategy {
    notification_prompts = [
      "OPENED"
    ]
  }
  documentation {
    mime_type = "text/markdown"
    subject   = "CPU Alert"
    content   = "Check logs"
  }
  conditions {
    display_name = "Cloud Run Revision - Container CPU Utilization"

    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      filter          = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/container/cpu/utilizations\""
      threshold_value = 0.8

      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_PERCENTILE_99"
        group_by_fields = [
          "resource.label.service_name",
        ]
        per_series_aligner = "ALIGN_SUM"
      }

      trigger {
        count   = 1
        percent = 0
      }
    }
  }
}


