# Linux image used
FROM debian

WORKDIR /root/webserver
COPY Webserver.java /root/webserver

# Install JDK
LABEL Description="Java + Debian (OpenJDK)"

ENV DEBIAN_FRONTEND noninteractive

ARG JAVA_VERSION=8
ARG JAVA_RELEASE=JRE

RUN bash -c ' \
    set -euxo pipefail && \
    apt-get update && \
    pkg="openjdk-$JAVA_VERSION"; \
    if [ "$JAVA_RELEASE" = "JDK" ]; then \
        pkg="$pkg-jdk"; \
    else \
        pkg="$pkg-jre-headless"; \
    fi; \
    apt-get install -y --no-install-recommends "$pkg" && \
    apt-get clean \
    '

COPY profile.d/java.sh /etc/profile.d/

ENV JAVA_HOME=/usr

# Compile Game
RUN javac Webserver.java

RUN apt update && \
      apt install -y curl && \
      curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
      chmod +x ./kubectl && \
      mv ./kubectl /usr/local/bin/kubectl

EXPOSE 8000

ENTRYPOINT java Webserver
