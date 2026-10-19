"""Application settings loaded from environment variables.

Pydantic BaseSettings:
- Reads values from environment variables (and .env via compose env_file).
- Validates types automatically (e.g. APP_PORT would need to be an int).
- Falls back to the declared default when a variable is missing.

`extra="ignore"`: .env contains variables this class doesn't declare
(POSTGRES_* etc.). Without this, pydantic-settings would raise an error.
"""

from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        extra="ignore",
    )

    APP_NAME: str = "StyleStore Lite API"


@lru_cache
def get_settings() -> Settings:
    """Return a cached Settings instance.

    lru_cache = the object is created once and reused for every call,
    instead of re-reading the environment on each request.
    """
    return Settings()
