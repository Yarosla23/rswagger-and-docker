# API задание

## запуск

```bash
docker compose up --build
```

При старте контейнера `web` приложение автоматически:

- ждёт готовности PostgreSQL
- выполняет `rails db:prepare`
- поднимает Rails-сервер на `http://localhost:3000`

## Тестинг приложения через rswagger

```bash
http://localhost:3000/api-docs
```
