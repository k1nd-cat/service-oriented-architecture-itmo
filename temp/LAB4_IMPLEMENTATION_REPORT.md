# Отчет о выполнении лабораторной работы №4
## Преобразование Oscar Service в SOAP и интеграция через Mule ESB

---

## 🎯 Цель лабораторной работы

1. **Преобразовать Oscar Service в SOAP протокол** - переписать REST API на SOAP (JAX-WS)
2. **Развернуть SOAP сервис на Payara** - без изменения movie-service
3. **Установить и настроить Mule ESB** - для интеграции сервисов
4. **Создать REST-прокси слой через Mule ESB** - предоставить REST API для клиентов, который проксирует запросы к SOAP сервису
5. **Настроить HAProxy и Nginx** - для балансировки нагрузки и проксирования запросов

---

## 🏗️ Архитектура решения

### Диаграмма деплоя

```
┌─────────────────────────────────────────────────────────────────┐
│                    🌐 Frontend (Flutter Web)                    │
└────────────────────────────┬────────────────────────────────────┘
                             │ HTTPS:8443
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    🔒 NGINX (Port 8443)                         │
│  • SSL Termination                                             │
│  • CORS Headers                                                │
├─────────────────────────────────────────────────────────────────┤
│  Routes:                                                       │
│  / ────────────────> Flutter Web App (static files)            │
│  /movies/* ────────> proxy_pass http://127.0.0.1:8080/...     │
│  /oscar/* ─────────> proxy_pass http://127.0.0.1:8081/...    │
└────────────────────────────┬────────────────────────────────────┘
                             │ HTTP
                             ▼
        ┌────────────────────┴────────────────────┐
        │                                         │
        ▼                                         ▼
┌──────────────────────┐            ┌──────────────────────┐
│  ⚖️  HAProxy (8080)  │            │  🔄 Mule ESB (8081)  │
│  Load Balancer       │            │  REST Proxy Layer    │
├──────────────────────┤            ├──────────────────────┤
│ Frontend: fe_movie   │            │ • REST → SOAP        │
│ • /service2 → oscar  │            │ • SOAP → REST        │
│ • default → movie    │            │ • DataWeave          │
├──────────────────────┤            └──────────┬───────────┘
│ Backends:            │                       │ HTTP:8080
│ • movie-service      │                       │ (via HAProxy)
│   (Consul DNS)       │                       │
│   - 9003, 9004       │                       ▼
│ • oscar-service      │            ┌──────────────────────┐
│   (Static)           │            │  ⚖️  HAProxy (8080)    │
│   - 9001, 9002       │            │  Load Balancer        │
└──────┬───────────────┘            │  Round-robin         │
       │                            └──────────┬───────────┘
       │                                       │
       ├───────────────┬───────────────┐       │
       │               │               │       │
       ▼               ▼               ▼       ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│ MOVIE-1     │ │ MOVIE-2     │ │ OSCAR-1     │ │ OSCAR-2     │
│ Port: 9003  │ │ Port: 9004  │ │ Port: 9001  │ │ Port: 9002  │
│             │ │             │ │             │ │             │
│ Spring Boot │ │ Spring Boot │ │ Payara      │ │ Payara      │
│ + Consul    │ │ + Consul    │ │ instance1   │ │ instance2   │
└──────┬──────┘ └──────┬──────┘ └──────┬──────┘ └──────┬──────┘
       │               │               │               │
       └───────────────┴───────────────┘               │
                   │                                   │
                   │ Register to Consul               │ Call via JNDI
                   │                                   │
                   ▼                                   ▼
         ┌─────────────────────┐            ┌─────────────────────┐
         │ 📡 CONSUL           │            │ 🔧 EJB POOL         │
         │ Port: 8500 (HTTP)   │            │ (Stateless)         │
         │ Port: 8600 (DNS)    │            ├─────────────────────┤
         ├─────────────────────┤            │ OscarServiceBean    │
         │ Service Discovery   │            │ @Remote interface   │
         │ • movie-service     │            └─────────────────────┘
         │   - instance 9003   │
         │   - instance 9004   │
         └─────────────────────┘
```

**Примечание:** Payara DAS работает на порту 8180 (не показан на диаграмме, используется только для администрирования).

### Поток запросов

#### 1. Запрос к Movie Service
```
Browser → Nginx (8443) → HAProxy (8080) → Movie Service (9003/9004)
```

#### 2. Запрос к Oscar Service
```
Browser → Nginx (8443) → Mule ESB (8081) → HAProxy (8080) → Oscar Service (9001/9002)
```

#### 3. Oscar Service вызывает Movie Service
```
Oscar Service → HAProxy (8080) → Movie Service (9003/9004)
```

---

## 📝 Основные изменения

