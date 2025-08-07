variable "namespace" {
  description = "Kubernetes namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "argocd_admin_password" {
  description = "Admin password for Argo CD"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "argocd_url" {
  description = "Argo CD URL"
  type        = string
  default     = "http://argocd.local"
}

variable "argocd_url_tls" {
  description = "Argo CD TLS URL"
  type        = string
  default     = "https://argocd.local"
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