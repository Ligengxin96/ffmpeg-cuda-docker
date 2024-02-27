FROM --platform=linux/arm64 nvidia/cudagl:11.2.2-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive

RUN rm /etc/apt/sources.list.d/cuda.list && apt-key del 7fa2af80 \
  && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/arm64/3bf863cc.pub \
  && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/sbsa/7fa2af80.pub

RUN apt-get update && apt-get install -y zip unzip git wget gnupg2 ca-certificates curl fonts-liberation libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcups2 libgtk-3-0 \
  libnspr4 libnss3 libu2f-udev libvulkan1 libxcomposite1 libxdamage1 xdg-utils build-essential nasm yasm pkgconf \
  libasound2 libmp3lame-dev libx264-dev libx265-dev libvpx-dev libpng-dev zlib1g-dev chromium-browser && \
  wget https://nodejs.org/dist/v18.16.1/node-v18.16.1-linux-arm64.tar.gz && tar -xvf node-v18.16.1-linux-arm64.tar.gz && \
  mv node-v18.16.1-linux-arm64 /usr/local/ && export PATH=$PATH:/usr/local/node-v18.16.1-linux-arm64/bin && rm -f node-v18.16.1-linux-arm64.tar.gz

RUN git clone https://github.com/FFmpeg/nv-codec-headers.git && cd nv-codec-headers && git checkout n9.0.18.3 && make install && cd ..

RUN git clone https://git.ffmpeg.org/ffmpeg.git && cd ffmpeg && git checkout n4.4.4 \
  && ./configure --enable-nonfree --enable-cuda --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --enable-opencl --enable-gpl \
  --enable-libmp3lame --enable-libx264 --enable-libx265 --enable-libvpx \
  --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 \
  && make -j$(nproc) && make install && cd .. && ffmpeg -codecs 

RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* ./nv-codec-headers ./ffmpeg
