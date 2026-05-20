#!/bin/bash

TORRENT_HASH=$1 # hash of torrent

curl -v -X PATCH http://qbittorrent-add-trackers-app:${ADD_TRACKER_APP_PORT:-8080}/torrents/$TORRENT_HASH
