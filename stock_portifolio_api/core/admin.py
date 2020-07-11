from django.contrib.admin import site

from core.models import Transaction

site.register(Transaction)
