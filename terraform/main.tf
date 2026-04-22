# Bucket conf
resource "google_storage_bucket" "wp_assets" {
  name          = "${var.project_id}-wp-assets"
  location      = var.region
  force_destroy = true
  uniform_bucket_level_access = true
}

# Upload SQL file to the bucket
resource "google_storage_bucket_object" "sql_backup" {
  name   = "wordpress.sql"
  bucket = google_storage_bucket.wp_assets.name
  source = "${path.module}/../data/wordpress.sql"
}

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
  name         = "wordpress-docker-instance"
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
    ssh-keys = "ansible:${file("~/.ssh/id_rsa.pub")}"
  }
}

data "google_compute_default_service_account" "default" {}

resource "google_storage_bucket_iam_member" "viewer" {
  bucket = google_storage_bucket.wp_assets.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${data.google_compute_default_service_account.default.email}"
}

output "vm_public_ip" {
  value       = google_compute_instance.wordpress_vm.network_interface[0].access_config[0].nat_ip
  description = "Skopiuj to IP do pliku ansible/inventory.ini"
}

output "bucket_name" {
  value = google_storage_bucket.wp_assets.name
}