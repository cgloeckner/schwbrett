#!/bin/bash

# try to pull update
git pull

# run server
./main.py &
sleep 3s

# start browser
firefox --new-window http://localhost:8080 &
sleep 3s

# trigger fullscreen
xdotool search --sync --onlyvisible --class "firefox-esr" key F11
