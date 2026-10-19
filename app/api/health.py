"""Health Check endpoint.

Lives OUTSIDE /api/v1 on purpose: infrastructure tools (load balancers,
orchestrators) probe this URL, so it shouldn't change when the API version
changes. It's an infrastructure concern, not a versioned API feature.
"""

from fastapi import APIRouter

router = APIRouter(tags=["health"])


@router.get("/health")
def health_check() -> dict[str, str]:
    """Liveness probe: is the API process up and responding?

    Returns HTTP 200 with {"status": "ok"}.
    FastAPI serializes the returned dict to JSON automatically.
    """
    return {"status": "ok"}
