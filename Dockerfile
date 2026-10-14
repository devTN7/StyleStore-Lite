# =============================================================================
# Dockerfile — recipe to build the StyleStore Lite API image.
#
# Docker builds an image layer by layer. Each instruction creates a layer.
# Layers are cached: if nothing changed for an instruction (and all before it),
# Docker reuses the cached layer. That's why we order instructions from
# "changes rarely" (base image, dependencies) to "changes often" (source code).
# =============================================================================

# --- 1. Base image -----------------------------------------------------------
# python:3.12-slim = official Python 3.12 on a minimal Debian.
# "slim" keeps the image small (~120MB vs ~1GB for the full image).
FROM python:3.12-slim

# --- 2. Environment settings -------------------------------------------------
# PYTHONDONTWRITEBYTECODE: no .pyc files inside the container (keeps it clean).
# PYTHONUNBUFFERED: print logs immediately instead of buffering (better for
#                   `docker logs` and hot reload output).
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# --- 3. Working directory ----------------------------------------------------
# All following commands run inside /app in the container.
WORKDIR /app

# --- 4. Install dependencies (cache-friendly) --------------------------------
# We copy ONLY pyproject.toml first, then install. As long as dependencies
# don't change, this layer is cached — even when we edit source code daily.
# -e (editable): the project is installed as a link, not a copy, so the
#                bind-mounted source code is used at runtime + hot reload works.
# ".[dev]"     : install runtime deps + the `dev` extras (pytest, httpx).
COPY pyproject.toml README.md ./
RUN pip install --no-cache-dir -e ".[dev]"

# --- 5. Copy source code ------------------------------------------------------
# This layer changes almost every commit — that's why it comes last.
# Note: .dockerignore keeps .env, .git, caches... out of the build context.
COPY app ./app
COPY tests ./tests

# --- 6. Default command -------------------------------------------------------
# What runs when the container starts without an explicit command.
# (compose.yaml overrides this with --reload for development.)
# 0.0.0.0 = listen on all interfaces, required to be reachable from outside
# the container. "app.main:app" means: file app/main.py, variable `app`.
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
