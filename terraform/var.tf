variable "project_name" {
  type = string
}

variable "deploy_env" {
  type = string
}

variable "cloud_build_branch" {
  type = string
}

variable "cloud_run_limits_cpu" {
  type = string
}

variable "cloud_run_limits_memory" {
  type = string
}

variable "cloud_run_gunicorn_workers" {
  type = string
}

variable "cloud_run_service_min_count" {
  type = number
}

variable "cloud_run_service_max_count" {
  type = number
}

variable "cloud_run_is_public_access" {
  type = bool
}
