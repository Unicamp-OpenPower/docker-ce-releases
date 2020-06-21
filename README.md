# Docker-CE Release Builds for Power

This repository contains the necessary files to create a build of the latest stable version of [docker-ce](https://github.com/docker/docker-ce) for PowerPC architecture. The current builded releases for power can be found in the [OpenPOWER@UNICAMP](https://openpower.ic.unicamp.br/) laboratory [FTP server](https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/).

## Repository Description

* `build.sh` - Used to execute the building process and send packages to the FTP server.
* `ftp_version.py`- Fetches the latest version built and available in the FTP server.
* `patch.py` - Automates the patching process of some dependencies utilized by docker-ce.
* `.travis.yml` - Deprecated file utilized in the original *Travis* build environment.
* `patches/` - Deprecated patching method using UNIX mailbox format files (replaced by `patch.py`).

## Getting Started

The script handles most of the details necessary for the build to be executed, there are, however, some hardware and software specification that should be taken in account.

### Necessary Specifications

The build process will not be able to execute if there's less than 2GB in the host machine. Ensure thate there's at least 2 GigaBytes of avalable memory for the build process, a host with 4GB of ram should suffice.

### Prerequisites

*NOTE: This build was created for and tested only on Ubuntu 18 and later versions*

The script uses `python3` to modify some dependencies within the docker-ce repository files in order to use open source packeages, it also uses other minor packages such as as a `git` and `make` commands which need to be installed in the linux machine being used.

#### Installing Docker

The main and most complicate depency to build the package it actually docker itself. The `docker-ce` build uses a docker client to facilitate the build process with containers. Installing a docker cliente on power is not a complicated task, though there are some anoying depedencies to find for power systems, to facilitate the process an [installation script](https://github.com/Unicamp-OpenPower/docker-ce-installation) was created. Be cautious when using it, as it was not tested on all operating systems and requires privileged access to be excuted. 

```
sudo apt install make git python3
git clone https://github.com/Unicamp-OpenPower/docker-ce-installation
sudo bash docker-ce-installation/install-docker
```

#### FTP Access

At the end of the build process, the building script will submit the built packages to the [FTP server](https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/), and to do so it requires proper authentication. These must be definde as evironment variables `$USER` and `$PASS`.


## Building

With the environment set, simply fetch this repository and execute the `build.sh` script to begin the build process.

```
git clone https://github.com/Unicamp-OpenPower/docker-ce-releases
cd docker-ce-releases
sudo bash build.sh
```


## Authors

* **Gustavo Salibi** - *Original Creator* - [gsalibi](https://github.com/gsalibi)
* **Vinicius Espindola** - *Old Maintener* - [sitio-couto](https://github.com/sitio-couto)

