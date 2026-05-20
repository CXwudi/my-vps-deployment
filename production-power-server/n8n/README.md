# n8n Workflow Automation

Queue-mode deployment with dedicated worker for scalable workflow execution.

## Architecture

- **n8n-main**: UI, API, and webhooks
- **n8n-worker**: Workflow execution (concurrency: 5)
- **n8n-runner-worker**: External task runner for executing Code nodes (paired with n8n-worker)
- **n8n-runner-main**: External task runner for executing Code nodes (paired with n8n-main)
- **postgres**: PostgreSQL 18 database for n8n itself
- **redis**: Redis 8 queue broker for n8n itself
- **workflow-postgres**: PostgreSQL 18 database for workflow-owned data
- **workflow-redis**: Redis 8 instance for workflow-owned data/cache

## Setup

1. Copy environment template:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and update all credentials:
   - `POSTGRES_PASSWORD`: Database password (auto-synced to `DB_POSTGRESDB_PASSWORD`)
   - `REDIS_PASSWORD`: Redis password (auto-synced to `QUEUE_BULL_REDIS_PASSWORD`)
   - `WORKFLOW_POSTGRES_PASSWORD`: Workflow PostgreSQL password
   - `WORKFLOW_REDIS_PASSWORD`: Workflow Redis password
   - Generate encryption keys with `openssl rand -base64 32`:
     - `N8N_ENCRYPTION_KEY`
     - `N8N_USER_MANAGEMENT_JWT_SECRET`
     - `N8N_RUNNERS_AUTH_TOKEN` (task runner authentication)

3. Start services:

   ```bash
   # Production
   just boot env=prod

   # Local development
   just boot env=local
   ```

## Access

- **Production**: <https://n8n.mikufancx.cyou>
- **Local**: <http://localhost:5678>

## Key Settings

- Execution data retention: 7 days (`EXECUTIONS_DATA_MAX_AGE=168`)
- Telemetry disabled
- Queue mode enabled for better scalability
- Task runners: External mode with Python support enabled

## Workflow Runtime Services

These services are available on the Docker network for workflows, but n8n does
not use them for its own database or queue configuration.

- PostgreSQL host: `workflow-postgres`, port: `5432`
- Redis host: `workflow-redis`, port: `6379`

Use the `WORKFLOW_POSTGRES_*` and `WORKFLOW_REDIS_PASSWORD` values from `.env`
when creating n8n credentials for workflows.

## Task Runners

Executes Code node JavaScript and Python in isolated containers (`n8n-runner-worker`, `n8n-runner-main`). Communicates via broker port 5679 using `N8N_RUNNERS_AUTH_TOKEN`. See [docs](https://docs.n8n.io/hosting/configuration/task-runners/).

### Custom Runner Configuration (`custom-n8n-task-runners.json`)

**Workaround:** The `NODE_FUNCTION_ALLOW_BUILTIN` and `N8N_RUNNERS_STDLIB_ALLOW` environment variables don't work.

**Changes from default:**

- JavaScript: `NODE_FUNCTION_ALLOW_BUILTIN: "*"` (was `"crypto"`)
- Python: `N8N_RUNNERS_STDLIB_ALLOW: "*"` (was `""`)

## Backup

Backups are written to the sibling `../n8n-backups` directory by default:

```bash
just backup
```

Backup these volumes regularly:

- `n8n-data`: Workflows and configurations
- `n8n-postgres-data`: n8n database
- `n8n-redis-data`: n8n queue data
- `n8n-workflow-postgres-data`: workflow-owned PostgreSQL data
- `n8n-workflow-redis-data`: workflow-owned Redis data

## Troubleshooting

```bash
# View logs
docker logs n8n-main
docker logs n8n-worker
docker logs n8n-runner-worker
docker logs n8n-runner-main
docker logs n8n-workflow-postgres
docker logs n8n-workflow-redis

# Health check
curl https://n8n.mikufancx.cyou/healthz
```
