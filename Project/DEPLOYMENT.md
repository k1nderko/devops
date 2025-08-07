# 🚀 Фінальний Проект - Покрокова Інструкція Розгортання

Цей документ містить детальні інструкції для розгортання повної інфраструктури з усіма компонентами фінального проекту.

## 📋 Технічні Вимоги

### Інфраструктура
- **AWS** з використанням Terraform
- **Компоненти**: VPC, EKS, RDS, ECR, Jenkins, Argo CD, Prometheus, Grafana

### Програмне забезпечення
- Terraform >= 1.0
- kubectl
- helm
- aws-cli
- git

## 🏗️ Структура Проекту

```
Project/
│
├── main.tf         # Головний файл для підключення модулів
├── backend.tf      # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── variables.tf    # Загальні змінні
├── outputs.tf      # Загальні виводи ресурсів
│
├── modules/        # Каталог з усіма модулями
│  ├── s3-backend/  # Модуль для S3 та DynamoDB
│  ├── vpc/         # Модуль для VPC
│  ├── ecr/         # Модуль для ECR
│  ├── eks/         # Модуль для Kubernetes кластера
│  ├── rds/         # Модуль для RDS
│  ├── jenkins/     # Модуль для Helm-установки Jenkins
│  ├── argo_cd/     # Модуль для Helm-установки Argo CD
│  └── monitoring/  # Модуль для Prometheus + Grafana
│
├── charts/         # Helm charts
│  └── django-app/  # Django application chart
│
└── Django/         # Django application
    ├── app/        # Django app code
    ├── Dockerfile  # Docker configuration
    ├── Jenkinsfile # CI/CD pipeline
    └── docker-compose.yaml # Local development
```

## 🚀 Етапи Розгортання

### 1. Підготовка середовища

#### 1.1 Налаштування AWS CLI
```bash
# Налаштування AWS CLI
aws configure

# Перевірка налаштувань
aws sts get-caller-identity
```

#### 1.2 Створення S3 bucket для Terraform state
```bash
# Створення S3 bucket (якщо не існує)
aws s3 mb s3://devops-terraform-state-bucket

# Включення версіонування
aws s3api put-bucket-versioning \
    --bucket devops-terraform-state-bucket \
    --versioning-configuration Status=Enabled
```

#### 1.3 Створення DynamoDB table для state locking
```bash
# Створення DynamoDB table
aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
```

### 2. Ініціалізація Terraform

#### 2.1 Ініціалізація
```bash
# Ініціалізація Terraform
terraform init

# Перевірка конфігурації
terraform validate
```

#### 2.2 Перевірка плану
```bash
# Перевірка плану розгортання
terraform plan

# Перевірка змінних
terraform plan -var="db_password=your-secure-password"
```

### 3. Розгортання інфраструктури

#### 3.1 Застосування змін
```bash
# Розгортання всієї інфраструктури
terraform apply

# Або з вказанням паролю
terraform apply -var="db_password=your-secure-password"
```

#### 3.2 Перевірка статусу ресурсів
```bash
# Отримання outputs
terraform output

# Перевірка EKS кластера
aws eks describe-cluster --name final-project-cluster

# Налаштування kubectl
aws eks update-kubeconfig --name final-project-cluster --region us-east-1
```

### 4. Перевірка доступності компонентів

#### 4.1 Jenkins
```bash
# Перевірка статусу Jenkins
kubectl get all -n jenkins

# Port forwarding для доступу до Jenkins
kubectl port-forward svc/jenkins 8080:8080 -n jenkins

# Відкрийте браузер: http://localhost:8080
# Пароль: terraform output jenkins_admin_password
```

#### 4.2 Argo CD
```bash
# Перевірка статусу Argo CD
kubectl get all -n argocd

# Port forwarding для доступу до Argo CD
kubectl port-forward svc/argocd-server 8081:443 -n argocd

# Відкрийте браузер: https://localhost:8081
# Пароль: terraform output argocd_admin_password
```

#### 4.3 Monitoring (Prometheus + Grafana)
```bash
# Перевірка статусу monitoring
kubectl get all -n monitoring

# Port forwarding для доступу до Grafana
kubectl port-forward svc/grafana 3000:80 -n monitoring

# Відкрийте браузер: http://localhost:3000
# Логін: admin
# Пароль: terraform output grafana_admin_password
```

### 5. Моніторинг та перевірка метрик

#### 5.1 Перевірка метрик в Grafana
```bash
# Доступ до Grafana
kubectl port-forward svc/grafana 3000:80 -n monitoring

# Відкрийте браузер: http://localhost:3000
# Додайте Prometheus як datasource: http://prometheus-server:9090
```

