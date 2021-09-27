#!/bin/bash

./main.py &
sleep 3s
firefox --kiosk --new-window http://localhost:8080
