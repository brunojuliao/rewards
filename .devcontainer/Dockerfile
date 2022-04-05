FROM debian

ENV DEBIAN_FRONTEND=noninteractive

RUN alias python='python3' && echo "alias python='python3'" >> ~/.bashrc && apt update

RUN apt install -y vim cron git cl-base64 python3 pip chromium-driver