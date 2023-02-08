provider "google" {
  project = "staging-blakbear"
  region  = "europe-west2"
}

provider "google-beta" {
  project = "staging-blakbear"
  region  = "europe-west2"
}


terraform {
  backend "gcs" {
    # check these files for more information
    # ./backend/development.tfvars
    # ./backend/production.tfvars
  }
}
