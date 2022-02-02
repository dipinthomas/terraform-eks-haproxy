# Creating sample namespace
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "demo-namespace"
  }
}

# Creating sample deployment
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "terraform-nginx"
    labels = {
      app = "nginx"
    }
    namespace = "demo-namespace"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.7.8"
          name  = "nginx"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.namespace
  ]
}