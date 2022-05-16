data "google_project" "project" {
    project_id      = var.project_id_target
}

resource "google_compute_instance" "default" {
  project      = data.google_project.project.project_id
  name         = var.compute_name
  machine_type = var.machine_type
  zone         = var.compute_region
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

/*   // Local SSD disk
  scratch_disk {
    interface = "NVME"
  } */

  network_interface {
    network = "default"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}