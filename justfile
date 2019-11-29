gen-key:
    openssl req \
        -newkey rsa:2048 \
        -x509 \
        -nodes \
        -keyout server.key \
        -new \
        -out server.crt \
        -subj /CN=localhost \
        -sha256 \
        -days 3650

test:
    docker run --rm \
        --name=v2ray-server \
        -p 8080:3333 \
        -e HOST=iffy.me \
        -v $(pwd)/server.key:/key \
        -v $(pwd)/server.crt:/crt \
        nnurphy/v2ray:ngx

run:
    docker run --restart=always -d \
        --name=v2ray-server \
        -p 8080:3333 \
        -e HOST=iffy.me \
        -v $HOME/.acme.sh/iffy.me/fullchain.cer:/crt \
        -v $HOME/.acme.sh/iffy.me/iffy.me.key:/key \
        nnurphy/v2ray:ngx

build:
    docker build . -t nnurphy/v2ray

buildn:
    docker build . -t nnurphy/v2ray:ngx -f Dockerfile-ngx