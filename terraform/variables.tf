variable "project_id_target" {
    description = "Google Project ID."
    type        = string
}

variable "compute_name" {
    description = "Name of Compute Engine"
    type        = string
    default     = "airflow-sandbox-plateform"
}

variable "machine_type" {
    description = "Type of Machine"
    type        = string
    default     = "e2-medium"
}

variable "compute_region" {
    description = "Region of compute engine"
    type        = string
    default     = "europe-west1-b"
}

variable "service_account_email" {
    description = "service account email for compute engine"
    type        = string
}