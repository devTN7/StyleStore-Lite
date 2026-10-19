"""Application entry point — FastAPI app assembly.

This file only WIRES things together:
- create the FastAPI app (with settings),
- mount routers.

No business logic here: endpoints live in app/api, config in app/core.
"""

from fastapi import FastAPI

from app.api import health
from app.api.v1.router import router as v1_router
from app.core.config import get_settings

settings = get_settings()

# The FastAPI application object. `title` shows up in /docs and /openapi.json.
app = FastAPI(
    title=settings.APP_NAME,
)

# Health check at the root level: GET /health
app.include_router(health.router)

# All versioned endpoints live under: /api/v1/...
# The prefix is declared exactly once, here.
app.include_router(v1_router, prefix="/api/v1")
