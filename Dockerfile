FROM nvidia/cudagl:11.0-devel-ubuntu18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y wget

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub && apt-key add 7fa2af80.pub

RUN apt-get update && apt-get install -y zip unzip git curl gnupg2 ca-certificates fonts-liberation libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcups2 libgtk-3-0 \
  libnspr4 libnss3 libu2f-udev libvulkan1 libxcomposite1 libxdamage1 xdg-utils build-essential nasm yasm pkgconf \
  libasound2 libmp3lame-dev libx264-dev libx265-dev libvpx-dev && \
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
  dpkg -i google-chrome-stable_current_amd64.deb

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
  apt-get install -y nodejs

RUN git clone https://github.com/FFmpeg/nv-codec-headers.git && cd nv-codec-headers && git checkout n9.0.18.3 && make install && cd ..

RUN git clone https://git.ffmpeg.org/ffmpeg.git && cd ffmpeg && git checkout n4.4.4 \
  && ./configure --enable-nonfree --enable-cuda --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --enable-opencl --enable-gpl \
  --enable-libmp3lame --enable-libx264 --enable-libx265 --enable-libvpx \
  --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 \
  && make -j$(nproc) && make install && cd ..

RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* ./nv-codec-headers ./ffmpeg
