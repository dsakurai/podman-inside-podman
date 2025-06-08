FROM registry.fedoraproject.org/fedora-minimal:latest

# Install any additional packages you need
RUN dnf -y install ruby rubygems podman-remote neovim && \
    dnf clean all

