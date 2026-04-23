# Firewall rule to allow HTTP and SSH access
resource "google_compute_firewall" "web_access" {
  name    = "allow-http-and-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["wordpress-server"]
}

# VM Instance
resource "google_compute_instance" "wordpress_vm" {
  name         = "cycling-blog-vm"
  machine_type = "e2-micro"
  tags         = ["wordpress-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  # SSH key
  metadata = {
    ssh-keys = "bartek:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "vm_public_ip" {
  value       = google_compute_instance.wordpress_vm.network_interface[0].access_config[0].nat_ip
  description = "Public IP address of the WordPress VM instance"
}