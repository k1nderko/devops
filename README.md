# CI/CD Pipeline with Jenkins, Helm, Terraform, and Argo CD

Цей проект реалізує повний CI/CD процес з використанням Jenkins, Helm, Terraform та Argo CD для автоматичного розгортання Django-застосунку в Kubernetes кластері AWS.

## 🏗️ Архітектура

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitHub Repo   │    │   Jenkins       │    │   Argo CD       │
│   (Source Code) │───▶│   (CI/CD)       │───▶│   (GitOps)      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                ▼                       ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   Amazon ECR    │    │   Kubernetes    │
                       │   (Docker Images)│    │   Cluster (EKS) │
                       └─────────────────┘    └─────────────────┘
```

## 📁 Структура проекту

```
Project/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальні виводи ресурсів
├── variables.tf             # Загальні змінні
│
├── modules/                 # Каталог з усіма модулями
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf       # Виводи VPC
│   │
│   ├── ecr/                 # Модуль для ECR
│   │   ├── ecr.tf           # Створення ECR репозиторію
│   │   ├── variables.tf     # Змінні для ECR
│   │   └── outputs.tf       # Виведення URL репозиторію
│   │
│   ├── eks/                 # Модуль для Kubernetes кластера
│   │   ├── eks.tf           # Створення кластера
│   │   ├── aws_ebs_csi_driver.tf # Встановлення плагіну CSI drive
│   │   ├── variables.tf     # Змінні для EKS
│   │   └── outputs.tf       # Виведення інформації про кластер
│   │
│   ├── jenkins/             # Модуль для Helm-установки Jenkins
│   │   ├── jenkins.tf       # Helm release для Jenkins
│   │   ├── variables.tf     # Змінні (ресурси, креденшели, values)
│   │   ├── providers.tf     # Оголошення провайдерів
│   │   ├── values.yaml      # Конфігурація Jenkins
│   │   └── outputs.tf       # Виводи (URL, пароль адміністратора)
│   │
│   └── argo_cd/             # Модуль для Helm-установки Argo CD
│       ├── argo_cd.tf       # Helm release для Argo CD
│       ├── variables.tf     # Змінні (версія чарта, namespace, repo URL тощо)
│       ├── providers.tf     # Kubernetes+Helm провайдери
│       ├── values.yaml      # Кастомна конфігурація Argo CD
│       └── outputs.tf       # Виводи (hostname, initial admin password)
│
└── charts/
    └── django-app/
        ├── templates/
        │   ├── deployment.yaml
        │   ├── service.yaml
        │   ├── configmap.yaml
        │   └── hpa.yaml
        ├── Chart.yaml
        └── values.yaml
```

## 🚀 Компоненти

### 1. **Terraform Infrastructure**
- **S3 Backend**: Зберігання Terraform state та блокування через DynamoDB
- **VPC**: Віртуальна приватна хмара з публічними та приватними підмережами
- **ECR**: Репозиторій для Docker образів
- **EKS**: Kubernetes кластер з managed node groups
- **Jenkins**: CI/CD сервер через Helm
- **Argo CD**: GitOps інструмент для автоматичного розгортання

### 2. **Jenkins Pipeline**
- Автоматичне збирання Docker образів
- Публікація в Amazon ECR
- Оновлення Helm chart тегів
- Push змін в Git репозиторій

### 3. **Argo CD Application**
- Моніторинг змін в Helm chart репозиторії
- Автоматична синхронізація в Kubernetes кластері
- GitOps підхід до розгортання

### 4. **Django Application**
- Helm chart для розгортання Django застосунку
- Автоматичне масштабування (HPA)
- ConfigMap для налаштувань

## 🛠️ Вимоги

### Програмне забезпечення
- Terraform >= 1.0
- kubectl
- helm
- aws-cli
- git

### AWS Ресурси
- AWS Account з відповідними правами
- IAM користувач з правами для створення ресурсів
- Domain name (опціонально для Ingress)

## 📋 Встановлення та налаштування

### 1. Підготовка AWS

```bash
# Налаштування AWS CLI
aws configure

