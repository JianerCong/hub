FROM python:3

WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
# COPY . .
# CMD [ "python", "./your-daemon-or-script.py" ]
ENV ALL_PROXY=host.docker.internal:7890
ENV all_proxy=host.docker.internal:7890
# ENV http_proxy=host.docker.internal:7890
# ENV HTTP_PROXY=host.docker.internal:7890
# ENV https_proxy=host.docker.internal:7890
# ENV HTTPS_PROXY=host.docker.internal:7890
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./serv.py .
CMD ["sh","-c"," \
    echo \"the proxy is ${ALL_PROXY}\"  && \
    apt install nginx && \
    nginx && \
    python ./serv.py 7777 \
    "]

# FROM alpine
# ENV ALL_PROXY=host.docker.internal:7890
# CMD ["sh","-c","echo \"Proxy is ${ALL_PROXY}\" && echo another echo"]
# docker run --rm --name my-nginx-container my-nginx
