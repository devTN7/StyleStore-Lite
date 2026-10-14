# StyleStore Lite

A clothing e-commerce backend built for learning Backend Engineering with Python.
Focused on a clean **Layered Architecture** to serve as a portfolio project.

## Tech Stack (planned)

- Python 3.12
- FastAPI
- PostgreSQL (SQLAlchemy Async + Alembic)
- Redis
- Docker Compose (everything runs in containers — no host installs)
- pytest

## Project Structure

```
app/
├── main.py            # Application entry point (FastAPI setup comes later)
├── api/v1/            # HTTP layer: routers & endpoints (versioned API)
├── core/              # Configuration, security, shared utilities
├── db/                # Database engine, async session, base
├── models/            # SQLAlchemy ORM models (database tables)
├── schemas/           # Pydantic models (request/response validation)
├── repositories/      # Data access layer (DB queries)
└── services/          # Business logic layer
tests/                 # pytest test suite
```

## Request Flow

```
Client → api (router) → services (business logic) → repositories (data access) → db (PostgreSQL)
```

## Installing Dependencies (inside Docker, in a later step)

```bash
pip install -e ".[dev]"
```
