# Linux image used
FROM debian

WORKDIR /root/webserver
COPY Webserver.java /root/webserver

# Install JDK
RUN apt-get install sudo -y
RUN sudo apt-get install openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:$JAVA_HOME/bin

# Compile Game
RUN javac Webserver.java

RUN apt update && \
      apt install -y curl && \
      curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
      chmod +x ./kubectl && \
      mv ./kubectl /usr/local/bin/kubectl

EXPOSE 8000

ENTRYPOINT java Webserver
