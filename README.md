# OVERVIEW

This project contains the work attempting to reproduce Github Actions builds locally
for the OpenNMS Horizon Stream project.

# STATUS

Currently this project contains the following:

* WARNING: the `full-build.sh` script is out-of-date with changes to the Horizon Stream repository
  * The `install-local.sh` script has moved
  * There may be other incompatible changes
* Docker image that
  * nests both containerd and dockerd (WARNING - this container MUST be run in privileged mode)
  * contains all of the tools needed by the pipeline actions (see install-local.sh in the project)
* A build script to do the same work as the github actions (WARNING - this needs to be manually updated to keep parity with changes to the github workflows & actions)
* Usage Instructions
* The full process here involves a few manual steps; more work is needed to fully automate it


# WHY PRIVILEGED

Running Docker-in-Docker with an embedded containerd and dockerd,
requires privileged mode in order to work properly.
Docker needs access to host device nodes (entries under /dev) AND/OR
it needs privileged access to properly setup layered mounts.

Here is a related topic on Stack Overflow:

  https://stackoverflow.com/questions/29612463/can-i-run-docker-in-docker-without-using-the-privileged-flag


# BUILD

    $ docker build -t pipeline-local-docker-runner .


# RUN

    $ docker container create --name pldr --privileged --mount type=bind,source=$HOME/.m2,target=/root/.m2 pipeline-local-docker-runner
    $ docker start pldr
    $ docker cp full-build.sh pldr:/full-build.sh
    $ docker exec -it pldr /bin/bash

        $$ mkdir BUILD
        $$ cd BUILD
        $$ git clone https://github.com/OpenNMS/horizon-stream.git
        $$ cd horizon-stream/

        $$ /full-build.sh
