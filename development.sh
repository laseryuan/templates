Config() {
. tmp/env.sh
# . tmp/env.dev.sh

echo $ENVIRONMENT_VARS
# ENVIRONMENT_VARS=\
}
Config

## Setup the project
Initiate_environment_file() {
cp tmp/sample.env.sh tmp/env.sh
}

#Development environment with code updates
dev() {
docker run \
    -it \
    --entrypoint= \
    --privileged `#make it work first, then security` \
    -v $(get_host_pwd)/tmp:/tmp \
    -v $(get_host_pwd)/app:/app \
    --rm \
    --name my-app \
    -v $(get_host_pwd)/tmp/application_default_credentials.json:/tmp/application_default_credentials.json:ro \
    -e CREDENTIALS=/tmp/application_default_credentials.json \
    my-app \
    bash
}

test(){
# run in dev enviorment
echo "test successfually"
}

# build images
build() {
python3 ~/mbuild/utils/build.py docker
# --bake-arg "--progress plain --set *.cache-from=lasery/ride:latest"
}

# Run locally
run() {
build

docker run \
    --rm \
    --name my-app \
    -v $(get_host_pwd)/tmp/application_default_credentials.json:/tmp/application_default_credentials.json:ro \
    -e CREDENTIALS=/tmp/application_default_credentials.json \
    my-app \
    ${RUN_ARGS}
}

push() {
python3 ~/mbuild/utils/build.py push --only
}

deploy() {
build
push
python3 ~/mbuild/utils/build.py deploy --only
}

Misc_tasks() {
task1
task2
}

Misc_tags() {
  --tmpfs /tmp/ \
  --device /dev/input:/dev/input `# input device` \
  -v /etc/machine-id:/etc/machine-id:ro \
  -v /var/run/dbus/:/var/run/dbus/ \
  --group-add video \
  ``
}

# Cross run
Runtime() {
echo \
  -v /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static
}

Audio() {
# if current user id is not 1000
# xhost +SI:localuser:$(id -nu 1000)
echo \
-v /run/user/1000/pulse:/run/user/1000/pulse \
-e PULSE_SERVER=/run/user/1000/pulse/native \
-e PULSE_SERVER=/run/pulse/native \
``

#for alsa
echo \
--device /dev/snd
}

Graphic() {
echo \
  -e DISPLAY=unix:0 \
  -e DISPLAY=unix:1 `# vnc` \
  -e DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix `# container user need to have same uid as host user and be in video group` \
  --privileged --device=/dev/dri \
  --net=host -v ~/.Xauthority:/home/app/.Xauthority:ro `#don't use this method if not neccessary` \
  ``
}

Raspberry_pi_specific() {
echo \
  -v /opt/vc:/opt/vc `# ARM side code to interface to: EGL, mmal, GLESv2, vcos, openmaxil, vchiq_arm, bcm_host, WFC, OpenVG` \
  --device /dev/vchiq `# camera to gpu interface` \
  --device /dev/ttyAMA0 `# serial ports, bluetooth` \
  --device /dev/vcio `# GPU` \
  --device /dev/fb0 `# framebuffer device` \
  --device /dev/vcsm:/dev/vcsm `# VideoCore Shared Memory` \
  ``
}

