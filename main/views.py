from django.shortcuts import render
from django.http import HttpResponse
from django.db import connection

# Create your views here.

def home(request):
    # Test database connection
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT version();")
            db_version = cursor.fetchone()
        db_status = "Connected"
    except Exception as e:
        db_version = None
        db_status = f"Error: {str(e)}"
    
    context = {
        'db_status': db_status,
        'db_version': db_version,
        'title': 'Django Docker Project'
    }
    return render(request, 'main/home.html', context)
