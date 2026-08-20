resource "supabase_project" "production" {
  organization_id   = var.sb_org_id
  name              = var.sb_project_id
  database_password = var.pg_password
  region            = "ap-southeast-2"

  lifecycle {
    ignore_changes = [database_password]
  }
}
