FROM elixir:1.10.2

ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG USERNAME=elixir

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME
