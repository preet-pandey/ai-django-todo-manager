# AI-Powered Smart Task & Productivity Manager

A production-ready backend project built with FastAPI, SQLAlchemy, and JWT auth. Includes AI-assisted task priority suggestions and Pytest unit tests.

## Features
- FastAPI application with health check and centralized configuration
- Secure authentication (signup/login) with password hashing and JWT
- Task management: create, read, update, delete tasks
- AI-assisted priority suggestions based on description and deadlines
- SQLAlchemy ORM with SQLite (extensible to PostgreSQL)
- Pydantic schemas for validation and responses
- Proper error handling and clean JSON responses
- Pytest unit tests for auth and tasks

## Tech Stack
- Python 3.10+
- FastAPI
- SQLAlchemy
- SQLite (extensible to PostgreSQL)
- JWT (python-jose)
- Pytest

## Project Structure
```
app/
  core/
    config.py         # Centralized configuration using pydantic-settings
    security.py       # Password hashing and JWT utilities
    exceptions.py     # Custom exception handlers
  db/
    base.py           # Declarative base
    session.py        # Engine and SessionLocal with dependency get_db
  models/
    user.py           # User model
    task.py           # Task model with relationship to User
  services/
    ai.py             # Simple AI service for priority suggestion
  schemas/
    user.py           # User-related Pydantic models
    task.py           # Task-related Pydantic models
    token.py          # Token response schema
  api/
    deps.py           # Dependencies like get_current_user
    routes/
      auth.py         # Auth endpoints
      tasks.py        # Task endpoints
  main.py             # FastAPI app factory, routers, health check

requirements.txt
README.md
```

## Setup
1. Create a virtual environment and install dependencies:
   ```bash
   python -m venv .venv
   .venv\Scripts\activate
   pip install -r requirements.txt
   ```
2. Set environment variables (optional but recommended):
   - APP_SECRET_KEY: Change from default
   - APP_DATABASE_URL: e.g. `sqlite:///./data.db` or PostgreSQL URL
3. Run the app locally:
   ```bash
   uvicorn app.main:app --reload
   ```

## API Endpoints
- `GET /health`
- `POST /auth/signup`
- `POST /auth/login`
- `POST /tasks/`
- `GET /tasks/`
- `GET /tasks/{task_id}`
- `PUT /tasks/{task_id}`
- `DELETE /tasks/{task_id}`

## AI Usage
The AI service is modular and currently uses simple rule-based logic to suggest task priority based on keywords and deadline proximity. You can later swap it with a more advanced LLM or ML model. Trae AI was used as a coding assistant to build this project efficiently and reliably.

## Testing
Run tests with:
```bash
pytest -q
```

## Extending to PostgreSQL
- Set `APP_DATABASE_URL` to your PostgreSQL connection string.
- Prefer using migrations (Alembic) for production instead of `Base.metadata.create_all()`.

## Security Best Practices
- Always set a strong APP_SECRET_KEY via environment variables in production.
- Validate inputs via Pydantic schemas, avoid exposing sensitive info in responses/logs.
- Use short-lived JWTs and HTTPS in production.