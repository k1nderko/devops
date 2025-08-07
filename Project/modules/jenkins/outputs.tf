output "jenkins_url" {
  description = "The URL of the Jenkins server"
  value       = "http://${helm_release.jenkins.name}.${var.namespace}.svc.cluster.local:8080"
}

output "jenkins_admin_password" {
  description = "The admin password for Jenkins"
  value       = var.jenkins_admin_password
  sensitive   = true
}

output "jenkins_namespace" {
  description = "The namespace where Jenkins is deployed"
  value       = kubernetes_namespace.jenkins.metadata[0].name
}

output "jenkins_service_name" {
  description = "The name of the Jenkins service"
  value       = helm_release.jenkins.name
} 