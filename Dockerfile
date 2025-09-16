FROM ubuntu:22.04

# Install ffmpeg, curl (for self-ping), wget
RUN apt-get update && apt-get install -y ffmpeg curl wget

# Copy script into container
COPY stream.sh /stream.sh
RUN chmod +x /stream.sh

# Run script
CMD ["/stream.sh"]
