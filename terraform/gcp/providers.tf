provider "google" {
  project = var.project_id
  region  = var.region
}

provider "supabase" {
  access_token = data.google_secret_manager_secret_version_access.sb_access_token.secret_data
}

data "google_secret_manager_secret_version_access" "sb_access_token" {
  secret = "sb-access-token"
}