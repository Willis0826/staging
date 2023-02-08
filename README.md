# staging

staging service for GCP, DASH demonstration!

## Dockerfile

You can decide how many gunicorn workers by giving `GUNICORN_WORKERS=4` without rebuild docker image.

```
docker run -p 8000:8000 -e GUNICORN_WORKERS=4 staging:latest
```

You can enable reload in local development by giving `GUNICORN_RELOAD=True` and `GUNICORN_PRELOAD_APP=False`.

```
docker run -p 8000:8000 -e GUNICORN_RELOAD=True -e GUNICORN_PRELOAD_APP=False staging:latest
```

## Deploy Infra

Run these steps to provision development infra resources.

```
gcloud auth login
gcloud config set project staging-blakbear
gcloud auth application-default login

cd terraform
terraform init -backend-config=./backend/development.tfvars -reconfigure
terraform plan -var-file=./tfvars/share.tfvars -var-file=./tfvars/development.tfvars
terraform apply -var-file=./tfvars/share.tfvars -var-file=./tfvars/development.tfvars
```
