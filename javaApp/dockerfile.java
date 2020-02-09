FROM openjdk:8u242-slim

ENV USER=appusr
ENV UID=12345
ENV GID=23456
ENV HOME=/caa


RUN groupadd -g $GID $USER && \
    useradd -u $UID -d $HOME -m -g $USER $USER

USER $USER
WORKDIR "$HOME"

ENTRYPOINT ["sleep","15"]
