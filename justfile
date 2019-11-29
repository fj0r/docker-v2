gen-key domain="localhost":
    mkdir -p certs
    openssl req \
        -newkey rsa:4096 -nodes -sha256 -keyout certs/{{domain}}.key \
        -x509 -days 365 -out certs/{{domain}}.crt \
        -subj /CN={{domain}}

test:
    docker run --rm \
        --name=v2ray-server \
        -p 8090:3333 \
        -e HOST=localhost \
        -v $(pwd)/certs/localhost.key:/key \
        -v $(pwd)/certs/localhost.crt:/crt \
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