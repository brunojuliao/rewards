FROM debian

ENV DEBIAN_FRONTEND=noninteractive

RUN alias python='python3' && echo "alias python='python3'" >> ~/.bashrc && apt -y update && apt -y upgrade

RUN apt install -y wget git cl-base64 python3 pip chromium-driver chromium procps unzip

# RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# RUN apt install ./google-chrome-stable_current_amd64.deb

# Check available versions here: https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable
ARG CHROME_VERSION="109.0.5414.74-1"
RUN wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb \
  && apt install -y /tmp/chrome.deb \
  && rm /tmp/chrome.deb

RUN mkdir rewards

WORKDIR /rewards

COPY . .

RUN chmod +x run.sh

RUN unzip bing-rewards.zip && rm bing-rewards.zip

RUN pip install -r bing-rewards/BingRewards/requirements.txt