### 1. Oscar Service - Преобразование в SOAP

#### Удалены REST компоненты:
- `OscarResource.java` - REST контроллер
- `OscarApplication.java` - JAX-RS Application
- `SwaggerUIResource.java` - Swagger UI
- `GenericExceptionMapper.java` - Exception mapper

#### Создан SOAP endpoint:
**Файл:** `oscar-service-web/src/main/java/ru/itmo/soa/oscar/web/soap/OscarSoapService.java`

- `@WebService` с namespace `http://soa.itmo.ru/oscar`
- `@BindingType(SOAPBinding.SOAP12HTTP_BINDING)` - SOAP 1.2
- Методы: `getDirectorsWithoutOscars()`, `humiliateDirectorsByGenre(String genre)`
- Локальный JNDI lookup для EJB: `java:global/oscar-service/.../OscarServiceBean!...`

#### Добавлены JAXB аннотации в DTO:
- `DirectorInfo.java` - `@XmlRootElement`, `@XmlType`, `@XmlElement`
- `HumiliateResponse.java` - аналогично
- `MovieGenre.java` - enum с JAXB

#### Изменения в конфигурации:
- `application.properties`: `movie.service.base.url=http://localhost:8080/service1/api/v1` (через HAProxy)
- `pom.xml`: удалены JAX-RS зависимости, добавлены JAXB
- `web.xml`: упрощен для автоматической публикации JAX-WS

### 2. Mule ESB - REST Proxy Layer

#### Конфигурация:
**Файл:** `muleesb/lab4/src/main/mule/lab4.xml`

- HTTP Listener на порту 8081
- HTTP Request к SOAP сервису через HAProxy (порт 8080)
- HTTP Request к Movie Service через HAProxy (порт 8080)
- DataWeave преобразования:
  - REST JSON → SOAP XML (для запросов)
  - SOAP XML → REST JSON (для ответов)

#### Flows:
1. `getDirectorsWithoutOscarsFlow` - POST `/service2/oscar/directors/get-loosers`
2. `humiliateDirectorsByGenreFlow` - POST `/service2/oscar/directors/humiliate-by-genre/{genre}`

#### Технические детали:
- Использован Mule Community Edition 4.6.0
- DataWeave выражения в `<set-payload>` (без `ee:transform`)
- Обработка XML namespaces и массивов в SOAP ответах

### 3. HAProxy - Load Balancer

**Конфигурация:** `/etc/haproxy/haproxy.cfg`

- Frontend на порту 8080
- Backend `movie-service`: балансировка через Consul DNS (порты 9003, 9004)
- Backend `oscar-service`: статическая конфигурация (порты 9001, 9002)
- Health checks для обоих бэкендов
- Round-robin балансировка

**Изменения в коде:**
- `oscar-service`: обращение к `movie-service` через `http://localhost:8080` (HAProxy)
- `muleesb`: обращение к SOAP сервису через `http://localhost:8080` (HAProxy)
- `muleesb`: обращение к Movie Service через `http://localhost:8080` (HAProxy)
- `nginx`: проксирование `/movies/*` на `http://127.0.0.1:8080` (HAProxy)
- `start.sh`: запуск HAProxy перед Payara, изменение порта Payara DAS на 8180

### 4. Nginx - Reverse Proxy

**Конфигурация:** `/etc/nginx/sites-available/default`

- `/oscar/*` → `http://127.0.0.1:8081/service2/oscar/` (Mule ESB)
- `/movies/*` → `http://127.0.0.1:8080/service1/api/v1/movies` (HAProxy)
- CORS headers для всех маршрутов

### 5. start.sh - Автоматизация деплоя

**Изменения:**
- Добавлена сборка Mule ESB приложения
- Добавлен запуск Mule ESB (порт 8081)
- Добавлен запуск HAProxy
- Освобождение порта 8080 перед запуском HAProxy
- Обновлен summary с информацией о HAProxy

---

## 🔧 Технические детали

### Порты сервисов

| Сервис | Порт | Протокол | Описание |
|--------|------|----------|----------|
| NGINX | 8443 | HTTPS | Frontend + API Gateway |
| HAProxy | 8080 | HTTP | Load Balancer |
| Mule ESB | 8081 | HTTP | REST Proxy Layer |
| Payara DAS | 8180 | HTTP | Domain Admin Server (admin only) |
| Movie-Service #1 | 9003 | HTTP | Spring Boot Instance 1 |
| Movie-Service #2 | 9004 | HTTP | Spring Boot Instance 2 |
| Oscar-Service #1 | 9001 | HTTP | Payara instance1 |
| Oscar-Service #2 | 9002 | HTTP | Payara instance2 |
| Consul HTTP | 8500 | HTTP | Service Registry API |
| Consul DNS | 8600 | DNS | Service Discovery DNS |
| Payara Admin | 4848 | HTTP | Admin Console |

