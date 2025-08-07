resource "kubernetes_namespace" "argo_cd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6"
  namespace  = kubernetes_namespace.argo_cd.metadata[0].name

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.ingress.enabled"
    value = "false"
  }

  set {
    name  = "server.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "server.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "server.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "server.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "repoServer.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "repoServer.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "repoServer.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "repoServer.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "applicationSet.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "applicationSet.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "applicationSet.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "applicationSet.resources.limits.memory"
    value = "256Mi"
  }

  depends_on = [kubernetes_namespace.argo_cd]
}

# Create Argo CD Application for Django app
resource "kubernetes_manifest" "django_app" {
  depends_on = [helm_release.argo_cd]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "django-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/your-username/django-app-charts.git"
        targetRevision = "main"
        path          = "charts/django-app"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "django-app"
      }
      syncPolicy = {
        automated = {
          prune      = true
          selfHeal   = true
          allowEmpty = false
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}

# Create Argo CD Repository
resource "kubernetes_manifest" "django_repo" {
  depends_on = [helm_release.argo_cd]

  manifest = {
    apiVersion = "v1alpha1"
    kind       = "Repository"
    metadata = {
      name      = "django-app-repo"
      namespace = "argocd"
    }
    spec = {
      repo = "https://github.com/your-username/django-app-charts.git"
      type = "git"
    }
  }
} 