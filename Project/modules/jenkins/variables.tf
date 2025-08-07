variable "namespace" {
  description = "Kubernetes namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "jenkins_admin_password" {
  description = "Admin password for Jenkins"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "jenkins_url" {
  description = "Jenkins URL"
  type        = string
  default     = "http://jenkins.local"
}

variable "jenkins_url_tls" {
  description = "Jenkins TLS URL"
  type        = string
  default     = "https://jenkins.local"
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "ClusterIP"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
} 