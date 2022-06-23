#!/bin/bash

RET=$(git pull)

# try to pull new version and reboot
if [ "$RET" != "Bereits aktuell." ]; then
    reboot
fi