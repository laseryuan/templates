[![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-Ready--to--Code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/laseryuan/templates) 

Docker Multi-Architecture Images

Works for both amd64 (Ubuntu) and arm32v6 (Rapsberry Pi)

# Usage
```
docker run --rm lasery/app
```

## Start the program
Prepare environment
Demand
```
  -e DOMAIN=\
```

Optional
```
  -e DEBUG=true
```


# Development
```
cd ~/projects/docker-apps/app

docker volume create \
  --label keep \
  app-config

docker run --name=app --rm \
  -it \
  app \
  bash
```

Mount local volumes
```
  -v $(pwd)/docker-entrypoint.sh:/docker-entrypoint.sh \
  -v $(pwd)/tmpl/:/etc/app/tmpl/ \
```

Runtime
```
  -v /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static `# Cross run` \
```

Graphic and Audio
```
export PULSE_SERVER=/run/user/1000/pulse/native

# if using system-wise pulseaudio
export PULSE_SERVER=/run/pulse/native
xhost +SI:localuser:$(id -nu 1000) # if current user id is not 1000
```

```
  -v app-config:/home/app/.config \

  `# graphic` \
  -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix `# container user need to have same uid as host user and be in video group` \
  --device=/dev/dri \
  --net=host -v ~/.Xauthority:/home/app/.Xauthority:ro `don't use this method if not neccessary` \

  # https://github.com/mviereck/x11docker/wiki/Container-sound:-ALSA-or-Pulseaudio
  `# sound` \
  -e PULSE_SERVER=unix:/run/user/1000/pulse/native -v /run/user/1000/pulse:/run/user/1000/pulse \
  --device /dev/snd `# for alsa`\

  `# memory` \
  --tmpfs /tmp/ \

  --device /dev/input:/dev/input `# input device` \

  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/machine-id:/etc/machine-id:ro \
  -v /var/run/dbus/:/var/run/dbus/ \

  --group-add video \

  --privileged \

  `# Raspberry pi specific` \
  -v /opt/vc:/opt/vc `# ARM side code to interface to: EGL, mmal, GLESv2, vcos, openmaxil, vchiq_arm, bcm_host, WFC, OpenVG`\
  --device /dev/vchiq `# camera to gpu interface` \
  --device /dev/ttyAMA0 `# serial ports, bluetooth` \
  --device /dev/vcio `# GPU` \
  --device /dev/fb0 `# framebuffer device` \
  --device /dev/vcsm:/dev/vcsm `# VideoCore Shared Memory` \
```

- Google console
```
docker pull {gcr.io repository}
docker tag {gcr.io repository} lasery/{docker.io repository}
docker push lasery/{docker.io repository}
```

## update gitpod dev image
```
docker build -t lasery/app:gitpod -f .gitpod.Dockerfile .
docker push lasery/app:gitpod
```

## Build image
- Docker cloud auto-build
```
curl --request POST https://cloud.docker.com/api/build/v1/source/{ID}/call/
```

Access host from container
```
  --add-host "docker0:$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')" \

ping docker0
```

- Local
```
docker run --rm -it \
  -v $(pwd)/:/home/mbuild/ \
  -v ~/.docker/:/root/.docker/ \
  -v /var/run/docker.sock:/var/run/docker.sock \
  lasery/mbuild \
bash

cd mbuild

# append "skip" to skip compile bake and dockerfiles
# append "only" to perform current task only
python3 ~/mbuild/utils/build.py docker
python3 ~/mbuild/utils/build.py push only
python3 ~/mbuild/utils/build.py deploy only
```

# Issues

