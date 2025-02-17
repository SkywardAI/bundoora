## How to use autoinstall.sh

`autoinstall.sh` will support you remove current version of docker and install the recommended version of docker for Debian/Ubuntu seriesly automatically.

### Download and execute the setup script for docker

```bash
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/autoinstall.sh |sudo -E bash -
```
The result should be
```
Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
groupadd: group 'docker' already exists
```

### Permission denied
```bash
ubuntu@ip-10-0-45-87:~$ docker ps -a
permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.47/containers/json?all=1": dial unix /var/run/docker.sock: connect: permission denied
```

### Apply new group membership

```bash
newgrp docker
```

and you are good to go

```bash
ubuntu@ip-10-0-45-87:~$  docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
