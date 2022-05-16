terraform {
  required_version = ">= 0.13"
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "~> 4.3.0"
    }
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-service-accounts/v4.3.0"
  }

}