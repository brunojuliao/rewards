FROM debian

ENV DEBIAN_FRONTEND=noninteractive

RUN alias python='python3' && echo "alias python='python3'" >> ~/.bashrc && apt update

RUN apt install -y wget git cl-base64 python3 pip chromium-driver chromium procps

# RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# RUN apt install ./google-chrome-stable_current_amd64.deb

RUN mkdir rewards

WORKDIR /rewards

COPY . .

RUN chmod +x run.sh

RUN git clone https://github.com/jjjchens235/bing-rewards.git

RUN pip install -r bing-rewards/BingRewards/requirements.txt