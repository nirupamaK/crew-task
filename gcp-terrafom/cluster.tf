resource "google_container_cluster" "cluster" {
  name     = "app-gke-cluster"
  location = "us-central1-a"
  initial_node_count = 1
  #master_auth {
  #      username = ""
  #      password = ""
  #      }

  network = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.worker_subnet.id
  cluster_ipv4_cidr = "192.168.2.0/24"

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes     = true
  }


  enable_autopilot = false
}

resource "google_container_node_pool" "node_pool" {
  name       = "node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.cluster.name
  node_count = 3

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 50
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",  # Allows access to all Google Cloud services
    ]

    image_type = "COS"  # Container-Optimized OS
  }

  management {
    auto_upgrade = true
    auto_repair   = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }
}

resource "google_project_iam_member" "gke_service_account_roles" {
  project = "nak-project"

  role   = "roles/container.clusterAdmin"
  member = "serviceAccount:${google_service_account.gke_service_account.email}"
}

resource "google_project_iam_member" "gke_node_pool_roles" {
  project = "nak-project"

  role   = "roles/container.nodeAdmin"
  member = "serviceAccount:${google_service_account.gke_service_account.email}"
}

resource "google_service_account" "gke_service_account" {
  account_id   = "gke-cluster-sa"
  display_name = "GKE Cluster Service Account"
}

resource "google_project_service" "gke_services" {
  for_each = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ])

  project = "nak-project"
  service = each.key
}
