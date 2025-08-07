# Create monitoring namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

# Prometheus Helm Release
resource "helm_release" "prometheus" {
  count = var.prometheus_enabled ? 1 : 0

  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "55.5.0"

  values = [
    yamlencode({
      prometheus = {
        prometheusSpec = {
          retention = "${var.prometheus_retention_days}d"
          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                accessModes = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = var.prometheus_storage_size
                  }
                }
              }
            }
          }
        }
      }
      grafana = {
        enabled = var.grafana_enabled
        adminPassword = var.grafana_admin_password
        persistence = {
          enabled = var.grafana_persistence_enabled
          size = var.grafana_storage_size
        }
        service = {
          type = "ClusterIP"
        }
      }
      alertmanager = {
        enabled = false
      }
    })
  ]

  depends_on = [kubernetes_namespace.monitoring]
}

# Grafana Helm Release (standalone if Prometheus is disabled)
resource "helm_release" "grafana" {
  count = var.grafana_enabled && !var.prometheus_enabled ? 1 : 0

  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "7.0.0"

  values = [
    yamlencode({
      adminPassword = var.grafana_admin_password
      persistence = {
        enabled = var.grafana_persistence_enabled
        size = var.grafana_storage_size
      }
      service = {
        type = "ClusterIP"
      }
      datasources = {
        "datasources.yaml" = {
          apiVersion = 1
          datasources = [
            {
              name = "Prometheus"
              type = "prometheus"
              url = "http://prometheus-server"
              access = "proxy"
              isDefault = true
            }
          ]
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.monitoring]
} 