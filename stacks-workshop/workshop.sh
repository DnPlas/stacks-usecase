#! /usr/bin/env bash

# ---- CHECK ----
function docker_network {
   URL="https://api.github.com/repos/clearlinux/distribution/issues"
   net_command="curl '${URL}'; if [ $? -eq 0 ]; then \
	       echo 'Container is able to fetch from Github';
	       else echo 'Please check your Docker netowrk and proxy settings';
	       fi"
   docker run --rm sysstacks/dlrs-pytorch-clearlinux:v0.6.0 /bin/bash -c "${net_command}"
}

if ! command -v docker &> /dev/null; then
  echo 'MISSING Docker, please install it'
  exit 1
fi

if ! command -v git &> /dev/null; then
  echo 'MISSING git, please install it'
  exit 1
fi

# ---- CLONE STACKS REPOS ----
git clone https://github.com/intel/stacks.git

# ---- LAB-3 ----
# Clone media analytics resources
mkdir -p lab-3/gva && cd lab-3/gva
git clone https://github.com/opencv/gst-video-analytics \
  && cd gst-video-analytics \
  && git checkout v0.7 \
  && git submodule init \
  && git submodule update \
  && cd ..

git clone https://github.com/opencv/open_model_zoo.git \
  && cd open_model_zoo \
  && git checkout 2019_R3 \
  && cd ..
	
git clone https://github.com/intel-iot-devkit/sample-videos.git data/video

# Pull all docker images
docker pull sysstacks/dlrs-pytorch-clearlinux:v0.6.0-oss
docker pull sysstacks/mers-clearlinux
docker pull clearlinux/stacks-dars-openblas

# ---- DOCKER CHECK ----
echo '---------- DOCKER NETWORK CHECK ----------'
if [[ -e 
docker_network
echo '---------- DOCKER NETWORK CHECK DONE ----------'
