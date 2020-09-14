#!/usr/bin/env bash

function setupPackages() {
    apt-get update
    apt-get install -y git curl unzip
}

function setupAsdk() {
    mkdir -p /etc/skel
    cat >> /etc/skel/.bashrc <<-'EOF'
    if [[ ! -d "$HOME/.asdf" ]]; then
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    fi

    . $HOME/.asdf/asdf.sh
    asdf plugin-add gradle https://github.com/rfrancis/asdf-gradle.git
    asdf plugin-add java https://github.com/halcyon/asdf-java.git

    . ~/.asdf/plugins/java/set-java-home.bash

    asdf install
EOF
}

function setupUser() {
    local -r USERNAME="vscode"
    local -r USER_UID=1000
    local -r USER_GID=1000

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

    echo "vscode ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
}

setupPackages
setupAsdk
setupUser
