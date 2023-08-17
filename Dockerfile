FROM nvidia/cudagl:11.4.1-runtime

RUN apt-get install -y zip unzip wget gnupg2 ca-certificates curl fonts-liberation libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcups2 libgtk-3-0 libnspr4 libnss3 libu2f-udev libvulkan1 libxcomposite1 libxdamage1 xdg-utils build-essential libasound2 && \
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
  dpkg -i google-chrome-stable_current_amd64.deb

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
  apt-get install -y nodejs

RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* 
