output "jenkins_url" {
  description = "URL of the Jenkins instance"
  value       = "http://${helm_release.jenkins.name}.${kubernetes_namespace.jenkins.metadata[0].name}.svc.cluster.local:8080"
}

output "admin_password" {
  description = "Admin password for Jenkins"
  value       = helm_release.jenkins.values[0]
  sensitive   = true
}

output "jenkins_namespace" {
  description = "Namespace where Jenkins is deployed"
  value       = kubernetes_namespace.jenkins.metadata[0].name
} 