### Протоколы и технологии

- **SOAP 1.2** - для Oscar Service (JAX-WS)
- **REST** - для Movie Service и Mule ESB Proxy
- **DataWeave 2.0** - для преобразования JSON ↔ XML
- **JAXB** - для сериализации Java объектов в XML
- **HAProxy** - для балансировки нагрузки
- **Consul** - для service discovery (Movie Service)
- **Mule ESB 4.6.0 CE** - для REST proxy layer

---

## ✅ Результаты тестирования

### Проверка HAProxy балансировки

```bash
# Movie Service через HAProxy
for i in {1..4}; do 
  curl -s http://localhost:8080/service1/actuator/health | jq -r .status
done

# Oscar Service через HAProxy
curl -X POST http://localhost:8080/service2/OscarSoapService \
  -H "Content-Type: application/soap+xml" \
  -d '<soap:Envelope>...</soap:Envelope>'
```

### Проверка Mule ESB REST Proxy

```bash
# Get Directors Without Oscars
curl -X POST http://localhost:8081/service2/oscar/directors/get-loosers \
  -H "Content-Type: application/json" \
  -d '{}'

# Humiliate Directors By Genre
curl -X POST http://localhost:8081/service2/oscar/directors/humiliate-by-genre/ACTION \
  -H "Content-Type: application/json" \
  -d '{}'
```

### Проверка через Nginx

```bash
# Movie Service
curl -k https://localhost:8443/movies

# Oscar Service (через Mule ESB)
curl -k -X POST https://localhost:8443/oscar/directors/get-loosers \
  -H "Content-Type: application/json" \
  -d '{}'
```

---

## 📦 Измененные файлы

### Добавленные файлы:
- `oscar-service-web/src/main/java/ru/itmo/soa/oscar/web/soap/OscarSoapService.java`
- `muleesb/lab4/src/main/mule/lab4.xml`
- `muleesb/lab4/pom.xml`
- `muleesb/lab4/mule-artifact.json`

### Измененные файлы:
- `oscar-service-web/pom.xml` - удалены JAX-RS, добавлены JAXB
- `oscar-service-web/src/main/webapp/WEB-INF/web.xml` - упрощен
- `oscar-service-ejb/src/main/java/ru/itmo/soa/oscar/dto/*.java` - добавлены JAXB аннотации
- `oscar-service-ejb/src/main/resources/application.properties` - URL через HAProxy
- `start.sh` - добавлен Mule ESB и HAProxy
- `.gitignore` - добавлены Mule ESB артефакты

### Удаленные файлы:
- `oscar-service-web/src/main/java/ru/itmo/soa/oscar/web/OscarResource.java`
- `oscar-service-web/src/main/java/ru/itmo/soa/oscar/web/OscarApplication.java`
- `oscar-service-web/src/main/java/ru/itmo/soa/oscar/web/SwaggerUIResource.java`
- `oscar-service-web/src/main/java/ru/itmo/soa/oscar/web/GenericExceptionMapper.java`

---

## 🚀 Запуск проекта

```bash
./start.sh
```

Скрипт выполняет:
1. Остановку всех сервисов
2. Очистку портов (включая 8080 для HAProxy)
3. Сборку всех компонентов
4. Запуск Payara DAS и инстансов
5. Деплой Oscar Service
6. Запуск Movie Service инстансов
7. Запуск Mule ESB
8. Запуск HAProxy

---

## 📝 Важные замечания

1. **HAProxy** запускается первым (до Payara) на порту 8080, так как все сервисы обращаются к нему
2. **Payara DAS** работает на порту 8180 (изменен с 8080), чтобы освободить порт 8080 для HAProxy
3. **Mule ESB** требует Java 17 (не Java 21)
4. **Consul** должен быть запущен для service discovery Movie Service
5. Все сервисы обращаются к другим сервисам через HAProxy (порт 8080), а не напрямую к инстансам
6. **Nginx** проксирует `/oscar/*` на Mule ESB (8081), а `/movies/*` на HAProxy (8080)
7. HAProxy балансирует нагрузку между инстансами через round-robin и health checks

---

## 🔍 Известные ограничения

1. Endpoint `humiliate-by-genre` может требовать дополнительной настройки для обработки пустых ответов
2. Полный список директоров может требовать пагинации при большом объеме данных

---

## 📚 Дополнительная информация

- **Mule ESB Documentation**: https://docs.mulesoft.com/
- **JAX-WS Specification**: https://javaee.github.io/metro-jax-ws/
- **HAProxy Documentation**: http://www.haproxy.org/#docs
- **Consul Documentation**: https://www.consul.io/docs
