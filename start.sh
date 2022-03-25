#!/bin/bash

./main.py &
sleep 3s
firefox --new-window http://localhost:8080
sleep 3s
xdotool search --sync --onlyvisible --class "firefox-esr" key F11
