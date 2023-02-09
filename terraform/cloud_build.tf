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
  location = "europe-west1"
  name     = "github-staging-${var.deploy_env}"

  github_config {
    app_installation_id = 34004486
    authorizer_credential {
      oauth_token_secret_version = data.google_secret_manager_secret_version.github-token-secret-version.id
    }
  }

  depends_on = [google_secret_manager_secret_iam_policy.policy]
}

resource "google_cloudbuildv2_repository" "staging" {
  provider = google-beta

  location          = "europe-west1"
  name              = "staging-${var.deploy_env}"
  parent_connection = google_cloudbuildv2_connection.github.id
  remote_uri        = "https://github.com/Willis0826/staging.git"
}

resource "google_cloudbuild_trigger" "repo-trigger" {
  provider = google-beta
  location = "europe-west1"
  name     = "staging-${var.deploy_env}"

  repository_event_config {
    repository = google_cloudbuildv2_repository.staging.id
    push {
      branch = var.cloud_build_branch
    }
  }

  filename        = "cloudbuild_${var.deploy_env}.yaml"
  service_account = google_service_account.cloudbuild_service_account.id

  depends_on = [
    google_project_iam_member.act_as,
    google_project_iam_member.cloudbuild_builder,
    google_project_iam_member.cloudrun_admin,
    google_project_iam_member.logs_writer,
  ]
}

# permission for cloud build to trigger cloud run deployment
resource "google_service_account" "cloudbuild_service_account" {
  account_id = "staging-sa-${var.deploy_env}"
}

resource "google_project_iam_member" "act_as" {
  project = "staging-blakbear"
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "cloudbuild_builder" {
  project = "staging-blakbear"
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "cloudrun_admin" {
  project = "staging-blakbear"
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "logs_writer" {
  project = "staging-blakbear"
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}
