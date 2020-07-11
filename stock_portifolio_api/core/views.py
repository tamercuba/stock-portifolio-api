from rest_framework import viewsets

from core.models import Transaction
from core.serializers import TransactionSerializer


class TransactionsViewSet(viewsets.ModelViewSet):
    serializer_class = TransactionSerializer
    queryset = Transaction.objects.all()
