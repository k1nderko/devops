from django.contrib import admin
from django.urls import path
from django.http import HttpResponse

def home(request):
    return HttpResponse("""
    <html>
    <head>
        <title>Final Project - Django App</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
            .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            h1 { color: #333; text-align: center; }
            .status { background: #e8f5e8; padding: 15px; border-radius: 5px; margin: 20px 0; }
            .info { background: #f0f8ff; padding: 15px; border-radius: 5px; margin: 20px 0; }
            .component { margin: 10px 0; padding: 10px; background: #f9f9f9; border-left: 4px solid #007cba; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🚀 Final Project - DevOps Pipeline</h1>
            
            <div class="status">
                <h2>✅ Application Status: Running</h2>
                <p>Django application is successfully deployed and running in Kubernetes cluster.</p>
            </div>
            
            <div class="info">
                <h2>📋 Infrastructure Components</h2>
                <div class="component">
                    <strong>AWS Infrastructure:</strong> VPC, EKS, RDS, ECR
                </div>
                <div class="component">
                    <strong>CI/CD Pipeline:</strong> Jenkins, Argo CD
                </div>
                <div class="component">
                    <strong>Monitoring:</strong> Prometheus, Grafana
                </div>
                <div class="component">
                    <strong>Application:</strong> Django with PostgreSQL
                </div>
            </div>
            
            <div class="info">
                <h2>🔗 Access Points</h2>
                <div class="component">
                    <strong>Jenkins:</strong> kubectl port-forward svc/jenkins 8080:8080 -n jenkins
                </div>
                <div class="component">
                    <strong>Argo CD:</strong> kubectl port-forward svc/argocd-server 8081:443 -n argocd
                </div>
                <div class="component">
                    <strong>Grafana:</strong> kubectl port-forward svc/grafana 3000:80 -n monitoring
                </div>
            </div>
            
            <div class="info">
                <h2>📊 Monitoring Commands</h2>
                <div class="component">
                    <strong>Check Pods:</strong> kubectl get all -n jenkins && kubectl get all -n argocd && kubectl get all -n monitoring
                </div>
                <div class="component">
                    <strong>Check Logs:</strong> kubectl logs -n django-app deployment/django-app
                </div>
            </div>
        </div>
    </body>
    </html>
    """)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home, name='home'),
] 