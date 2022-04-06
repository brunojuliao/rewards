#!/bin/bash
rm -R bing-rewards

git clone https://github.com/jjjchens235/bing-rewards.git

cd bing-rewards/BingRewards/

pip install -r requirements.txt

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

printf "credentials = dict(
    email = '$email',
    password = '$pass',
    telegram_api_token = '$tat',
    telegram_userid = '$tu'
)
" > src/config.py

sed -i 's/options.add_argument("--disable-gpu")/options.add_argument("--disable-gpu")\n        options.add_argument("--no-sandbox")\n        options.add_argument("--ipc=host")\n        options.add_argument("--disable-dev-shm-usage")\n/' src/driver.py
sed -i "s/('telegram_api_token'))/('telegram_api_token')).replace(\"\n\", \"\")" BingRewards.py
sed -i "s/('telegram_userid'))/('telegram_userid')).replace(\"\n\", \"\")" BingRewards.py

eval "/usr/bin/python3 BingRewards.py $params"