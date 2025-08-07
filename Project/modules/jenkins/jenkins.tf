# Create Jenkins namespace
resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

# Jenkins Helm Release
resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = kubernetes_namespace.jenkins.metadata[0].name
  version    = "4.6.0"

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [kubernetes_namespace.jenkins]
} 