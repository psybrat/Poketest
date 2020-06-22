from django.shortcuts import render
from django.contrib import messages
from .models import Pokemon

import io, csv

def pokemon_upload(request):
    template = "pokemon_upload.html"

    prompt = {
        'order' : 'Order of the CSV should be #,Name,Type 1,Type 2,Total,HP,Attack,Defense,Sp. Atk,Sp. Def,Speed,Generation,Legendary'
    }

    if request.method == "GET":
        return render(request, template, prompt)

    csv_file = request.FILES['file']

    if not csv_file.name.endswith('.csv'):
        messages.error(request, 'This is not a csv file')

    data_set = csv_file.read().decode('UTF-8')
    io_string = io.StringIO(data_set)
    next(io_string)
    for column in csv.reader(io_string, delimiter=',', quotechar="|"):
        _, created = Pokemon.objects.update_or_create(
            number=column[0],
            name=column[1],
            type_1=column[2],
            type_2=column[3],
            total=column[4],
            hp=column[5],
            attack=column[6],
            defense=column[7],
            sp_atk=column[8],
            sp_def=column[9],
            speed=column[10],
            generation=column[11],
            legendary=column[12],
        )

    context = {}
    return render(request, template, context)