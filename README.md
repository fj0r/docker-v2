```bash
docker run -p 1081:1080 \
    -d --restart=always \
    -v $(pwd)/v2ray.json:/etc/v2ray/config.json \
    --name=v2ray \
    nnurphy/v2ray
```


```bash
docker run --restart=always -d \
    -p 8080:3333 \
    -v $HOME/.acme.sh/iffy.me/fullchain.cer:/cer \
    -v $HOME/.acme.sh/iffy.me/iffy.me.key:/key \
    --name=v2ray-server \
    nnurphy/v2ray:ngx
```