# A Docker image based on Ubuntu 20.04 that includes FFmpeg, Chrome, CUDA 11, and Node.js 18.

### Cannot load *.so issue
Check docker run command whether add `-e NVIDIA_DRIVER_CAPABILITIES=all` 

### The "nvidia-smi" command did not output any information
Check docker run command whether add `--gpus all` option

### example docker run command


```dockerfile
# render-service image dockerfile
FROM ligengxin96/ffmpeg-cuda11:1.0.0

ARG APP_DIR=/app
ARG ENV=development

ENV RENDERER_ENV $ENV
ENV APP_DIR $APP_DIR

WORKDIR $APP_DIR

COPY . .

RUN npm install

CMD ["node", "index.js"]
```

```bash
#!/bin/sh
IMAGE=${1:-"render-service:1.0.0"}

docker stop render-service && docker rm render-service

docker run -itd --init \
--name render-service \
--network=host \
-v /etc/localtime:/etc/localtime \
--restart on-failure \
--ulimit core=0 \
--gpus all \
-e DISPLAY=unix$DISPLAY \
-e GDK_SCALE \
-e GDK_DPI_SCALE \
-e NVIDIA_DRIVER_CAPABILITIES=all \
$IMAGE

```
