# Універсальний RDS Модуль для Terraform

Цей модуль реалізує універсальне рішення для створення баз даних AWS RDS з підтримкою як звичайних RDS instances, так і Aurora кластерів.

## 🏗️ Функціональність

### Основні можливості:
- **Автоматичне створення** DB Subnet Group
- **Автоматичне створення** Security Group з налаштованими правилами
- **Автоматичне створення** Parameter Group з базовими параметрами
- **Підтримка Aurora Cluster** та звичайних RDS instances
- **Мінімальні зміни змінних** для різних типів БД
- **Багаторазове використання** в різних проектах

### Типи баз даних:
- **use_aurora = true** → Aurora Cluster + writer instance
- **use_aurora = false** → Звичайна RDS instance

## 📁 Структура модуля

```
modules/rds/
├── variables.tf     # Всі змінні модуля
├── shared.tf        # Спільні ресурси (subnet group, security group, parameter group)
├── rds.tf          # Звичайна RDS instance
├── aurora.tf       # Aurora cluster та instances
└── outputs.tf      # Всі виводи модуля
```

## 🚀 Приклад використання

### 1. Звичайна RDS Instance (PostgreSQL)

```hcl
module "rds" {
  source = "./modules/rds"
  
  # Основна конфігурація
  identifier = "my-postgres-db"
  use_aurora = false
  
  # Engine конфігурація
  engine = "postgres"
  engine_version = "14.9"
  instance_class = "db.t3.micro"
  
  # Мережева конфігурація
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  vpc_cidr_blocks = ["10.0.0.0/16"]
  
  # Креденшели
  username = "admin"
  password = "your-secure-password"
  
  # Теги
  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

### 2. Aurora Cluster (PostgreSQL)

```hcl
module "rds" {
  source = "./modules/rds"
  
  # Основна конфігурація
  identifier = "my-aurora-cluster"
  use_aurora = true
  
  # Engine конфігурація
  engine = "aurora-postgresql"
  engine_version = "14.9"
  
  # Aurora специфічні налаштування
  aurora_cluster_instances = 2
  aurora_instance_class = "db.r5.large"
  
  # Мережева конфігурація
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  vpc_cidr_blocks = ["10.0.0.0/16"]
  
  # Креденшели
  username = "admin"
  password = "your-secure-password"
  
  # Теги
  tags = {
    Environment = "prod"
    Project     = "my-project"
  }
}
```

### 3. MySQL Aurora Cluster

```hcl
module "rds" {
  source = "./modules/rds"
  
  identifier = "my-mysql-aurora"
  use_aurora = true
  
  # MySQL конфігурація
  engine = "aurora-mysql"
  engine_version = "8.0"
  aurora_instance_class = "db.r5.large"
  
  # Мережева конфігурація
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  vpc_cidr_blocks = ["10.0.0.0/16"]
  
  # Креденшели
  username = "admin"
  password = "your-secure-password"
  
  tags = {
    Environment = "prod"
    Project     = "my-project"
  }
}
```

## 🔧 Змінні модуля

### Основні змінні

| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `use_aurora` | bool | `false` | Створити Aurora Cluster (true) або звичайну RDS instance (false) |
| `identifier` | string | - | Назва RDS instance або Aurora cluster |
| `engine` | string | `"postgres"` | Тип бази даних (postgres, mysql, mariadb, aurora-postgresql, aurora-mysql) |
| `engine_version` | string | `"14.9"` | Версія двигуна бази даних |
| `instance_class` | string | `"db.t3.micro"` | Тип інстансу для RDS |
| `allocated_storage` | number | `20` | Розмір диску в GB (тільки для RDS) |
| `storage_type` | string | `"gp2"` | Тип диску (standard, gp2, io1) |
| `storage_encrypted` | bool | `true` | Шифрування диску |
| `multi_az` | bool | `false` | Multi-AZ розгортання |

### Мережеві змінні

| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `vpc_id` | string | - | ID VPC |
| `subnet_ids` | list(string) | - | Список ID підмереж |
| `vpc_cidr_blocks` | list(string) | `[]` | CIDR блоки для доступу |
| `allowed_security_group_ids` | list(string) | `[]` | Security Group IDs для доступу |
| `port` | number | `5432` | Порт бази даних |

### Креденшели

| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `username` | string | `"admin"` | Користувач бази даних |
| `password` | string | - | Пароль бази даних (sensitive) |

### Aurora специфічні змінні

| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `aurora_cluster_instances` | number | `1` | Кількість інстансів в Aurora кластері |
| `aurora_instance_class` | string | `"db.r5.large"` | Тип інстансу для Aurora |
| `aurora_auto_pause` | bool | `false` | Автоматична пауза для Aurora |
| `aurora_auto_pause_seconds` | number | `300` | Час до автоматичної паузи |

### Parameter Group змінні

| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `max_connections` | number | `100` | Максимальна кількість з'єднань |
| `log_statement` | string | `"none"` | Логування запитів (none, ddl, mod, all) |
| `work_mem` | number | `4` | Робоча пам'ять в MB |

### Backup та Maintenance

| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `backup_retention_period` | number | `7` | Дні зберігання backup |
| `backup_window` | string | `"03:00-04:00"` | Вікно для backup |
| `maintenance_window` | string | `"sun:04:00-sun:05:00"` | Вікно для maintenance |
| `deletion_protection` | bool | `false` | Захист від видалення |
| `skip_final_snapshot` | bool | `false` | Пропустити фінальний snapshot |
| `final_snapshot_identifier` | string | `null` | Назва фінального snapshot |

## 📊 Виводи модуля

### Спільні виводи

| Вивід | Опис |
|-------|------|
| `db_subnet_group_id` | ID DB subnet group |
| `security_group_id` | ID security group |
| `parameter_group_id` | ID parameter group |
| `database_type` | Тип бази даних (Aurora або RDS) |
| `engine` | Використаний двигун |
| `engine_version` | Версія двигуна |

### RDS Instance виводи (use_aurora = false)

| Вивід | Опис |
|-------|------|
| `rds_instance_id` | ID RDS instance |
| `rds_instance_endpoint` | Endpoint для підключення |
| `rds_instance_address` | IP адреса instance |
| `rds_instance_port` | Порт instance |

### Aurora Cluster виводи (use_aurora = true)

| Вивід | Опис |
|-------|------|
| `aurora_cluster_id` | ID Aurora cluster |
| `aurora_cluster_endpoint` | Writer endpoint |
| `aurora_cluster_reader_endpoint` | Reader endpoint |
| `aurora_instance_ids` | Список ID інстансів |
| `aurora_instance_endpoints` | Список endpoint інстансів |

## 🔄 Зміна типу бази даних

### Зміна з RDS на Aurora

```hcl
# Було: Звичайна RDS instance
module "rds" {
  source = "./modules/rds"
  
