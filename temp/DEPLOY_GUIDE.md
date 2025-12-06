# 🚀 Руководство по развёртыванию

## Быстрый старт

```bash
cd /home/hulumulumulus/service-oriented-architecture-itmo
bash start.sh
```

Скрипт автоматически:
- ✅ Останавливает все запущенные сервисы
- ✅ Создаёт чистый домен Payara
- ✅ Собирает все проекты (movie-service, oscar-service, frontend)
- ✅ Запускает 2 инстанса movie-service (9003, 9004)
- ✅ Развёртывает oscar-service на 2 инстанса Payara (9001, 9002)
- ✅ Создаёт application references

## Проверка работы

```bash
# Проверка oscar-service инстансов
bash check-oscar.sh

# Тестирование API
curl -X POST http://127.0.0.1:8080/service2/oscar/directors/get-loosers \
  -H "Content-Type: application/json"

curl -X POST http://127.0.0.1:8080/service2/oscar/directors/humiliate-by-genre/COMEDY \
  -H "Content-Type: application/json"
```

## Архитектура

```
Client
  ↓
Nginx:8443 (HTTPS) → HAProxy:8080
                        ├→ movie-service (Consul SD)
                        │   ├→ instance1:9003
                        │   └→ instance2:9004
                        │
                        └→ oscar-service
                            ├→ instance1:9001 (Payara)
                            └→ instance2:9002 (Payara)
                                ↓
                        Вызывает movie-service через HAProxy
```

## Полезные команды

```bash
# Просмотр логов Payara
tail -f payara/payara6/glassfish/domains/domain1/logs/server.log

# Просмотр логов movie-service
tail -f /tmp/movie-service-9003.log
tail -f /tmp/movie-service-9004.log

# Статус Payara instances
payara/payara6/bin/asadmin list-instances

# Остановка всех сервисов
pkill -f movie-service-1.0.0.jar
payara/payara6/bin/asadmin stop-domain domain1
```

## Изменённые файлы

1. `start.sh` - улучшен cleanup и убран git pull
2. `oscar-service/oscar-service-ejb/src/main/resources/application.properties` - URL movie-service через HAProxy
3. `oscar-service/oscar-service-ejb/src/main/java/ru/itmo/soa/oscar/service/OscarServiceBean.java` - пути к internal API
4. `movie-service/src/main/resources/application-movie1.yml` - service-id для Consul
5. `movie-service/src/main/resources/application-movie2.yml` - service-id для Consul
6. `/etc/haproxy/haproxy.cfg` - добавлен backend для oscar-service
7. `/etc/nginx/sites-available/default` - proxy_pass через HAProxy

## Endpoints

### Movie Service
- Health: `http://127.0.0.1:8080/service1/actuator/health`
- Swagger: `http://localhost:9003/service1/swagger-ui.html`

### Oscar Service  
- Via HAProxy: `http://127.0.0.1:8080/service2/oscar/...`
- Via Nginx: `https://localhost:8443/oscar/...`
- Swagger: `http://localhost:9001/service2/swagger-ui`

