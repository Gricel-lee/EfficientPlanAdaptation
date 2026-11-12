FROM python:3.11-slim


RUN apt-get update 


# Install Java 17:  (needed by EvoChecker/ENHSP, which was compiled for Java 17)
# 1 check if Java 17 is already installed (e.g., by a base image)
# 2 if not, try installing openjdk-17-jdk from the default repos
# 3 if that fails (e.g., due to an older Debian version), add the Adoptium repository and install temurin-17-jdk
RUN java -version 2>&1 | grep -q "17" || \
    apt-get install -y openjdk-17-jdk || \
    (apt-get install -y --no-install-recommends wget gnupg && \
    mkdir -p /etc/apt/keyrings && \
    wget -qO /etc/apt/keyrings/adoptium.asc https://packages.adoptium.net/artifactory/api/gpg/key/public && \
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb bookworm main" \
        > /etc/apt/sources.list.d/adoptium.list && \
    apt-get update && apt-get install -y --no-install-recommends temurin-17-jdk && \
    rm -rf /var/lib/apt/lists/*)

# Install git (for PySMT), and build tools
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*



WORKDIR /app

# Copy project
COPY pyproject.toml README.md ./
COPY src/ ./src/
COPY config.ini ./ 

# Download EvoChecker (evoCheckerJar branch includes the jar + Linux .so runtime libs)
RUN git clone --depth 1 --branch evoCheckerJar \
    https://github.com/gerasimou/EvoChecker.git \
    src/arch_plan/apps/EvoChecker && \
    chmod +x src/arch_plan/apps/EvoChecker/EvoChecker-1.1.0.jar && \
    cp -r src/arch_plan/apps/EvoChecker/libs src/libs

# Install tempest first so it pulls the pysmt version it requires
RUN pip install --no-cache-dir src/arch_plan/apps/tempest/

# Install ARCH and its dependencies (declared in pyproject.toml) in editable mode,
# so the code keeps running from /app/src
RUN pip install --no-cache-dir -e .

# Install PySMT Z3 solver
RUN pysmt-install --z3 --confirm-agreement

# Set the EvoChecker library path for the Docker environment
ENV LD_LIBRARY_PATH=/app/src/arch_plan/apps/EvoChecker/libs/runtime

EXPOSE 8001

WORKDIR /app/src
CMD ["fastapi", "run", "arch_plan/server.py", "--port", "8001", "--host", "0.0.0.0"]
