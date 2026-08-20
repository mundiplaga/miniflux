provider "google" {
  project     = var.project_id
  region      = var.region
}

provider "supabase" {
  access_token = var.sb_access_token
}