# System Stacks Workshop

Welcome to the System Stacks Workshops. In this directory you will find all needed files and scripts for each lab in the workshop.

## Pre-requisites

1. You MUST have a Linux environment up and ready. It can be a Virtual Machine, bare metal installation or cloud. Feel free to use any distribution you like.
>NOTE: Minimum requirements for virtual machines:

* 2 CPU
* 80 GB of storage space	

2. Please install the following packages:

* Docker Engine >= 18.04
* git
* curl

3. If working behind a corporate proxy, make sure you have set them up for docker and git

* [Instructions for Docker](https://docs.docker.com/network/proxy/)

4. After a fresh installation, docker will only work if run as root. If that is the case, please follow the [Post-Installation Instructions](https://docs.docker.com/engine/install/linux-postinstall/).

## Workshop resources

We have created a script for setting up your environment and fetching all resources you will need for this workshop.
If you haven't already, please go ahead and clone this repository in a known path.

```bash
git clone https://github.com/DnPlas/stacks-usecase.git --branch dplascen/stacks-workshop
```

Once the `stacks-usecase` is cloned, please run the `workshop.sh` script. Please note this script should be run from within `stacks-usecase/stacks-workshop` to work properly.

>NOTE: The script will also check your Docker configuration, if prompted with warning or error messages, please try to solve them referring to [Docker's official documentation](https://docs.docker.com/)
