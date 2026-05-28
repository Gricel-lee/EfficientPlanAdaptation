# Run ARCH as a Docker 

ARCH contains a Dockerfile to ease deployment and running the application. It is tested in Ubuntu distributions.

**NOTE**: The UI requires the JSON file to be selected via "Select a Different File". Output data (EvoChecker results, temp files) is written to `output/data/` and `output/temp/` on the host via bind mounts.


## Prerequerements

- Docker installed
```sudo snap install docker```

## Run ARCH

1. To build and run the Dockerfile (run from the project root):
```bash
  sudo docker run -p 8001:8001 \
    -v $(pwd)/assets:/app/src/assets \
    --mount type=bind,src=$(pwd)/output/data,dst=/app/src/data,bind-create-src \
    --mount type=bind,src=$(pwd)/output/temp,dst=/app/temp,bind-create-src \
    --name arch arch-planner
```

This command joins:

  1.1 Build the image (required only once):
  ```sudo docker build -t arch-planner .```

  1.2. Run the container (from the project root):
  ```sudo docker run -p 8001:8001 -v $(pwd)/assets:/app/src/assets --name arch arch-planner```
  
  where:
  - `sudo docker run` — creates and starts a new container
  - `-p 8001:8001` — maps port 8001 from container to host machine where RESTAPI is running
  - `-v $(pwd)/assets:/app/src/assets` — mounts the `assets/` folder (containing JSON planning problems) from the host into the container at runtime. It is not baked into the image so that problems can be added without rebuilding.
  - `--name arch` — name for the container.
  - `arch-planner` — the Docker image name (see Dockerfile)



  2. Access the app at http://localhost:8001 or the API docs at
  http://localhost:8001/docs


# Developer notes

- If the Docker changes, rebuild the image (see 1.1).

#### Error
Remember to add sudo or error ***permission denied while trying to connect to the docker API at unix:///var/run/docker.sock*** might appear.

#### Container name
To find the container name:
  
```sudo docker ps```

#### Error or to remove an already created container 
Error: docker: **Error response from daemon: Conflict. The container name "/arch" is already in use by container**

If a container named arch was already created, first delete it to create a new one:

```sudo docker rm arch```

#### Access files

While the container is running you can open a shell inside it:
```sudo docker exec -it arch bash```
