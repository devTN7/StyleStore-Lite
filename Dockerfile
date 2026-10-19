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

# --- 4. Copy source code BEFORE install --------------------------------------
# NOTE on ordering: the project uses an EDITABLE install (`pip install -e`).
# Editable install does NOT copy our code into site-packages; it writes a
# "finder" that maps the `app` package to its on-disk location. If `app/`
# does not exist yet when pip runs, the mapping is EMPTY and `import app`
# only works by accident (cwd on sys.path) — fragile.
# So for editable installs the source must exist BEFORE `pip install -e`.
# Trade-off: editing source code invalidates this install layer, so builds
# take slightly longer than the "copy config first" pattern (which suits
# non-editable installs). Correctness > micro-optimizing dev builds here.
COPY pyproject.toml README.md ./
COPY app ./app
COPY tests ./tests

# --- 5. Install project + dependencies ---------------------------------------
# -e (editable): import resolves to the live files on disk, so the bind mount
#                and uvicorn --reload work in development.
# ".[dev]"     : runtime deps + the `dev` extras (pytest, httpx).
RUN pip install --no-cache-dir -e ".[dev]"

# --- 6. Default command ------------------------------------------------------
# What runs when the container starts without an explicit command.
# (compose.yaml overrides this with --reload for development.)
# 0.0.0.0 = listen on all interfaces, required to be reachable from outside
# the container. "app.main:app" means: file app/main.py, variable `app`.
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
