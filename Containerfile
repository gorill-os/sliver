FROM ghcr.io/ublue-os/arch-distrobox AS sliver

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="Sliver is a container for Silverblack" \
      maintainer="parencompany@proton.me"

# Set the hostname
RUN echo "sliver" > /etc/hostname

# Install needed packages
RUN pacman -Sy --noconfirm \
        emacs-slime \
        emacs \
        ecl \
        sbcl \
        roswell \
        quicklisp \
        stumpwm \
        stumpwm-contrib \
        nyxt \
        chezmoi \
        fzf \
        github-cli \
        git-lfs \
        git \
        just \
        micro \
        racket \
        fennel \
        clojure \
        leiningen \
        zsh 

# Create build user
RUN useradd -m --shell=/bin/bash build && \
    usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install AUR packages
USER build
WORKDIR /home/build
RUN paru -S --noconfirm \
        aur/visual-studio-code-bin \
        aur/chez-scheme \
        aur/chibi-scheme \
        aur/gerbil-scheme \
        aur/clasp-cl \
        aur/abcl 
USER root
WORKDIR /

# Cleanup
RUN userdel -r build && \
    rm -drf /home/build && \
    sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    rm -rf \
        /tmp/* \
        /var/cache/pacman/pkg/*
