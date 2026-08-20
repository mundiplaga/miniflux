variable "project_id" {
  type    = string
  default = "bishop-sre-example"
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "miniflux_image" {
  type    = string
  default = "miniflux/miniflux:2.3.3"
}

variable "sb_access_token" {
  type = string
}

variable "pg_password" {
  sensitive = true
  type      = string
}

variable "sb_org_id" {
  type    = string
  default = "igfypvohqhxofkatuesc"
}

variable "sb_project_id" {
  type    = string
  default = "my-project"
}

variable "pg_url" {
  sensitive = true
  type      = string
}

variable "miniflux_admin_pw" {
  sensitive = true
  type      = string
}