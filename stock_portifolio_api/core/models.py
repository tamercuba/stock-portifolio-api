from django.db import models


class Transaction(models.Model):
    ticker = models.CharField(
        null=False, blank=False, max_length=10, db_index=True
    )
    quantity = models.IntegerField(blank=False, null=False, default=0)

    purchase_date = models.DateField(blank=False, null=False)
    sale_date = models.DateField(blank=True, null=True)

    purchase_price = models.DecimalField(
        blank=True, null=False, decimal_places=2, default=0, max_digits=10
    )
    purchase_tax = models.DecimalField(
        blank=True, null=False, decimal_places=2, default=0, max_digits=10
    )
    sale_price = models.DecimalField(
        blank=True, null=False, decimal_places=2, default=0, max_digits=10
    )
    sale_tax = models.DecimalField(
        blank=True, null=False, decimal_places=2, default=0, max_digits=10
    )

    def __str__(self):
        return (
            f'{self.ticker} - {self.quantity}'
            f': {self.purchase_date} -> {self.sale_date}'
        )
