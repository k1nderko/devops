# Monitoring namespace
output "monitoring_namespace" {
  description = "The name of the monitoring namespace"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

# Prometheus outputs
output "prometheus_enabled" {
  description = "Whether Prometheus is enabled"
  value       = var.prometheus_enabled
}

output "prometheus_url" {
  description = "The URL of the Prometheus server"
  value       = var.prometheus_enabled ? "http://prometheus-server.${kubernetes_namespace.monitoring.metadata[0].name}.svc.cluster.local:9090" : null
}

# Grafana outputs
output "grafana_enabled" {
  description = "Whether Grafana is enabled"
  value       = var.grafana_enabled
}

output "grafana_url" {
  description = "The URL of the Grafana server"
  value       = var.grafana_enabled ? "http://grafana.${kubernetes_namespace.monitoring.metadata[0].name}.svc.cluster.local:80" : null
}

output "grafana_admin_password" {
  description = "The admin password for Grafana"
  value       = var.grafana_admin_password
  sensitive   = true
}

# Service names for port-forwarding
output "prometheus_service_name" {
  description = "The name of the Prometheus service"
  value       = var.prometheus_enabled ? "prometheus-kube-prometheus-prometheus" : null
}

output "grafana_service_name" {
  description = "The name of the Grafana service"
  value       = var.grafana_enabled ? "grafana" : null
} 