#### 5.2 Перевірка Prometheus
```bash
# Port forwarding для Prometheus
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring

# Відкрийте браузер: http://localhost:9090
```

### 6. Розгортання Django додатку

#### 6.1 Підготовка Helm chart
```bash
# Перевірка Helm chart
helm lint charts/django-app/

# Тестування розгортання
helm install django-app-test charts/django-app/ --dry-run
```

#### 6.2 Розгортання через Argo CD
```bash
# Створення Application в Argo CD
kubectl apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: django-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-repo/charts.git
    targetRevision: HEAD
    path: charts/django-app
  destination:
    server: https://kubernetes.default.svc
    namespace: django-app
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
EOF
```

### 7. Перевірка роботи додатку

#### 7.1 Перевірка статусу додатку
```bash
# Перевірка namespace
kubectl get all -n django-app

# Перевірка логів
kubectl logs -n django-app deployment/django-app

# Port forwarding для доступу до додатку
kubectl port-forward svc/django-app 8000:8000 -n django-app

# Відкрийте браузер: http://localhost:8000
```

#### 7.2 Перевірка бази даних
```bash
# Перевірка RDS
terraform output rds_instance_endpoint

# Підключення до бази даних
psql -h <endpoint> -U admin -d postgres
```

## 🔧 Корисні команди

### Terraform команди
```bash
# Перевірка плану
terraform plan

# Застосування змін
terraform apply

# Видалення ресурсів
terraform destroy

# Перегляд outputs
terraform output
```

### Kubernetes команди
```bash
# Перевірка всіх ресурсів
kubectl get all --all-namespaces

# Перевірка подів
kubectl get pods -n jenkins
kubectl get pods -n argocd
kubectl get pods -n monitoring
kubectl get pods -n django-app

# Перевірка сервісів
kubectl get svc --all-namespaces

# Перевірка логів
kubectl logs -n jenkins deployment/jenkins
kubectl logs -n argocd deployment/argocd-server
kubectl logs -n django-app deployment/django-app
```

### Helm команди
```bash
# Перевірка Helm releases
helm list --all-namespaces

# Оновлення Helm chart
helm upgrade django-app charts/django-app/
```

## 🛡️ Безпека

### Перевірка безпеки
```bash
# Перевірка security groups
aws ec2 describe-security-groups --filters "Name=group-name,Values=*final-project*"

# Перевірка IAM roles
aws iam list-roles --query 'Roles[?contains(RoleName, `final-project`)]'

# Перевірка шифрування
aws rds describe-db-instances --query 'DBInstances[?StorageEncrypted==`true`]'
```

## 🧹 Очищення

### Видалення ресурсів
```bash
# Видалення всіх ресурсів
terraform destroy

# Видалення S3 bucket (якщо потрібно)
aws s3 rb s3://devops-terraform-state-bucket --force

# Видалення DynamoDB table (якщо потрібно)
aws dynamodb delete-table --table-name terraform-state-lock
```

## 📊 Моніторинг

### Grafana Dashboards
1. **Kubernetes Cluster Metrics**
   - CPU та Memory використання
   - Network traffic
   - Pod status

2. **Application Metrics**
   - Response time
   - Error rate
   - Throughput

3. **Infrastructure Metrics**
   - AWS RDS metrics
   - EKS cluster metrics
   - ECR repository metrics

### Prometheus Targets
- Kubernetes API server
- Node exporters
- Application metrics
- Custom metrics

## 🔍 Troubleshooting

### Поширені проблеми

#### 1. Jenkins не доступний
```bash
# Перевірка статусу
kubectl get pods -n jenkins
kubectl describe pod -n jenkins <pod-name>

# Перевірка логів
kubectl logs -n jenkins deployment/jenkins
```

#### 2. Argo CD sync failed
```bash
# Перевірка Application
kubectl get application -n argocd
kubectl describe application django-app -n argocd

# Manual sync
argocd app sync django-app
```

#### 3. Django app не запускається
```bash
# Перевірка статусу
kubectl get pods -n django-app
kubectl describe pod -n django-app <pod-name>

# Перевірка логів
kubectl logs -n django-app deployment/django-app
```

#### 4. Database connection issues
```bash
# Перевірка RDS
terraform output rds_instance_endpoint

# Тестування підключення
psql -h <endpoint> -U admin -d postgres
```

## 📞 Підтримка

Якщо у вас є питання або проблеми:

1. Перевірте логи всіх компонентів
2. Перевірте статус ресурсів в AWS Console
3. Перевірте статус подів в Kubernetes
4. Зверніться до документації компонентів

---

**Примітка**: Цей проект призначений для навчальних цілей. Для production використання додайте додаткові заходи безпеки та моніторингу. 