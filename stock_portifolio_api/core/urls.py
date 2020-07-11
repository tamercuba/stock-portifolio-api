from django.urls import path

from . import views

urlpatterns = [
    path('', views.HelloViewSet.as_view({'get': 'get'}), name='home')
]
