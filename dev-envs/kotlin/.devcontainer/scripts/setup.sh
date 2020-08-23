#!/bin/bash

USERNAME="vscode"
USER_UID=1000
USER_GID=1000

cat >> /etc/skel/.bashrc <<'EOF'
export SDKMAN_DIR="/usr/local/sdkman"
source "/usr/local/sdkman/bin/sdkman-init.sh"
EOF

if id -u $USERNAME > /dev/null 2>&1; then
    # User exists, update if needed
    if [ "$USER_GID" != "$(id -G $USERNAME)" ]; then
        groupmod --gid $USER_GID $USERNAME
        usermod --gid $USER_GID $USERNAME
    fi
    if [ "$USER_UID" != "$(id -u $USERNAME)" ]; then
        usermod --uid $USER_UID $USERNAME
    fi
else
    # Create user
    groupadd --gid $USER_GID $USERNAME
    useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME
fi


apt update
apt install zip unzip sudo
export SDKMAN_DIR="/usr/local/sdkman" && curl -s "https://get.sdkman.io" | bash

source "/usr/local/sdkman/bin/sdkman-init.sh"

sdk install gradle
