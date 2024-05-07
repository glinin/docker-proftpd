# Use the official image as a base image
FROM alpine:3.19.1

MAINTAINER Anatoly Glinin (@glinin on telegram)

# Install proftpd package and dependencies in a single step
RUN apk update && \
    apk add --no-cache proftpd && \
    mkdir -p /run/proftpd/ && \
    ln -sf /dev/stderr /var/log/proftpd/proftpd_err.log && \
    ln -sf /dev/stdout /var/log/proftpd/proftpd_out.log

ENV SERVER_NAME=ProFTPD \
    DEFAULT_SERVER=on \
    SHOW_SYMLINKS=on \
    TIMEOUT_NO_TRANSFER=600 \
    TIMEOUT_STALLED=600 \
    TIMEOUT_IDLE=1200 \
    PORT=21 \
    PASSIVE_PORTS="20000 30000" \
    MAX_INSTANCES=30 \
    USER=proftpd \
    GROUP=nogroup


# Copy proftpd configuration file
COPY conf/proftpd.conf.j2 /etc/proftpd/proftpd.conf

# Open the FTP port
EXPOSE 20 21

# Start proftpd when the container launches
CMD ["proftpd","-n","-q"]
