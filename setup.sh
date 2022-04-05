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

eval "/usr/bin/python3 BingRewards.py $1"