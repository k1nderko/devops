output "argocd_url" {
  description = "The URL of the Argo CD server"
  value       = "http://${helm_release.argocd.name}-server.${var.namespace}.svc.cluster.local:80"
}

output "argocd_admin_password" {
  description = "The admin password for Argo CD"
  value       = var.argocd_admin_password
  sensitive   = true
}

output "argocd_namespace" {
  description = "The namespace where Argo CD is deployed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_service_name" {
  description = "The name of the Argo CD service"
  value       = "${helm_release.argocd.name}-server"
} 