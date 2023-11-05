FROM ubuntu:latest

COPY elasticsearch.yml /usr/share/elasticsearch/config

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -g 1000

RUN apt-get update && \
apt-get install -y --no-install-recommends \
apt-transport-https \
wget \
curl

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.8.1-amd64.deb --no-check-certificate

CMD ["elasticsearch"]

EXPOSE 9200 9300
