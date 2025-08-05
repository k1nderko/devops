# Terraform AWS Infrastructure - Lesson 5

Цей проект демонструє створення AWS інфраструктури за допомогою Terraform з використанням модульної архітектури.

## Структура проекту

```
lesson-5/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальне виведення ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   │
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
│   │   └── outputs.tf       # Виведення інформації про VPC
│   │
│   └── ecr/                 # Модуль для ECR
│       ├── ecr.tf           # Створення ECR репозиторію
│       ├── variables.tf     # Змінні для ECR
│       └── outputs.tf       # Виведення URL репозиторію ECR
│
└── README.md                # Документація проекту
```

## Компоненти інфраструктури

### 1. S3 Backend Module
- **S3 Bucket**: Зберігання Terraform state файлів
- **DynamoDB Table**: Блокування стану для запобігання конфліктів
- **Безпека**: Шифрування, блокування публічного доступу, SSL-only

### 2. VPC Module
- **VPC**: Приватна мережа з CIDR 10.0.0.0/16
- **Public Subnets**: 3 публічні підмережі в різних AZ
- **Private Subnets**: 3 приватні підмережі в різних AZ
- **Internet Gateway**: Для публічних підмереж
- **NAT Gateway**: Для приватних підмереж
- **Route Tables**: Налаштування маршрутизації

### 3. ECR Module
- **ECR Repository**: Для зберігання Docker образів
- **Image Scanning**: Автоматичне сканування на вразливості
- **Lifecycle Policy**: Автоматичне очищення старих образів
- **Repository Policy**: Налаштування доступу

## Передумови

1. **Terraform**: Версія 1.0 або новіша
2. **AWS CLI**: Налаштований з відповідними credentials
3. **AWS Account**: З необхідними permissions

## Налаштування

### 1. Налаштування AWS Credentials
```bash
aws configure
```

### 2. Ініціалізація Terraform
```bash
cd lesson-5
terraform init
```

### 3. Перегляд плану
```bash
terraform plan
```

### 4. Застосування інфраструктури
```bash
terraform apply
```

### 5. Видалення інфраструктури
```bash
terraform destroy
```

## Команди для роботи

```bash
# Ініціалізація
terraform init

# Перегляд плану
terraform plan

# Застосування змін
terraform apply

# Перегляд стану
terraform show

# Перегляд outputs
terraform output

# Видалення ресурсів
terraform destroy

# Перегляд логів
terraform console
```

## Модулі

### S3 Backend Module
**Призначення**: Створення безпечного бекенду для Terraform state
**Ресурси**:
- S3 Bucket з версіонуванням та шифруванням
- DynamoDB таблиця для блокування стану
- Політики безпеки та доступу

### VPC Module
**Призначення**: Створення повноцінної мережевої інфраструктури
**Ресурси**:
- VPC з DNS підтримкою
- 3 публічні та 3 приватні підмережі
- Internet Gateway та NAT Gateway
- Route Tables для маршрутизації

### ECR Module
**Призначення**: Створення репозиторію для Docker образів
**Ресурси**:
- ECR Repository з автоматичним скануванням
- Lifecycle Policy для управління образами
- Repository Policy для контролю доступу

## Безпека

- Всі ресурси мають відповідні теги
- S3 bucket заблокований для публічного доступу
- ECR repository має політики безпеки
- VPC налаштована з приватними підмережами

## Вартість

**Увага**: Цей проект створює платні ресурси AWS:
- NAT Gateway: ~$0.045/годину
- EIP: ~$0.005/годину
- ECR: плата за зберігання та передачу даних

Рекомендується видалити ресурси після тестування:
```bash
terraform destroy
```

## Troubleshooting

### Помилки ініціалізації
```bash
# Очистити кеш Terraform
rm -rf .terraform
terraform init
```

### Помилки AWS credentials
```bash
# Перевірити налаштування
aws sts get-caller-identity
```

### Помилки S3 backend
```bash
# Перевірити існування bucket
aws s3 ls s3://k1nderko-terraform-backend
```

## Ліцензія

MIT License 