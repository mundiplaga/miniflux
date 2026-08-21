resource "supabase_project" "production" {
  organization_id   = var.sb_org_id
  name              = var.sb_project_id
  database_password = data.google_secret_manager_secret_version_access.pg_password.secret_data
  region            = "ap-southeast-2"

  lifecycle {
    ignore_changes = [database_password]
  }
}

data "google_secret_manager_secret_version_access" "pg_password" {
  secret = "pg-password"
}