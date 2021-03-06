# Linux image used
FROM alpine
WORKDIR /root/webserver
COPY Webserver.java /root/webserver

# Install JDK
RUN apk add openjdk8
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:$JAVA_HOME/bin

# Compile Game
RUN apk update && \
      apk --no-cache add curl && \
      curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
      chmod +x ./kubectl && \
      mv ./kubectl /usr/local/bin/kubectl

RUN javac Webserver.java

EXPOSE 8000

ENTRYPOINT java Webserver
