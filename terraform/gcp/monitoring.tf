# Google's Terraform provider does not provide a programatic way to create SLO's for non AppEngine services
# so I've opted to import then manage it.

import {
  id = "projects/${var.project_id}/services/${var.slo_service_id}"
  to = google_monitoring_service.miniflux
}

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

import {
  id = "projects/80024592637/services/dBXFKZf0QCSKlkxzNxyw5g/serviceLevelObjectives/xKx8Z70TTVu8hI5EJ8kTUQ"
  to = google_monitoring_slo.request_based_slo
}

resource "google_monitoring_slo" "request_based_slo" {
  service         = google_monitoring_service.miniflux.id
  calendar_period = "WEEK"
  display_name    = "99% - Availability - Calendar week"

  goal = 0.99

  basic_sli {
    availability {

    }
  }
}