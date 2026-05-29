# Run ARCH as a Docker 

ARCH contains a Dockerfile to ease deployment and running the application. It is tested in Ubuntu distributions.

**NOTE**: The UI requires the JSON file to be selected via "Select a Different File". Output data (EvoChecker results, temp files) is written to `output/data/` and `output/temp/` on the host via bind mounts.


## Prerequirements

- Docker installed
```sudo snap install docker```

## Build Docker "arch-planner"
Build the image (required only once) from the directory containing the Dockerfile:

```sudo docker build -t arch-planner .```

## Run container
If it is already running, first stop the previous run by ```sudo docker rm arch```.
1. To build and run the Dockerfile (run from the project root).

```bash
    sudo docker run --rm -p 8001:8001 \
    --mount type=bind,src=$(pwd)/assets,dst=/app/assets \
    --mount type=bind,src=$(pwd)/output/data,dst=/app/src/data,bind-create-src \
    --mount type=bind,src=$(pwd)/output/temp,dst=/app/temp,bind-create-src \
    --name arch arch-planner
```

Explanation:
  - `sudo docker run` — creates and starts a new container
  - ```--rm``` — the docker container is automatically removed when it stops, so it won't hit a name conflict.
  - `-p 8001:8001` — maps port 8001 from container to host machine where RESTAPI is running
  - `-v $(pwd)/assets:/app/src/assets` — mounts the `assets/` folder (containing JSON planning problems) from the host into the container at runtime. It is not baked into the image so that problems can be added without rebuilding.
  - `--name arch` — name for the container.
  - `arch-planner` — the Docker image name (see Dockerfile)



2. Access the app at http://localhost:8001 with API docs at http://localhost:8001/docs


3. After running a planning problem, the generated files will be saved in ```/app/temp```


# Developer notes

#### Container name
To find the container name:
  
```sudo docker ps```

- If the Docker changes, rebuild the image.

## Re-build 
When changes to the docker project run:
```
sudo docker build -t arch-planner .
```

## To remove 
To remove all docker containers:
```
sudo docker system prune -a
```


# Q&A

#### Error
Remember to add sudo or error ***permission denied while trying to connect to the docker API at unix:///var/run/docker.sock*** might appear.


#### Error or to remove an already created container 
Error: docker: **Error response from daemon: Conflict. The container name "/arch" is already in use by container**

If a container named arch was already created, first delete it to create a new one:

```sudo docker rm arch```

#### Access files

While the container is running you can open a shell inside it:
```sudo docker exec -it arch bash```
 