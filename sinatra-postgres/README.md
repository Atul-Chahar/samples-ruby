# Sample Application with Sinatra + PostgreSQL

This is a sample Ruby application demonstrating how to use Keploy with **Sinatra** and **PostgreSQL**.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed.
- [Keploy](https://keploy.io) installed.

## Setup & Running

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/sinatra-postgres.git
cd sinatra-postgres
```

### 2. Using Docker Compose (Recommended)

```bash
docker-compose up --build
```

The application will be available at `http://localhost:4567`.

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Health check |
| `/users` | POST | Create a user |
| `/users` | GET | List all users |
| `/users/:id` | GET | Get user by ID |
| `/users/:id` | DELETE | Delete user |

## Testing with cURL

```bash
# Health check
curl http://localhost:4567/

# Create user
curl -X POST http://localhost:4567/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'

# List users
curl http://localhost:4567/users

# Get user
curl http://localhost:4567/users/1

# Delete user
curl -X DELETE http://localhost:4567/users/1
```

## Keploy Integration

### Record

```bash
keploy record -c "docker-compose up" --containerName "sinatra-app"
```

Then run the test script:
```bash
./test_routes.sh
```

### Test

```bash
keploy test -c "docker-compose up" --containerName "sinatra-app" --delay 10
```

## Project Structure

- `app.rb` - Main Sinatra application
- `Gemfile` - Ruby dependencies
- `Dockerfile` - Docker build configuration
- `docker-compose.yml` - Services configuration
- `test_routes.sh` - Helper script for API testing
