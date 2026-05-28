FROM python:3.11-slim

# Install Java (needed by EvoChecker), git (for PySMT), and build tools
RUN apt-get update && apt-get install -y \
    openjdk-17-jre \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*
#Note: ENHSP was compiled for Java 17 

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
RUN sed -i '/^PySMT/d; /^tempest/d' src/arch/requirements.txt && \
    pip install --no-cache-dir -r src/arch/requirements.txt

# Install PySMT Z3 solver
RUN pysmt-install --z3 --confirm-agreement

# Update config.ini with Docker paths
# sed -i: in-place editing of files
# 's|HP_PATH = .*|HP_PATH = /app/src|': replaces any HP_PATH value with /app/src (| used as delimiter)
# src/config.ini: target config file
RUN sed -i 's|HP_PATH = .*|HP_PATH = /app/src|' config.ini

# Set runtime library path for EvoChecker (PRISM Linux .so files)
ENV LD_LIBRARY_PATH=/app/src/arch/apps/EvoChecker/libs/runtime

EXPOSE 8001

WORKDIR /app/src
CMD ["fastapi", "run", "main_arch.py", "--port", "8001", "--host", "0.0.0.0"]
