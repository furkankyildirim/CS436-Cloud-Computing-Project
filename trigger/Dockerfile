FROM python:3.11.5

ENV PYTHONUNBUFFERED=1

WORKDIR /trigger
COPY requirements.txt .
RUN pip3 install -r requirements.txt
# RUN pip3 install -r requirements.txt --no-cache-dir --no-dependencies

COPY . .

EXPOSE 8081

# Run the application.
CMD uvicorn main:app --host=0.0.0.0 --port=8081 --workers=4 --limit-concurrency=1000 --reload --proxy-headers
