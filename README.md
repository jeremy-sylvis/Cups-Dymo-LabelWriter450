# Overview

[![Static-Analysis](https://github.com/jeremy-sylvis/Cups_Dymo-LabelWriter450/actions/workflows/Static%20Analysis.yaml/badge.svg)](https://github.com/jeremy-sylvis/Cups_Dymo-LabelWriter450/actions/workflows/Static%20Analysis.yaml)
[![Build](https://github.com/jeremy-sylvis/Cups_Dymo-LabelWriter450/actions/workflows/Build.yaml/badge.svg)](https://github.com/jeremy-sylvis/Cups_Dymo-LabelWriter450/actions/workflows/Build.yaml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

![Languages and Tools](docs/Languages%20And%20Tools.png)

## This Product

This product makes the Dymo LabelWriter 450 available as a network printer by configuring and exposing a CUPS print server via container, complete with drivers for consuming devices.

### Solution Design

This is the high-level design of the solution provided by this container image:

![Architecture diagram](docs/Architecture.png)

The key parts are as follows:

- Container host (e.g. Raspberry Pi Zero W): Runs the container image which provides a CUPS-based print server.

- Dymo LabelWriter 450: The printer being made available via network, connected to the container host via USB.

- Print client (e.g. Windows or Linux PC): Print clients connect to the container host via LAN.

### Container Image

The container image is performs full installation when the container starts. 

As long as the Dymo Labelwriter 450 is accessible to the container environment, the container should immediately attach this printer to CUPS and set it to the default printer.

### Installation

The best way to installing this is to use the included [dockerfile](Dockerfile), which will build the image and run a container from the resulting image.

#### Example Installation: Raspberry Pi Zero W

1. Clone the repository to the Raspberry Pi Zero W.
2. Run the following command to build the image and run the container, using the docker-compose.yml file, the --build will force the building of the container using the Dockerfile:

    ```bash
    docker-compose up -d --build
    ```

3. The container should now be running and the printer should be available on the network.
4. To check that the container is running, run the following command:

```bash
docker ps
```

## Continuous Integration Pipelines

Within this repository, there are two workflows:

- Static Analysis: This performs Linting on all the main filetypes of this repository such as Dockerfiles, Markdown files and Shell Scripts.

- Build: This performs the building of the Docker Image ensuring that it can be built. This is done using a Self-hosted GitHub Runner.

## Useful Links

This project was inspired by lots of other repositories and open-source projects, which are linked below:

- [Dymo LabelWriter 450](https://www.dymo.com/label-makers-printers/labelwriter-label-printers/dymo-labelwriter-450-direct-thermal-label-printer/SP_95488.html)

- [CUPS](https://ubuntu.com/server/docs/service-cups)

- [Install Dymo LabelWriter on Headless Linux](https://www.baitando.com/it/2017/12/12/install-dymo-labelwriter-on-headless-linux)

- [CUPS Dockerfile](https://github.com/olbat/dockerfiles/tree/master/cupsd)

- [Windows 10 and CUPS](https://techblog.paalijarvi.fi/2020/05/25/making-windows-10-to-print-to-a-cups-printer-over-the-network/)
