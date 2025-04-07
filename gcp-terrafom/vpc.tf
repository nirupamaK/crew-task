resource "google_compute_network" "vpc" {
  name                    = "k8s-vpc"
  auto_create_subnetworks  = "false"
}

resource "google_compute_subnetwork" "master_subnet" {
  name          = "master-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "192.168.1.0/24"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "worker_subnet" {
  name          = "worker-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "192.168.2.0/24"
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal-communication"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["192.168.0.0/16"]
}
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_k8s_api" {
  name    = "allow-k8s-api"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = ["0.0.0.0/0"]
}