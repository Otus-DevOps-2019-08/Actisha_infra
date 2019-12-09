#!/bin/bash

git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

tee /etc/systemd/system/puma.service << EOF
[Unit]
Description=puma
[Service]
User=appuser
WorkingDirectory=/home/appuser/reddit
ExecStart=/usr/local/bin/puma -d
[Install]
WantedBy=multi-user.target
EOF

systemctl enable puma.service
systemctl start puma.service

