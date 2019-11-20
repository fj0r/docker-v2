```bash
docker run -p 1081:1080 \
    -d --restart=always \
    -v $(pwd)/v2ray.json:/etc/v2ray/config.json \
    --name=v2ray \
    nnurphy/v2ray
```


```bash
docker run -p 3333:3333 \
    -d --restart=always \
    -v $(pwd)/caddy:/root/.caddy \
    -e CADDY_HOST=iffy.me \
    -e CADDY_TLS_EMAIL=nash@iffy.me \
    --name=v2ray \
    nnurphy/v2ray:caddy
```