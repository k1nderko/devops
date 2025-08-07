# Final Project - AWS Infrastructure with CI/CD

Цей проект реалізує повну інфраструктуру AWS з використанням Terraform, включаючи CI/CD процес з Jenkins та Argo CD, моніторинг з Prometheus та Grafana, та Django додаток.

## Архітектура

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   AWS VPC       │    │   EKS Cluster   │    │   RDS/Aurora    │
│                 │    │                 │    │                 │
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │ Public      │ │    │ │ Jenkins     │ │    │ │ PostgreSQL  │ │
│ │ Subnets     │ │    │ │ Argo CD     │ │    │ │ MySQL       │ │
│ └─────────────┘ │    │ │ Prometheus  │ │    │ │ MariaDB     │ │
│ ┌─────────────┐ │    │ │ Grafana     │ │    │ └─────────────┘ │
│ │ Private     │ │    │ │ Django App  │ │    └─────────────────┘
│ │ Subnets     │ │    │ └─────────────┘ │
│ └─────────────┘ │    └─────────────────┘
└─────────────────┘
```

## Компоненти

### AWS Infrastructure
- **VPC** з публічними та приватними підмережами
- **EKS Cluster** для оркестрації контейнерів
- **ECR Repository** для зберігання Docker образів
- **RDS/Aurora** для бази даних
- **S3 Backend** для Terraform state
- **DynamoDB** для state locking

### CI/CD Pipeline
- **Jenkins** для автоматизації збірки та тестування
- **Argo CD** для GitOps deployment
- **Docker** для контейнеризації
- **Helm** для управління Kubernetes додатками

### Monitoring
- **Prometheus** для збору метрик
- **Grafana** для візуалізації та дашбордів

### Application
- **Django** веб-додаток
- **PostgreSQL** база даних
- **Nginx** reverse proxy (опціонально)

## Структура проекту

```
Project/
│
├── main.tf         # Головний файл для підключення модулів
├── backend.tf      # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── variables.tf    # Глобальні змінні
├── outputs.tf      # Загальні виводи ресурсів
│
├── modules/        # Каталог з усіма модулями
│  ├── s3-backend/     # Модуль для S3 та DynamoDB
│  ├── vpc/            # Модуль для VPC
│  ├── ecr/            # Модуль для ECR
│  ├── eks/            # Модуль для Kubernetes кластера
│  ├── rds/            # Модуль для RDS
│  ├── jenkins/        # Модуль для Helm-установки Jenkins
│  ├── argo_cd/        # Модуль для Helm-установки Argo CD
│  └── monitoring/     # Модуль для Prometheus та Grafana
│
├── charts/
│  └── django-app/     # Helm-чарт для Django додатку
│
└── Django/            # Django додаток
    ├── app/           # Django код
    ├── Dockerfile     # Docker образ
    ├── Jenkinsfile    # CI/CD pipeline
    └── docker-compose.yaml
```

## Встановлення та розгортання

### 1. Підготовка середовища

```bash
# Клонування репозиторію
git clone <repository-url>
cd Project

# Ініціалізація Terraform
terraform init

# Перевірка плану
terraform plan
```

### 2. Налаштування змінних

Створіть файл `terraform.tfvars`:

```hcl
# Global variables
aws_region = "us-east-1"
environment = "dev"

# S3 Backend
s3_bucket_name = "your-terraform-state-bucket"
dynamodb_table_name = "your-terraform-state-lock"

# VPC
vpc_cidr = "10.0.0.0/16"

# ECR
ecr_repository_name = "django-app"

# EKS
eks_cluster_name = "final-project-cluster"

# RDS
use_aurora = false
db_engine = "postgres"
db_engine_version = "14.9"
db_instance_class = "db.t3.micro"
db_username = "admin"
db_password = "your-secure-password"

# Monitoring
prometheus_enabled = true
grafana_enabled = true
grafana_admin_password = "admin"
```

### 3. Розгортання інфраструктури

```bash
# Застосування конфігурації
terraform apply

# Перевірка стану ресурсів
terraform show
```

### 4. Перевірка доступності сервісів

```bash
# Налаштування kubectl
aws eks update-kubeconfig --region us-east-1 --name final-project-cluster

# Перевірка подів
kubectl get pods -n jenkins
kubectl get pods -n argocd
kubectl get pods -n monitoring

# Port forwarding для доступу
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
kubectl port-forward svc/argocd-server 8081:443 -n argocd
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

## Використання

### Jenkins
- URL: http://localhost:8080
- Username: admin
- Password: admin

### Argo CD
- URL: https://localhost:8081
- Username: admin
- Password: admin

### Grafana
- URL: http://localhost:3000
- Username: admin
- Password: admin

## CI/CD Pipeline

### Jenkins Pipeline
1. **Checkout** - отримання коду з Git
2. **Test** - запуск тестів Django
3. **Build** - збірка Docker образу
4. **Push** - завантаження образу в ECR
5. **Update Helm** - оновлення Helm chart
6. **Deploy** - розгортання через Argo CD

### Argo CD Application
- **Repository**: Git репозиторій з Helm charts
- **Path**: charts/django-app
- **Target**: Kubernetes cluster
- **Sync Policy**: Automatic

## Моніторинг

### Prometheus
- Збір метрик з Kubernetes кластера
- Метрики додатків та сервісів
- Alerting rules

### Grafana Dashboards
- Kubernetes Cluster Overview
- Django Application Metrics
- Database Performance
- Infrastructure Health

## Безпека

### IAM Roles
- Jenkins Service Account
- Argo CD Service Account
- EKS Node Groups
- RDS Access

### Network Security
- VPC з приватними підмережами
- Security Groups
- NAT Gateway для приватних ресурсів

### Secrets Management
- Kubernetes Secrets
- AWS Secrets Manager (опціонально)
- Argo CD Vault Plugin (опціонально)

## Масштабування

### Horizontal Pod Autoscaler
- Автоматичне масштабування на основі CPU/Memory
- Мінімум: 1 pod
- Максимум: 5 pods

### Aurora Cluster
- Автоматичне масштабування читачів
- Multi-AZ deployment
- Backup та restore

## Очищення

```bash
# Видалення інфраструктури
terraform destroy

# Підтвердження видалення
yes
```

## Troubleshooting

### Проблеми з EKS
```bash
# Перевірка статусу кластера
aws eks describe-cluster --name final-project-cluster --region us-east-1

# Перевірка node groups
aws eks describe-nodegroup --cluster-name final-project-cluster --nodegroup-name general --region us-east-1
```

### Проблеми з Jenkins
```bash
# Перевірка логів
kubectl logs -n jenkins deployment/jenkins

# Перезапуск поду
kubectl rollout restart deployment/jenkins -n jenkins
```

### Проблеми з Argo CD
```bash
# Перевірка статусу синхронізації
kubectl get applications -n argocd

# Примусова синхронізація
kubectl patch application django-app -n argocd --type='merge' -p='{"spec":{"syncPolicy":{"automated":{"prune":true,"selfHeal":true}}}}'
```

## Розробка

### Локальна розробка
```bash
# Запуск Django локально
cd Django
docker-compose up -d

# Доступ до додатку
http://localhost:8000
```

### Тестування
```bash
# Unit тести
python manage.py test

# Integration тести
docker-compose -f docker-compose.test.yml up --abort-on-container-exit
```

## Ліцензія

MIT License

## Автори

- Ваше ім'я
- Email: your.email@example.com 