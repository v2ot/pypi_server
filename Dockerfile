FROM python:3.6.15-slim

RUN pip install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple devpi-server devpi-web devpi-client supervisor

WORKDIR /app/

ADD run.sh /app/

VOLUME /var/lib/devpi

CMD ["/app/run.sh"]
