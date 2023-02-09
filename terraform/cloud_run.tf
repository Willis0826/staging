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
    }
  }
}
