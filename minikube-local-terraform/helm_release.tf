provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "crew-task-app" {
  name       = "crew-task-app"
  chart      = "./crew-task-app"
  version    = "0.1.0"
  namespace  = "default"
  timeout    = 300
  set {
    name  = "image.repository"
    value = "nirupamak/crew-task"
  }
  set {
    name  = "image.tag"
    value = "latest"
  }
  depends_on = [ null_resource.minikube_install ]
}
