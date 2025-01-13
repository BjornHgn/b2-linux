FROM python

RUN apt update -y && apt install -y python3

RUN pip install  Flask && pip install flask_mysqldb

COPY main.py /tmp/

ENTRYPOINT ["python3", "/tmp/main.py"]