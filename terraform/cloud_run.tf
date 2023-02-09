resource "google_cloud_run_v2_service" "staging" {
  name     = "staging-${var.deploy_env}"
  location = "europe-west1"

  template {
    containers {
      image = "gcr.io/staging-blakbear/staging-${var.deploy_env}"
      startup_probe {
        initial_delay_seconds = 10
        timeout_seconds       = 3
        period_seconds        = 3
        failure_threshold     = 1
        http_get {
          path = "/"
        }
      }
      liveness_probe {
        http_get {
          path = "/"
        }
      }
      ports {
        container_port = 8000
      }
    }

    scaling {
      min_instance_count = var.cloud_run_service_min_count
      max_instance_count = var.cloud_run_service_max_count
    }
  }
}

# public access for cloud run service
data "google_iam_policy" "public-access" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_v2_service_iam_policy" "staging-policy" {
  count       = var.cloud_run_is_public_access ? 1 : 0
  project     = google_cloud_run_v2_service.staging.project
  location    = google_cloud_run_v2_service.staging.location
  name        = google_cloud_run_v2_service.staging.name
  policy_data = data.google_iam_policy.public-access.policy_data
}