from django.urls import path

from . import views

urlpatterns = [
    path(
        'transactions',
        views.TransactionsViewSet.as_view({'get': 'list'}),
        name='transactions',
    )
]
