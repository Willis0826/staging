# staging

staging service for GCP, DASH demonstration!

## Dockerfile

You can decide how many gunicorn workers by giving `GUNICORN_WORKERS=4` without rebuild docker image.

```bash
docker run -p 8000:8000 -e GUNICORN_WORKERS=4 staging:latest
```

You can enable reload in local development by giving `GUNICORN_RELOAD=True` and `GUNICORN_PRELOAD_APP=False`.

```bash
docker run -p 8000:8000 -e GUNICORN_RELOAD=True -e GUNICORN_PRELOAD_APP=False staging:latest
```

## Deploy Infra

Run these steps to provision GCP infra resources.

```bash
gcloud auth login
gcloud config set project staging-blakbear
gcloud auth application-default login

cd terraform
# dev
terraform init -backend-config=./backend/development.tfvars -reconfigure
terraform plan -var-file=./tfvars/share.tfvars -var-file=./tfvars/development.tfvars
terraform apply -var-file=./tfvars/share.tfvars -var-file=./tfvars/development.tfvars

# prod
terraform init -backend-config=./backend/production.tfvars -reconfigure
terraform plan -var-file=./tfvars/share.tfvars -var-file=./tfvars/production.tfvars
terraform apply -var-file=./tfvars/share.tfvars -var-file=./tfvars/production.tfvars
```

## Development environment

When we access development environment, we need to send our requests with `Authorization` Header.

Please note, development environment will scale down to 0 instance.
Therefore, the first time you access this service may take longer to get response.

```bash
curl -H \
"Authorization: Bearer $(gcloud auth print-identity-token)" \
https://staging-development-62ffxf2jla-ew.a.run.app
```

## Production environment

```bash
curl https://staging-production-62ffxf2jla-ew.a.run.app
```