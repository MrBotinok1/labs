#!/bin/bash

>server.conf

if [ -z "$SERVER_NAME" ]; then
    SERVER_NAME="StarCraft"
fi
echo "SERVER_NAME=\"$SERVER_NAME\"" >> server.conf

if [ -z "$MAX_PLAYERS" ]; then
    MAX_PLAYERS=125
fi
echo "MAX_PLAYERS=$MAX_PLAYERS" >> server.conf

if [ -z "$SPAWN_COORDS" ]; then
    SPAWN_COORDS="274 67 -249"
fi
echo "SPAWN_COORDS=\"$SPAWN_COORDS\"" >> server.conf

cat server.conf
