#!/bin/bash

# Your Hugging Face video link
VIDEO_URL="https://huggingface.co/datasets/komal0000/demggggos/resolve/main/content/K.G.F%20Chapter%202%20(2022).MULTI.4K.SDR.HEVC.WEB.DDP5.1TopMovies(HindiTeluguTamilKannadaMalayalam).mkv?download=true"

# Start self-ping in background
(
  while true
  do
    curl -s -o /dev/null "https://$RENDER_EXTERNAL_URL"
    echo "Pinged Render at $(date)"
    sleep 25
  done
) &

# Start Twitch stream loop
while true
do
  ffmpeg -re -i "$VIDEO_URL" \
    -c copy -f flv "rtmp://live.twitch.tv/app/live_1367628902_g95R7ikJZZG8HDgxTfHJuBfYEGMvqj"
done
