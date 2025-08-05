# Django Docker Project

Цей проект демонструє використання Django з PostgreSQL та Nginx в Docker контейнерах.

## Технології

- **Django 4.2.7** - веб-фреймворк
- **PostgreSQL 15** - база даних
- **Nginx** - веб-сервер та reverse proxy
- **Docker & Docker Compose** - контейнеризація
- **Gunicorn** - WSGI сервер
- **WhiteNoise** - обслуговування статичних файлів

## Структура проекту

```
.
├── myproject/          # Django проект
├── main/              # Django додаток
├── nginx/             # Nginx конфігурація
├── requirements.txt   # Python залежності
├── Dockerfile         # Docker образ для Django
├── docker-compose.yml # Docker Compose конфігурація
└── .env              # Змінні середовища
```

## Запуск проекту

1. Клонуйте репозиторій:
```bash
git clone <repository-url>
cd <project-directory>
```

2. Запустіть проект за допомогою Docker Compose:
```bash
docker-compose up -d
```

3. Виконайте міграції бази даних:
```bash
docker-compose exec web python manage.py migrate
```

4. Створіть суперкористувача (опціонально):
```bash
docker-compose exec web python manage.py createsuperuser
```

5. Відкрийте браузер та перейдіть на http://localhost

## Доступні сервіси

- **Django застосунок**: http://localhost:8000
- **Nginx (через порт 80)**: http://localhost
- **PostgreSQL**: localhost:5432

## Команди для розробки

```bash
# Запуск всіх сервісів
docker-compose up -d

# Перегляд логів
docker-compose logs -f

# Зупинка сервісів
docker-compose down

# Перебудова образів
docker-compose up -d --build

# Виконання Django команд
docker-compose exec web python manage.py <command>
```

## Налаштування

Всі налаштування знаходяться в файлі `.env`:

- `DEBUG` - режим налагодження
- `SECRET_KEY` - секретний ключ Django
- `DJANGO_ALLOWED_HOSTS` - дозволені хости
- `DB_*` - налаштування бази даних

## Особливості проекту

- ✅ Контейнеризація всіх сервісів
- ✅ PostgreSQL інтеграція
- ✅ Nginx reverse proxy
- ✅ Статичні файли через WhiteNoise
- ✅ Змінні середовища
- ✅ Готовий до продакшену 