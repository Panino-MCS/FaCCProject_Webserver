# Linux image used
FROM debian

WORKDIR /root/webserver
COPY Webserver.java /root/webserver

# Install JDK
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /usr/share/man/man1 /usr/share/man/man2

RUN apt-get update && \
apt-get install -y --no-install-recommends \
        openjdk-8-jre

# Compile Game
RUN javac Webserver.java

RUN apt update && \
      apt install -y curl && \
      curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
      chmod +x ./kubectl && \
      mv ./kubectl /usr/local/bin/kubectl

EXPOSE 8000

ENTRYPOINT java Webserver
