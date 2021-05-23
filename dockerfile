FROM tiangolo/uwsgi-nginx
EXPOSE 8000/udp
EXPOSE 8000/tcp
EXPOSE 22/tcp
WORKDIR /var/www/
COPY . .
RUN pip install -r requirements.txt
RUN python manage.py migrate

