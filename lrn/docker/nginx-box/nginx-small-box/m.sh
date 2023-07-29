docker build \
       -t my-nginx \
       --progress=plain \
       .

# 🦜 : there's a bug in docker 24.0.0 that the host-gateway is not working
# docker build \
#        --add-host host.docker.internal:host-gateway \
#        -t my-nginx \
#        .
# What about compose?
# docker compose up --build --progress=plain --no-cache

# 🦜 -d means detach and leave an id
# docker run --rm --name my-nginx-container -d my-nginx
docker run --rm \
       --add-host host.docker.internal:host-gateway \
       --name my-nginx-container -it my-nginx

docker run  \
       --add-host host.docker.internal:host-gateway \
       --name my-nginx-container -it my-nginx

# run an ubuntu
docker run --rm -it --add-host \
       host.docker.internal:host-gateway \
       nicolaka/netshoot


export ALL_PROXY=host.docker.internal:7890
export all_proxy=$ALL_PROXY
# 🦜 : okay: curl http://www.google.com/ passed

# export http_proxy=host.docker.internal:7890
# export HTTP_PROXY=$http_proxy
# export https_proxy=$http_proxy
# export HTTPS_PROXY=$http_proxy
