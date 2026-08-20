terraform {
  required_version = ">= 1.15.8"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }

    supabase = {
      source  = "supabase/supabase"
      version = "~> 1.0"
    }
  }
}
