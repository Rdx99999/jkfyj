#!/bin/bash

# Your Hugging Face video link
VIDEO_URL="https://huggingface.co/datasets/komal0000/demggggos/resolve/main/content/K.G.F%20Chapter%202%20(2022).MULTI.4K.SDR.HEVC.WEB.DDP5.1TopMovies(HindiTeluguTamilKannadaMalayalam).mkv?download=true"

# Your Twitch Stream Key (replace with yours)
TWITCH_KEY="live_1367628902_g95R7ikJZZG8HDgxTfHJuBfYEGMvqj"

# Your Render service domain (for self-ping)
PING_URL="https://jkfyj.onrender.com"

# Start self-ping in background
(
  while true
  do
    curl -s -o /dev/null "$PING_URL"
    echo "Pinged Render at $(date)"
    sleep 25
  done
) &

# Detect codecs
VIDEO_CODEC=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$VIDEO_URL")
AUDIO_CODEC=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of csv=p=0 "$VIDEO_URL")

echo "Detected Video Codec: $VIDEO_CODEC"
echo "Detected Audio Codec: $AUDIO_CODEC"

# Decide ffmpeg command
while true
do
  if [[ "$VIDEO_CODEC" == "h264" && "$AUDIO_CODEC" == "aac" ]]; then
    echo "✅ Already Twitch-compatible, streaming without re-encode..."
    ffmpeg -re -i "$VIDEO_URL" \
      -c copy -f flv "rtmp://live.twitch.tv/app/$TWITCH_KEY"
  else
    echo "⚠️ Not Twitch-compatible ($VIDEO_CODEC/$AUDIO_CODEC), re-encoding..."
    ffmpeg -re -i "$VIDEO_URL" \
      -c:v libx264 -preset veryfast -maxrate 3000k -bufsize 6000k \
      -c:a aac -b:a 160k -ar 44100 \
      -f flv "rtmp://live.twitch.tv/app/$TWITCH_KEY"
  fi
done
