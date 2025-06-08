
You need the podman socket service:
```
daisuke@kinoite-laptop:/var/home/daisuke/decrypted/work/nix-container/projects/master-nas-2025$ systemctl --user status podman.socket
● podman.socket - Podman API Socket
     Loaded: loaded (/usr/lib/systemd/user/podman.socket; enabled; preset: disabled)
     Active: active (listening) since Sun 2025-06-08 15:09:12 JST; 11min ago
 Invocation: bfba6159dc2d4ec283a1624d775d470c
   Triggers: ● podman.service
       Docs: man:podman-system-service(1)
     Listen: /run/user/1000/podman/podman.sock (Stream)
     CGroup: /user.slice/user-1000.slice/user@1000.service/app.slice/podman.socket

Jun 08 15:09:12 kinoite-laptop systemd[1701]: Listening on podman.socket - Podman API Socket.
```

You need podman-remote in the container:
```
daisuke@kinoite-laptop:/var/home/daisuke/decrypted/work/nix-container/projects/master-nas-2025$ cat Dockerfile 
FROM registry.fedoraproject.org/fedora-minimal:latest

# Install any additional packages you need
RUN dnf -y install ruby rubygems podman-remote neovim && \
    dnf clean all

```

Run it with the socket bind:
```
$ podman build -t test-podman-remote .

daisuke@kinoite-laptop:/var/home/daisuke/decrypted/work/nix-container/projects/master-nas-2025$ podman run --rm -it --security-opt label=disable -v /run/user/1000/podman/podman.sock:/run/podman/podman.sock:Z -e PODMAN_SOCKET=/run/podman/podman.sock test-podman-remote bash

bash-5.2# podman-remote run hello-world
Resolved "hello-world" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
Trying to pull quay.io/podman/hello:latest...
Getting image source signatures
Copying blob sha256:81df7ff16254ed9756e27c8de9ceb02a9568228fccadbf080f41cc5eb5118a44
Copying config sha256:5dd467fce50b56951185da365b5feee75409968cbab5767b9b59e325fb2ecbc0
Writing manifest to image destination
!... Hello Podman World ...!

         .--"--.           
       / -     - \         
      / (O)   (O) \        
   ~~~| -=(,Y,)=- |         
    .---. /`  \   |~~      
 ~/  o  o \~~~~.----. ~~   
  | =(X)= |~  / (O (O) \   
   ~~~~~~~  ~| =(Y_)=-  |   
  ~~~~    ~~~|   U      |~~ 

Project:   https://github.com/containers/podman
Website:   https://podman.io
Desktop:   https://podman-desktop.io
Documents: https://docs.podman.io
YouTube:   https://youtube.com/@Podman
X/Twitter: @Podman_io
Mastodon:  @Podman_io@fosstodon.org
```