  identifier = "my-db"
  use_aurora = false
  engine = "postgres"
  engine_version = "14.9"
  instance_class = "db.t3.micro"
  
  # ... інші змінні
}

# Стало: Aurora Cluster
module "rds" {
  source = "./modules/rds"
  
  identifier = "my-db"
  use_aurora = true
  engine = "aurora-postgresql"
  engine_version = "14.9"
  aurora_instance_class = "db.r5.large"
  aurora_cluster_instances = 2
  
  # ... інші змінні (залишаються такими ж)
}
```

### Зміна двигуна бази даних

```hcl
# PostgreSQL
engine = "postgres"
engine_version = "14.9"

# MySQL
engine = "mysql"
engine_version = "8.0"

# Aurora PostgreSQL
engine = "aurora-postgresql"
engine_version = "14.9"

# Aurora MySQL
engine = "aurora-mysql"
engine_version = "8.0"
```

### Зміна класу інстансу

```hcl
# Для RDS instances
instance_class = "db.t3.micro"    # Dev/Test
instance_class = "db.t3.small"    # Small production
instance_class = "db.r5.large"    # Large production

# Для Aurora instances
aurora_instance_class = "db.r5.large"    # Standard
aurora_instance_class = "db.r5.xlarge"   # Large
aurora_instance_class = "db.r6g.large"   # Graviton2
```

## 🛡️ Безпека

### Security Group
- Автоматично створюється security group
- Дозволяє доступ тільки з VPC CIDR блоків
- Підтримує додавання додаткових security groups
- Вихідний трафік дозволений

### Шифрування
- За замовчуванням увімкнено шифрування диску
- Використовується AWS KMS для шифрування

### Parameter Group
- Автоматично створюється parameter group
- Налаштовує базові параметри безпеки
- Підтримує кастомні параметри

## 📈 Моніторинг

### Performance Insights
- Автоматично увімкнено для всіх instances
- 7 днів зберігання даних

### CloudWatch Monitoring
- 60-секундний інтервал моніторингу
- Автоматичне створення метрик

## 💰 Оптимізація витрат

### Aurora Auto Pause
```hcl
aurora_auto_pause = true
aurora_auto_pause_seconds = 300  # 5 хвилин
```

### Instance Classes
```hcl
# Dev/Test
instance_class = "db.t3.micro"
aurora_instance_class = "db.r5.large"

# Production
instance_class = "db.r5.large"
aurora_instance_class = "db.r5.xlarge"
```

## 🧹 Очищення

```bash
# Видалення всіх ресурсів
terraform destroy

# Видалення тільки RDS модуля
terraform destroy -target=module.rds
```

## 📚 Корисні команди

```bash
# Перевірка статусу RDS
aws rds describe-db-instances --db-instance-identifier my-db

# Перевірка Aurora cluster
aws rds describe-db-clusters --db-cluster-identifier my-aurora-cluster

# Підключення до PostgreSQL
psql -h <endpoint> -U admin -d postgres

# Підключення до MySQL
mysql -h <endpoint> -u admin -p
```

## 🤝 Внесок

1. Fork репозиторію
2. Створіть feature branch (`git checkout -b feature/amazing-feature`)
3. Commit зміни (`git commit -m 'Add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Відкрийте Pull Request

---

**Примітка**: Цей модуль призначений для навчальних цілей. Для production використання додайте додаткові заходи безпеки та моніторингу. 