from rest_framework import viewsets
from rest_framework.response import Response


class HelloViewSet(viewsets.ViewSet):
    def get(self, request):
        return Response(data={'hellow': 'world'})
