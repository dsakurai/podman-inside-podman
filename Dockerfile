FROM registry.fedoraproject.org/fedora-minimal:latest

# Install any additional packages you need
RUN dnf -y install podman-remote && \
    dnf clean all

