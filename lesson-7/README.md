# Kubernetes EKS Infrastructure - Lesson 7

Цей проект демонструє створення Kubernetes кластера EKS з розгортанням Django застосунку через Helm.

## Структура проекту

```
lesson-7/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальне виведення ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   ├── vpc/                 # Модуль для VPC
│   ├── ecr/                 # Модуль для ECR
│   └── eks/                 # Модуль для EKS кластера
│
├── charts/                  # Helm charts
│   └── django-app/          # Django застосунок
│       ├── templates/        # Kubernetes manifests
│       ├── Chart.yaml        # Helm chart metadata
│       └── values.yaml       # Конфігурація застосунку
│
├── scripts/                 # Скрипти для розгортання
│   ├── push-to-ecr.sh       # Завантаження образу в ECR
│   ├── configure-kubectl.sh  # Налаштування kubectl
│   └── deploy-helm.sh       # Розгортання Helm chart
│
└── README.md                # Документація проекту
```

## Компоненти інфраструктури

### 1. S3 Backend Module
- **S3 Bucket**: Зберігання Terraform state файлів
- **DynamoDB Table**: Блокування стану для запобігання конфліктів

### 2. VPC Module
- **VPC**: Приватна мережа з CIDR 10.0.0.0/16
- **Public Subnets**: 3 публічні підмережі в різних AZ
- **Private Subnets**: 3 приватні підмережі в різних AZ
- **Internet Gateway**: Для публічних підмереж
- **NAT Gateway**: Для приватних підмереж

### 3. ECR Module
- **ECR Repository**: Для зберігання Docker образів Django
- **Image Scanning**: Автоматичне сканування на вразливості
- **Lifecycle Policy**: Автоматичне очищення старих образів

### 4. EKS Module
- **EKS Cluster**: Kubernetes кластер версії 1.28
- **Node Group**: Автомасштабована група вузлів t3.medium
- **IAM Roles**: Ролі для кластера та вузлів
- **Security Groups**: Налаштування безпеки

### 5. Helm Chart (Django App)
- **Deployment**: Розгортання Django застосунку
- **Service**: LoadBalancer для зовнішнього доступу
- **HPA**: Автомасштабування від 2 до 6 подів
- **ConfigMap**: Змінні середовища з теми 4

## Передумови

1. **Terraform**: Версія 1.0 або новіша
2. **AWS CLI**: Налаштований з відповідними credentials
3. **Docker**: Для збірки та завантаження образів
4. **kubectl**: Для роботи з Kubernetes
5. **Helm**: Для розгортання застосунків

## Кроки розгортання

### 1. Створення інфраструктури

```bash
# Ініціалізація Terraform
cd lesson-7
terraform init

# Перегляд плану
terraform plan

# Застосування інфраструктури
terraform apply
```

### 2. Налаштування kubectl

```bash
# Налаштування доступу до EKS кластера
chmod +x scripts/configure-kubectl.sh
./scripts/configure-kubectl.sh
```

### 3. Завантаження Docker образу в ECR

```bash
# Завантаження Django образу в ECR
chmod +x scripts/push-to-ecr.sh
./scripts/push-to-ecr.sh
```

### 4. Розгортання Django застосунку

```bash
# Розгортання через Helm
chmod +x scripts/deploy-helm.sh
./scripts/deploy-helm.sh
```

## Команди для роботи

### Terraform
```bash
# Ініціалізація
terraform init

# Перегляд плану
terraform plan

# Застосування змін
terraform apply

# Видалення ресурсів
terraform destroy
```

### Kubernetes
```bash
# Перегляд вузлів
kubectl get nodes

# Перегляд подів
kubectl get pods

# Перегляд сервісів
kubectl get services

# Перегляд ConfigMap
kubectl get configmaps

# Перегляд HPA
kubectl get hpa
```

### Helm
```bash
# Встановлення застосунку
helm install django-app charts/django-app

# Оновлення застосунку
helm upgrade django-app charts/django-app

# Видалення застосунку
helm uninstall django-app

# Перегляд статусу
helm status django-app
```

## Особливості проекту

### EKS Кластер
- **Версія Kubernetes**: 1.28
- **Тип вузлів**: t3.medium
- **Мінімальна кількість**: 1
- **Максимальна кількість**: 4
- **Бажана кількість**: 2

### Django Застосунок
- **Образ**: З ECR репозиторію
- **Порти**: 8000 (контейнер) → 80 (сервіс)
- **Тип сервісу**: LoadBalancer
- **Health Checks**: Liveness та Readiness проби

### Автомасштабування
- **HPA**: Включено
- **Мінімум подів**: 2
- **Максимум подів**: 6
- **Цільове навантаження CPU**: 70%
- **Цільове навантаження Memory**: 70%

### ConfigMap
- **Змінні середовища**: Перенесені з теми 4
- **Підключення**: Через envFrom
- **Безпека**: Через ConfigMap замість Secret

## Безпека

- Всі ресурси мають відповідні теги
- EKS кластер в приватних підмережах
- ECR репозиторій з політиками безпеки
- ConfigMap для змінних середовища
- ServiceAccount для застосунку

## Вартість

**Увага**: Цей проект створює платні ресурси AWS:
- EKS кластер: ~$0.10/годину
- EKS вузлі t3.medium: ~$0.0416/годину
- NAT Gateway: ~$0.045/годину
- EIP: ~$0.005/годину
- ECR: плата за зберігання та передачу даних

Рекомендується видалити ресурси після тестування:
```bash
helm uninstall django-app
terraform destroy
```

## Troubleshooting

### Помилки EKS
```bash
# Перевірити статус кластера
aws eks describe-cluster --name lesson-7-cluster --region us-west-2

# Оновити kubeconfig
aws eks update-kubeconfig --region us-west-2 --name lesson-7-cluster
```

### Помилки ECR
```bash
# Перевірити репозиторій
aws ecr describe-repositories --region us-west-2

# Отримати токен для входу
aws ecr get-login-password --region us-west-2
```

### Помилки Helm
```bash
# Перевірити статус застосунку
helm status django-app

# Переглянути логи
kubectl logs -l app.kubernetes.io/name=django-app
```

## Ліцензія

MIT License 