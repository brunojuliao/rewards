FROM debian

ENV DEBIAN_FRONTEND=noninteractive

RUN alias python='python3' && echo "alias python='python3'" >> ~/.bashrc && apt update

RUN apt install -y vi cron python3 pip chromium-driver

#RUN pip install -r requirements.txt
