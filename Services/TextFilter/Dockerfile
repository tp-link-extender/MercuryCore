FROM python:3.9-slim
USER root

WORKDIR /services/text-filter

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "3476"]