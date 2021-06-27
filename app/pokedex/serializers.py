from rest_framework import serializers
from app.pokedex.models import Pokemon


class PokemonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pokemon
        fields = '__all__'
