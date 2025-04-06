terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "local" {}

resource "null_resource" "minikube_install" {
  provisioner "local-exec" {
    command = <<-EOT
      # Start Minikube
      minikube config set memory 4001
      minikube config set cpus 2
      minikube start --driver=docker
      minikube profile list
      helm version
      kubectl config use-context minikube
      export KUBERNETES_MASTER=minikube
      eval $(minikube -p minikube docker-env)
    EOT
  }
}

output "minikube_status" {
  value = "Minikube is installed and started"
}
