FROM python:2.7

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir --retries 50 -r requirements.txt -i https://pypi.douban.com/simple/ --trusted-host pypi.douban.com

RUN sed -i "s/http:\/\/deb\.debian\.org/http:\/\/mirrors.163.com/" /etc/apt/sources.list
RUN apt-get update && apt-get -y install cron
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

USER root
RUN mkdir -p /app

VOLUME /log
VOLUME /tmp

ADD ./bin /app/bin
ADD ./conf /app/conf

WORKDIR /app

COPY redismon_cron /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab
RUN /usr/bin/crontab /etc/cron.d/crontab

# run crond as main process of container
CMD ["cron", "-f"]

# CMD ["python","/app/bin/redis_monitor.py"]
