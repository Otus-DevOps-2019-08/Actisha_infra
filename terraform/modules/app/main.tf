resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = var.type
  zone         = var.zone
  tags         = ["reddit-app","reddit-http"]
  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }
}
resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}
resource "google_compute_firewall" "firewall_http" {
  name    = "allow-http-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-http"]
}

