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

    checkbox_mapping = {'on': True, 'off': False}
    csv_file = request.FILES['file']
    filters = checkbox_mapping[request.POST.get('filter', default='off')]

    def check_filters(f, l, g):
        """
        Return True if filters=False
        Return False if filter=True and (legendary=True or ghost type=True)
        Return True if filter=True and  (legendary=False and ghost type=False)
        :param f: Bool filter from checkbox
        :param l: Bool legendary
        :param g: Bool Ghost type
        :return: Bool
        """
        print('---')
        print(f, l, g)
        print('---')
        if not f:
            return True
        if l:
            return False
        if g:
            return False
        return True


    if not csv_file.name.endswith('.csv'):
        messages.error(request, 'This is not a csv file')

    data_set = csv_file.read().decode('UTF-8')
    io_string = io.StringIO(data_set)
    next(io_string)
    for column in csv.reader(io_string, delimiter=',', quotechar="|"):
        if check_filters(filters, column[12] == 'True', 'Ghost' in {column[2], column[3]}):
            _, created = Pokemon.objects.update_or_create(
                number=column[0],
                name=column[1],
                type_1=column[2],
                type_2=column[3],
                total=column[4],
                hp=int(column[5]) * (1 + 1*filters*('Steel' in {column[2], column[3]})),
                attack=int(column[6]) // (1 + 0.1*filters*('Fire' in {column[2], column[3]})),
                defense=int(column[7]) + filters*column[1].startswith('G')*5*(len(column[1])-1),
                sp_atk=round(int(column[8]) * (1 - 0.1*filters*({'Bug', 'Flying'} == {column[2], column[3]}))),
                sp_def=column[9],
                speed=column[10],
                generation=column[11],
                legendary=column[12],
            )

    context = {}
    return render(request, template, context)