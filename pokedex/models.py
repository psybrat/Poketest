from django.db import models


class Pokemon(models.Model):
    """

    """
    pokemon_id = models.AutoField(primary_key=True)
    number = models.PositiveSmallIntegerField()
    name = models.CharField(max_length=255)
    type_1 = models.CharField(max_length=63)
    type_2 = models.CharField(max_length=63)
    total = models.CharField(max_length=63)
    hp = models.PositiveSmallIntegerField()
    attack = models.PositiveSmallIntegerField()
    defense = models.PositiveSmallIntegerField()
    sp_atk = models.PositiveSmallIntegerField()
    sp_def = models.PositiveSmallIntegerField()
    speed = models.PositiveSmallIntegerField()
    generation = models.CharField(max_length=3)
    legendary = models.BooleanField()

    def __str__(self):
        return f'{self.number},{self.name},{self.type_1},{self.type_2},{self.total},{self.hp},{self.attack},\
{self.defense},{self.sp_atk},{self.sp_def},{self.speed},{self.generation},{self.legendary}'
