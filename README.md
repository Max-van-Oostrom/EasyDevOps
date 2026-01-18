# EasyDevOps

Een .NET 10 console applicatie met Docker ondersteuning.

## Vereisten

- [Git](https://git-scm.com/) geïnstalleerd
- [Docker](https://www.docker.com/products/docker-desktop/) geïnstalleerd

## Aan de slag (Ubuntu/Linux)

```bash
# Clone de repository
git clone https://github.com/max-van-oostrom/EasyDevOps.git

# Ga naar de project folder
cd EasyDevOps

# Start de applicatie met Docker
docker compose up --build
```

## Docker Gebruiken

### Bouwen en draaien

```bash
docker compose up --build
```

### Stoppen

```bash
docker compose down
```

### Alleen bouwen (zonder draaien)

```bash
docker compose build
```

## docker-compose.yml

```yaml
services:
  easydevops:
    build:
      context: ./frontend/ConsoleApp1
      dockerfile: Dockerfile
    image: easydevops:latest
```

## Scripts

Bekijk de `scripts/` folder voor installatie scripts.
