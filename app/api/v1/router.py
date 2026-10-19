"""API version 1 aggregate router.

All v1 feature routers (products, orders, auth... in later steps) will be
`include_router`-ed here. The prefix is declared ONCE in main.py when this
router is mounted, so individual feature routers never repeat `/api/v1`.
"""

from fastapi import APIRouter

router = APIRouter()

# Feature routers will be registered here in later steps, e.g.:
# from app.api.v1 import products
# router.include_router(products.router)
