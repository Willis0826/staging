provider "google" {
  project = "staging-blakbear"
  region  = "europe-west1"
}

provider "google-beta" {
  project = "staging-blakbear"
  region  = "europe-west1"
}


terraform {
  backend "gcs" {
    # check these files for more information
    # ./backend/development.tfvars
    # ./backend/production.tfvars
  }
}
