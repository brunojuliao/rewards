#!/bin/bash

cd /rewards/bing-rewards/
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb
#./update.sh
cd /rewards/bing-rewards/BingRewards

if [ $# -eq 0 ] ; then
    echo "Syntax: ./run.sh '<original BingRewards.py parameters>' <email> <password> <telegram_token> <telegram_user_id>"
    exit 1
fi

params=$( echo $1 )

if [ $# -gt 1 ]
then
    email=$( echo $2 | base64 )
fi

if [ $# -gt 2 ]
then
    pass=$( echo $3 | base64 )
fi

if [ $# -gt 3 ]
then
    tat=$( echo $4 | base64 )
fi

if [ $# -gt 4 ]
then
    tu=$( echo $5 | base64 )
fi

if [ ! -f config/config.json ] ; then
    mkdir config;
    printf "{
        \"email\": \"$email\",
        \"password\": \"$pass\",
        \"telegram_api_token\": \"$tat\",
        \"telegram_userid\": \"$tu\"
    }" > config/config.json ;
fi

sed -i 's/options.add_argument("--disable-gpu")/options.add_argument("--disable-gpu")\n        options.add_argument("--no-sandbox")\n        options.add_argument("--ipc=host")\n        options.add_argument("--disable-dev-shm-usage")\n/' src/driver.py
sed -i "s/('telegram_api_token'))/('telegram_api_token')).replace('\\\n', '')/" BingRewards.py
sed -i "s/('telegram_userid'))/('telegram_userid')).replace('\\\n', '')/" BingRewards.py

eval "/usr/bin/python3 BingRewards.py $params"
