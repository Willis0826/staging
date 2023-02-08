data "google_secret_manager_secret" "github-token-secret" {
  secret_id = "GITHUB-PAT"
}

data "google_secret_manager_secret_version" "github-token-secret-version" {
  secret = "GITHUB-PAT"
}

data "google_iam_policy" "serviceagent-secretAccessor" {
  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:service-598938623418@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = data.google_secret_manager_secret.github-token-secret.project
  secret_id   = data.google_secret_manager_secret.github-token-secret.secret_id
  policy_data = data.google_iam_policy.serviceagent-secretAccessor.policy_data
}

resource "google_cloudbuildv2_connection" "github" {
  provider = google-beta
  project  = "staging-blakbear"
  location = "europe-west2"
  name     = "github"

  github_config {
    app_installation_id = 34004486
    authorizer_credential {
      oauth_token_secret_version = data.google_secret_manager_secret_version.github-token-secret-version.id
    }
  }

  depends_on = [google_secret_manager_secret_iam_policy.policy]
}

resource "google_cloudbuildv2_repository" "staging" {
  provider          = google-beta
  name              = "staging-${var.deploy_env}"
  parent_connection = google_cloudbuildv2_connection.github.id
  remote_uri        = "https://github.com/Willis0826/staging.git"
}

resource "google_cloudbuild_trigger" "repo-trigger" {
  provider = google-beta
  location = "europe-west2"
  name     = "staging-${var.deploy_env}"

  repository_event_config {
    repository = google_cloudbuildv2_repository.staging.id
    push {
      branch = var.cloud_build_branch
    }
  }

  filename = "cloudbuild_${var.deploy_env}.yaml"
}
