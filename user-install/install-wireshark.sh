#!/bin/bash

sudo apt install wireshark -y

sudo groupadd wireshark
sudo chgrp wireshark /usr/bin/dumpcap
sudo chmod 4750 /usr/bin/dumpcap

echo .
echo NOW RUN AS ROOT: "\$ sudo usermod -a -G wireshark $USER"
