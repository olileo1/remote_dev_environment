# About this Repo
This repo is here to provide a remote development environment that is based on:

* Anaconda (to code R and Python)
* Code Server (as an IDE)

The intention is to use the docker image that is created by the dockerfile inside a Google Compute Engine machine.

## About the Docker Image
The docker image is based on the Anaconda image providing the latest anaconda version. On top of that image we will install Visual Studio Code Server (https://github.com/cdr/code-server).
Visual Studio Code Server is basically Visual Studio Code as WebApplication.

Further I will just set my personal git configuration and already create conda environments I will use often.

## How to Build the Image and Push into the Container Registry
The first step is to create the docker image using the following command (Note: You have to be in the directory containing the Dockerfile)

```console
docker build -t gcr.io/my-remote-dev-machine/code-server:1.4 .
```

## How to use the image

Starting a docker container using the previously build image can be done using the following command:

```console
docker run -p 8080:8080 -p 8888:8888 -v /mnt/path/:/home/projects/ gcr.io/my-remote-dev-machine/code-server:1.4
```

We use the following docker run options.

* -p 8080:8080: this will forward the port 8080 since code server listens to port 8080
* -p 8888:8888: this will forward the port 8888 since jupyter notebook normally listens to port 8888 (Jupyter Notebook can be startet from the Code Server Web Application)
* -v /mnt/path/:/home/projects/: to work with your projects we can mount a folder onto /home/projects. Please note that the docker user should have read/write rights onto that folder

Once the container is running we can use the code server web application in the browser by going to localhost:8080. Inside the container we are root user, since I don't see a reason why in this container we shouldn't be.

### Clone a repository
It is recommended to cloen repositories from github using https and a personal access token. The personal access token should have repo and workflow permissions.

### Start jupyter notebook
It is possible to further start a jupyter notebook server this can be done with the following command:

```console
jupyter notebook --port=8888 --no-browser --ip=0.0.0.0 --NotebookApp.token='' --NotebookApp.password='' --allow-root
```

Please note, that we removed all the access and authentification measures. We did this, because we assume anyways that ONLY authorized users have access to a running container. Since the main usage for the container is to be run on a Google Cloud Compute Engine VM, that only allows SSH connections, these reduced security measures for Code Server and Jupyter Notebooks are bearable.

## How to push the Image to the GCR
This command will build the Docker image with the tage "1.4". Note that gcr.io is the Google Cloud Container Registry. Since we are going to push our image to that Container Registry, we need to have this registry added to our docker config (see https://cloud.google.com/container-registry/docs/advanced-authentication#windows).

Once the image is created we can push it into the Google Cloud Registry using:

```console
docker push -t gcr.io/my-remote-dev-machine/code-server:1.4
```

## How to create the Google Cloud Compute Engine using the Image

The following settings should be set.

* Machine with at least 2GB RAM
* Persistent SSD disk with 32GB Storage
* Use start-up script that creates the folder "/home/projects" with very open read-write restrictions
* Advanced Docker Options: Mount folder "/home/projects" to "/home/projects"
* Do not allow HTTP and HTTPS settings, we only want SSH connections
* Add SSH keys that are allowed to connect


