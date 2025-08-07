variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "CA certificate of the EKS cluster"
  type        = string
}

variable "cluster_token" {
  description = "Token for the EKS cluster"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
} 