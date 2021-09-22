FROM debian

ENV DEBIAN_FRONTEND=noninteractive

RUN alias python='python3' && echo "alias python='python3'" >> ~/.bashrc && apt update

RUN apt install -y python3 pip chromium-driver

RUN mkdir rewards

WORKDIR /rewards

COPY . .

RUN pip install -r requirements.txt