# Створення S3 bucket для Terraform state (якщо не існує)
aws s3 mb s3://devops-terraform-state-bucket
```

### 2. Ініціалізація Terraform

```bash
# Ініціалізація Terraform
terraform init

# Перевірка плану
terraform plan

# Застосування змін
terraform apply
```

### 3. Налаштування Jenkins

```bash
# Отримання Jenkins URL та паролю
terraform output jenkins_url
terraform output jenkins_admin_password

# Налаштування Jenkins
# 1. Відкрийте Jenkins URL у браузері
# 2. Введіть admin password
# 3. Встановіть рекомендовані плагіни
# 4. Створіть admin користувача
```

### 4. Налаштування Argo CD

```bash
# Отримання Argo CD URL та паролю
terraform output argocd_url
terraform output argocd_admin_password

# Налаштування Argo CD
# 1. Відкрийте Argo CD URL у браузері
# 2. Введіть admin password
# 3. Додайте Git репозиторій з Helm charts
```

## 🔄 CI/CD Pipeline

### Jenkins Pipeline Stages

1. **Checkout**: Клонування коду з Git
2. **Test**: Запуск тестів Django
3. **Build Docker Image**: Збірка та публікація в ECR
4. **Update Helm Chart**: Оновлення тегу в values.yaml
5. **Deploy to Argo CD**: Синхронізація через Argo CD
6. **Health Check**: Перевірка статусу розгортання

### Argo CD Application

- **Source**: Git репозиторій з Helm charts
- **Destination**: Kubernetes кластер
- **Sync Policy**: Автоматична синхронізація
- **Health Checks**: Перевірка статусу застосунку

## 🔧 Конфігурація

### Змінні Terraform

Основні змінні в `variables.tf`:

```hcl
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}
```

### Helm Values

- **Jenkins**: `modules/jenkins/values.yaml`
- **Argo CD**: `modules/argo_cd/values.yaml`
- **Django App**: `charts/django-app/values.yaml`

## 🔍 Моніторинг та логування

### Kubernetes Resources

```bash
# Перевірка статусу подів
kubectl get pods -n jenkins
kubectl get pods -n argocd
kubectl get pods -n django-app

# Перевірка сервісів
kubectl get svc -n jenkins
kubectl get svc -n argocd
kubectl get svc -n django-app
```

### Logs

```bash
# Jenkins logs
kubectl logs -n jenkins deployment/jenkins

# Argo CD logs
kubectl logs -n argocd deployment/argocd-server

# Django app logs
kubectl logs -n django-app deployment/django-app
```

## 🛡️ Безпека

### IAM Roles та Policies

- **Terraform**: Обмежені права для створення ресурсів
- **Jenkins**: ServiceAccount з правами для Kubernetes
- **Argo CD**: ServiceAccount з правами для GitOps
- **EKS**: IRSA (IAM Roles for Service Accounts)

### Network Security

- **VPC**: Публічні та приватні підмережі
- **Security Groups**: Обмеження доступу
- **NAT Gateway**: Вихідний трафік з приватних підмереж

## 🧹 Очищення

```bash
# Видалення всіх ресурсів
terraform destroy

# Видалення S3 bucket (якщо потрібно)
aws s3 rb s3://devops-terraform-state-bucket --force
```

## 📚 Корисні команди

```bash
# Terraform
terraform init
terraform plan
terraform apply
terraform destroy
terraform output

# Kubernetes
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n django-app

# Helm
helm list -n jenkins
helm list -n argocd

# AWS
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
```

## 🤝 Внесок

1. Fork репозиторію
2. Створіть feature branch (`git checkout -b feature/amazing-feature`)
3. Commit зміни (`git commit -m 'Add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Відкрийте Pull Request

## 📄 Ліцензія

Цей проект розповсюджується під ліцензією MIT. Дивіться файл `LICENSE` для деталей.

## 📞 Підтримка

Якщо у вас є питання або проблеми:

1. Перевірте документацію
2. Подивіться на існуючі issues
3. Створіть новий issue з детальним описом проблеми

---

**Примітка**: Цей проект призначений для навчальних цілей. Для production використання додайте додаткові заходи безпеки та моніторингу. 