output "argo_cd_url" {
  description = "URL of the Argo CD instance"
  value       = "http://${helm_release.argo_cd.name}-server.${kubernetes_namespace.argo_cd.metadata[0].name}.svc.cluster.local:80"
}

output "admin_password" {
  description = "Admin password for Argo CD"
  value       = "admin"
  sensitive   = true
}

output "argo_cd_namespace" {
  description = "Namespace where Argo CD is deployed"
  value       = kubernetes_namespace.argo_cd.metadata[0].name
} 