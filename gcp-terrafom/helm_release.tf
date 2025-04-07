data "google_client_config" "config" {}


provider "kubernetes" {
  host                   = google_container_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.config.access_token
}


provider "helm" {
  kubernetes {
    host                   = google_container_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.config.access_token
  }
}

resource "helm_release" "crew-task-app" {
  name       = "crew-task-app"
  chart      = "./crew-task-app"
  version    = "0.1.0"
  namespace  = "kube-system"
  timeout    = 300
  set {
    name  = "image.repository"
    value = "nirupamak/crew-task"
  }
  set {
    name  = "image.tag"
    value = "latest"
  }
  depends_on = [ data.google_client_config.config ]
}
