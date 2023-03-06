FROM alpine:3.14

#用清华镜像
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache cmake
RUN apk add --no-cache g++

# # Configure apache
# RUN echo '. /etc/apache2/envvars' > /root/run_apache.sh && \
#  echo 'mkdir -p /var/run/apache2' >> /root/run_apache.sh && \
#  echo 'mkdir -p /var/lock/apache2' >> /root/run_apache.sh && \
#  echo '/usr/sbin/apache2 -D FOREGROUND' >> /root/run_apache.sh && \
#  chmod 755 /root/run_apache.sh

# EXPOSE 80

RUN echo 'Start sleeping'
CMD sleep 1h
