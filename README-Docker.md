# Run ARCH as a Docker 

ARCH contains a Dockerfile to ease deployment and running the application. It is tested in Ubuntu distributions.

**NOTE**: So far, the UI requires the JSON file to be searched in "Select a Different File", and files generated are ONLY saved in the container. To see the files ```sudo docker exec -it arch bash``` after running the container.


## Prerequerements

- Docker installed
```sudo snap install docker```

## Run ARCH

1. To build and run the Dockerfile

```bash
cd EfficientPlanAdaptation/ && sudo docker build -t arch-planner . && cd src/ && sudo docker run -p 8001:8001 -v $(pwd)/assets:/app/src/assets --name arch arch-planner
```

This command joins:

  1.1 Build the image (required only once):
  ```sudo docker build -t arch-planner .```

  1.2. Run the container ```cd src/ && sudo docker run -p 8001:8001 -v $(pwd)/assets:/app/src/assets --name arch arch-planner```
  
  where:
  - `sudo docker run` — creates and starts a new container
  - `-p 8001:8001` — maps port 8001 from container to host machine where RESTAPI is running
  - `-v $(pwd)/assets:/app/src/assets` — mounts local assets folder into container. The `assets/` folder (containing JSON planning problems) is not baked into the Docker image (can be by adding `COPY assets/planningProblem ./assets/planningProblem` in Dockerfile). Instead, mount it at runtime using a **volume bind mount** (`-v`), which maps a folder from your host machine into the container:
  - `--name arch` -- add a name to the container created from a Docker image.
  - `arch-planner` — the Docker image (see Dockerfile file)



  2. Access the app at http://localhost:8001 or the API docs at
  http://localhost:8001/docs


# Developer notes

- If the Docker changes, rebuild the image (see 1.1).

#### Error
Remember to add sudo or error ```permission denied while trying to connect to the docker API at unix:///var/run/docker.sock``` might appear.

#### Container name
To find the container name:
  
```sudo docker ps```

#### Access files

While the container is running you can open a shell inside it:
```sudo docker exec -it arch bash```
