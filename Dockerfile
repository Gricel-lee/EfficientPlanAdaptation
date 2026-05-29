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
COPY src/ ./src/
COPY config.ini ./ 

# Download EvoChecker (evoCheckerJar branch includes the jar + Linux .so runtime libs)
RUN git clone --depth 1 --branch evoCheckerJar \
    https://github.com/gerasimou/EvoChecker.git \
    src/arch/apps/EvoChecker && \
    chmod +x src/arch/apps/EvoChecker/EvoChecker-1.1.0.jar && \
    cp -r src/arch/apps/EvoChecker/libs src/libs

# Install tempest first so it pulls the pysmt version it requires
RUN pip install --no-cache-dir src/arch/apps/tempest/

# Install remaining requirements without tempest and conflicting pysmt (installed by tempest)
# Explanation of sed command:
# /^PySMT/d — delete lines starting with PySMT
# /^tempest/d — delete lines starting with tempest
# /^\.\/apps\/tempest/d — delete lines starting with ./apps/tempest
RUN sed -i '/^PySMT/d; /^tempest/d; /^\.\/apps\/tempest/d' src/arch/requirements.txt && \
    pip install --no-cache-dir -r src/arch/requirements.txt

# Install PySMT Z3 solver
RUN pysmt-install --z3 --confirm-agreement

# Replace in config.ini the Docker paths
# Explanation of sed command:
#   sed -i: in-place editing of files
#   's|HP_PATH = .*|HP_PATH = /app/src|': replaces any HP_PATH value with /app/src (| used as delimiter)
#   src/config.ini: target config file
# RUN sed -i 's|HP_PATH = .*|HP_PATH = /app/src|' config.ini

# Set paths for Docker environment
ENV HP_PATH=/app/src
ENV LD_LIBRARY_PATH=/app/src/arch/apps/EvoChecker/libs/runtime

EXPOSE 8001

WORKDIR /app/src
CMD ["fastapi", "run", "main_arch.py", "--port", "8001", "--host", "0.0.0.0"]
