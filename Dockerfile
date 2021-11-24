FROM python:2.7

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir --retries 50 -r requirements.txt -i https://pypi.douban.com/simple/ --trusted-host pypi.douban.com

RUN mkdir -p /app

VOLUME /log
VOLUME /tmp

ADD ./bin /app/bin
ADD ./conf /app/conf

WORKDIR /app

CMD ["python","/app/bin/redis_monitor.py"]

