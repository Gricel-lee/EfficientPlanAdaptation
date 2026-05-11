FROM python:3.11-slim

# Install Java (needed by EvoChecker), git (for PySMT), and build tools
RUN apt-get update && apt-get install -y \
    default-jre \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy project
COPY src/ ./src/

# Fix tempest path in requirements.txt for the Docker environment
RUN sed -i 's|tempest @ file:///.*|tempest @ file:///app/src/arch/apps/tempest|' src/arch/requirements.txt

# Install Python dependencies (no venv needed in Docker)
RUN pip install --no-cache-dir -r src/arch/requirements.txt

# Install tempest explicitly
RUN pip install --no-cache-dir src/arch/apps/tempest/

# Install PySMT Z3 solver
RUN pysmt-install --z3 --confirm-agreement

# Update config.ini with Docker paths
RUN sed -i 's|HP_PATH = .*|HP_PATH = /app/src|' src/config.ini

# Set runtime library path for EvoChecker (PRISM Linux .so files)
ENV LD_LIBRARY_PATH=/app/src/arch/apps/EvoChecker/libs/runtime

EXPOSE 8001

WORKDIR /app/src
CMD ["fastapi", "run", "main_arch.py", "--port", "8001", "--host", "0.0.0.0"]
