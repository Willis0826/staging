deploy_env                  = "production"
cloud_build_branch          = "main"
cloud_run_limits_cpu        = "2000m"
cloud_run_limits_memory     = "512Mi"
cloud_run_gunicorn_workers  = 5 # gunicorn worker = (2 x $num_cores) + 1
cloud_run_service_min_count = 1
cloud_run_service_max_count = 3
cloud_run_is_public_access  = true
