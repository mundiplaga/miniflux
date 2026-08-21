locals {
  tf_org_id              = "jared-bishop"
  terraform_workspace_id = "ws-J49Jd51CraBHpR7B"
}

# create a workload identity pool for HCP Terraform
resource "google_iam_workload_identity_pool" "hcp_tf" {
  project                   = var.project_id
  workload_identity_pool_id = "hcp-tf-pool"
  display_name              = "HCP Terraform Pool"
  description               = "Used to authenticate to Google Cloud"
}

# create a workload identity pool provider for HCP Terraform
resource "google_iam_workload_identity_pool_provider" "hcp_tf" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.hcp_tf.workload_identity_pool_id
  workload_identity_pool_provider_id = "hcp-tf-provider"
  display_name                       = "HCP Terraform Provider"
  description                        = "Used to authenticate to Google Cloud"
  attribute_condition                = "assertion.terraform_organization_name==\"${local.tf_org_id}\""
  attribute_mapping = {
    "google.subject"                     = "assertion.sub"
    "attribute.terraform_workspace_id"   = "assertion.terraform_workspace_id"
    "attribute.terraform_full_workspace" = "assertion.terraform_full_workspace"
  }
  oidc {
    issuer_uri = "https://app.terraform.io"
  }
}

resource "google_service_account" "rt_tf" {
  account_id   = "rt-terraform"
  display_name = "Runtime SA for HCP Terraform"
  project      = var.project_id
}

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.rt_tf.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.hcp_tf.name}/attribute.terraform_workspace_id/${local.terraform_workspace_id}"
}
