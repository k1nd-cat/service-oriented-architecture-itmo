# Service-Oriented Architecture Project (ITMO)

Проект демонстрирует архитектуру микросервисов с использованием различных протоколов и технологий интеграции.

## 📋 Описание проекта

Проект состоит из двух основных сервисов:

- **Movie Service** - REST API сервис для управления фильмами (Spring Boot)
- **Oscar Service** - SOAP сервис для работы с режиссерами и наградами (Payara + EJB)

Сервисы интегрированы через:
- **HAProxy** - балансировщик нагрузки
- **Mule ESB** - REST-прокси слой для SOAP сервиса
- **Nginx** - reverse proxy и SSL termination
- **Consul** - service discovery для Movie Service

---

## 🏗️ Архитектура системы

### Компоненты

1. **Frontend (Flutter Web)** - веб-приложение на Flutter
2. **Nginx** - SSL termination, CORS, статический хостинг
3. **HAProxy** - балансировка нагрузки между инстансами сервисов
4. **Mule ESB** - REST-прокси слой, преобразование REST ↔ SOAP
5. **Movie Service** - REST API (Spring Boot, 2 инстанса)
6. **Oscar Service** - SOAP API (Payara, 2 инстанса)
7. **Consul** - Service Discovery для Movie Service

---

## 📊 Диаграмма развертывания

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         🌐 Клиент (Web Browser)                              │
└────────────────────────────────────┬──────────────────────────────────────────┘
                                      │ HTTPS:8443
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    🔒 NGINX Reverse Proxy (Port 8443)                       │
│  • SSL/TLS Termination                                                     │
│  • CORS Headers                                                            │
│  • Static File Serving (Flutter Web App)                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│  Routing Rules:                                                            │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ GET  /                    → Flutter Web App (static files)         │   │
│  │ POST /movies/*            → http://127.0.0.1:8080/service1/...   │   │
│  │ POST /oscar/*             → http://127.0.0.1:8081/service2/...   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└────────────────────────────┬───────────────────────────┬───────────────────┘
                             │ HTTP                       │ HTTP
                             │                           │
                             ▼                           ▼
        ┌───────────────────┴────────────┐   ┌──────────────────────────┐
        │                                │   │                          │
        ▼                                ▼   ▼                          │
┌───────────────────────┐    ┌──────────────────────────┐              │
│ ⚖️  HAProxy (8080)     │    │ 🔄 Mule ESB (8081)       │              │
│ Load Balancer          │    │ REST Proxy Layer         │              │
├───────────────────────┤    ├──────────────────────────┤              │
│ Frontend: fe_movie    │    │ • REST → SOAP            │              │
│                       │    │ • SOAP → REST            │              │
│ ACL Rules:            │    │ • DataWeave Transform    │              │
│ • path_beg /service2  │    │                          │              │
│   → oscar-service     │    │ Endpoints:               │              │
│ • default             │    │ • /oscar/directors/      │              │
│   → movie-service     │    │   get-loosers            │              │
├───────────────────────┤    │ • /oscar/directors/      │              │
│ Backends:             │    │   humiliate-by-genre/   │               │
│                       │    └──────────┬───────────────┘              │
│ ┌─────────────────┐   │               │ HTTP:8080                    │
│ │ movie-service   │   │               │ (via HAProxy)                │
│ │ (Consul DNS)    │   │               │                              │
│ │ • Round-robin   │   │               ▼                              │
│ │ • Health checks │   │   ┌──────────────────────────┐               │
│ │ • Ports: 9003,  │   │   │ ⚖️  HAProxy (8080)       │              │
│ │   9004          │   │   │ Load Balancer            │               │
│ └─────────────────┘   │   │ Round-robin              │               │
│                       │   └──────────┬───────────────┘               │
│ ┌─────────────────┐   │               │                              │
│ │ oscar-service   │   │               │                              │
│ │ (Static)        │   │               │                              │
│ │ • Round-robin   │   │               │                              │
│ │ • Health checks │   │               │                              │
│ │ • Ports: 9001,  │   │               │                              │
│ │   9002          │   │               │                              │
│ └─────────────────┘   │               │                              │
└───────┬───────────────┘               │                              │
        │                               │                              │
        │                               │                              │
        ├───────────────┬───────────────┴───────────────┬──────────────┘
        │               │                               │
        ▼               ▼                               ▼
┌───────────────┐ ┌───────────────┐           ┌───────────────┐ ┌───────────────┐
│ MOVIE-1       │ │ MOVIE-2       │           │ OSCAR-1       │ │ OSCAR-2       │
│ Port: 9003    │ │ Port: 9004    │           │ Port: 9001    │ │ Port: 9002    │
├───────────────┤ ├───────────────┤           ├───────────────┤ ├───────────────┤
│ Spring Boot   │ │ Spring Boot   │           │ Payara        │ │ Payara        │
│ Application   │ │ Application   │           │ instance1     │ │ instance2     │
│               │ │               │           │               │ │               │
│ REST API      │ │ REST API      │           │ SOAP API      │ │ SOAP API      │
│ • /service1/  │ │ • /service1/  │           │ • /service2/  │ │ • /service2/  │
│   api/v1/     │ │   api/v1/     │           │   OscarSoap   │ │   OscarSoap   │
│               │ │               │           │   Service     │ │   Service     │
│ Features:     │ │ Features:     │           │               │ │               │
│ • JPA/Hibernate│ │ • JPA/Hibernate│         │ Features:     │ │ Features:     │
│ • Consul      │ │ • Consul      │           │ • JAX-WS      │ │ • JAX-WS      │
│   Client      │ │   Client      │           │ • EJB         │ │ • EJB         │
│ • OpenAPI     │ │ • OpenAPI     │           │ • JNDI        │ │ • JNDI        │
│   (Swagger)   │ │   (Swagger)   │           │               │ │               │
└───────┬───────┘ └───────┬───────┘           └───────┬───────┘ └───────┬───────┘
        │                 │                           │                 │
        └────────┬────────┘                           │                 │
                 │                                    │                 │
                 │ Register to Consul                 │ Call via JNDI   │
                 │                                    │                 │
                 ▼                                    │                 │
        ┌─────────────────────┐                       │                 │
        │ 📡 CONSUL           │                       │                 │
        │ Port: 8500 (HTTP)   │                       │                 │
        │ Port: 8600 (DNS)    │                       │                 │
        ├─────────────────────┤                       │                 │
        │ Service Discovery   │                       │                 │
        │ • movie-service     │                       │                 │
        │   - 127.0.0.1:9003  │                       │                 │
        │   - 127.0.0.1:9004  │                       │                 │
        │ • Health Checks     │                       │                 │
        │ • DNS Resolution    │                       │                 │
        └─────────────────────┘                       │                 │
                                                       │                 │
                                                       ▼                 ▼
                                            ┌─────────────────────┐
                                            │ 🔧 EJB POOL         │
                                            │ (Stateless)         │
                                            ├─────────────────────┤
                                            │ OscarServiceBean    │
                                            │ @Stateless          │
                                            │ @Remote interface   │
                                            │                     │
                                            │ Pool Config:        │
                                            │ • steady: 5 beans   │
                                            │ • resize: +2        │
                                            │ • max: 20 beans     │
                                            │ • timeout: 600s     │
                                            └─────────────────────┘
```

### Дополнительные компоненты (не показаны на диаграмме)

- **Payara DAS** (Port 8180) - Domain Administration Server для управления инстансами
- **Payara Admin Console** (Port 4848) - веб-интерфейс администрирования

---

## 🔄 Сетевые взаимодействия

### 1. Запрос к Movie Service (через фронтенд)

```
Browser
  │ HTTPS:8443
  ▼
Nginx (8443)
  │ HTTP (proxy_pass)
  │ POST /movies/filters
  ▼
HAProxy (8080)
  │ HTTP
  │ Load Balancing (round-robin)
  │ Health Check: GET /service1/actuator/health
  │ Service Discovery: Consul DNS (_movie-service._tcp.service.consul)
  ├──→ Movie Service Instance 1 (9003) ──┐
  │                                      │
  └──→ Movie Service Instance 2 (9004) ──┤
                                          │
                                          ▼
                                    [Response JSON]
                                          │
                                          │ через HAProxy
                                          │ через Nginx
                                          ▼
                                      Browser
```

**Протоколы:**
- Browser → Nginx: HTTPS (TLS 1.2+)
- Nginx → HAProxy: HTTP
- HAProxy → Movie Service: HTTP
- Movie Service → Consul: HTTP (8500) для регистрации

---

### 2. Запрос к Oscar Service (через фронтенд)

```
Browser
  │ HTTPS:8443
  ▼
Nginx (8443)
  │ HTTP (proxy_pass)
  │ POST /oscar/directors/get-loosers
  ▼
Mule ESB (8081)
  │ HTTP Listener
  │ Path: /service2/oscar/directors/get-loosers
  │
  │ DataWeave Transformation:
  │ JSON → SOAP XML
  │ {
  │   "Content-Type": "application/soap+xml",
  │   "SOAPAction": "http://soa.itmo.ru/oscar/getDirectorsWithoutOscars"
  │ }
  │
  │ HTTP Request
  ▼
HAProxy (8080)
  │ HTTP
  │ ACL: path_beg /service2 → oscar-service backend
  │ Load Balancing (round-robin)
  │ Health Check: TCP check (ports 9001, 9002)
  ├──→ Oscar Service Instance 1 (9001) ──┐
  │    Payara instance1                  │
  │    ┌──────────────────────────┐     │
  │    │ OscarSoapService         │     │
  │    │ (JAX-WS Endpoint)        │     │
  │    │   ↓                      │     │
  │    │ JNDI Lookup              │     │
  │    │ java:global/.../         │     │
  │    │   OscarServiceBean       │     │
  │    │   ↓                      │     │
  │    │ EJB Method Call          │     │
  │    │   ↓                      │     │
  │    │ HTTP call to Movie-Svc   │     │
  │    │ (via HAProxy:8080)       │     │
  │    └────────┬─────────────────┘     │
  │             │                        │
  │             │ http://localhost:8080/ │
  │             │   service1/api/v1/... │
  │             │                        │
  │             └──→ HAProxy ──> Movie  │
  │                                 Service
  │                                      │
  └──→ Oscar Service Instance 2 (9002) ──┤
       (аналогично instance1)            │
                                          │
                                          ▼
                                    [SOAP Response XML]
                                          │
                                          │ через HAProxy
                                          ▼
                                    Mule ESB (8081)
                                          │
                                          │ DataWeave Transformation:
                                          │ SOAP XML → JSON
                                          │
                                          ▼
                                    [JSON Response]
                                          │
                                          │ через Nginx
                                          ▼
                                      Browser
```

**Протоколы:**
- Browser → Nginx: HTTPS
- Nginx → Mule ESB: HTTP
- Mule ESB → HAProxy: HTTP
- HAProxy → Oscar Service: HTTP
- Oscar Service (SOAP): HTTP + SOAP 1.2
- Oscar Service → Movie Service: HTTP (REST)

---

### 3. Oscar Service вызывает Movie Service (внутренний вызов)

```
Oscar Service (EJB Bean)
  │ HTTP Client
  │ URL: http://localhost:8080/service1/api/v1/movies/...
  ▼
HAProxy (8080)
  │ HTTP
  │ ACL: default → movie-service backend
  │ Load Balancing (round-robin)
  │ Service Discovery: Consul DNS
  ├──→ Movie Service Instance 1 (9003) ──┐
  │                                      │
  └──→ Movie Service Instance 2 (9004) ──┤
                                          │
                                          ▼
                                    [JSON Response]
                                          │
                                          │ через HAProxy
                                          ▼
                                    Oscar Service
```

**Протоколы:**
- Oscar Service → HAProxy: HTTP
- HAProxy → Movie Service: HTTP (REST)

---

## 🔌 Порты и протоколы

| Компонент | Порт | Протокол | Описание |
|-----------|------|----------|----------|
| **NGINX** | 8443 | HTTPS | Frontend + API Gateway, SSL Termination |
| **HAProxy** | 8080 | HTTP | Load Balancer для всех сервисов |
| **Mule ESB** | 8081 | HTTP | REST Proxy Layer для SOAP сервиса |
| **Payara DAS** | 8180 | HTTP | Domain Administration Server (admin only) |
| **Payara Admin** | 4848 | HTTP | Admin Console |
| **Movie Service #1** | 9003 | HTTP | Spring Boot Instance 1 |
| **Movie Service #2** | 9004 | HTTP | Spring Boot Instance 2 |
| **Oscar Service #1** | 9001 | HTTP | Payara instance1 (SOAP) |
| **Oscar Service #2** | 9002 | HTTP | Payara instance2 (SOAP) |
| **Consul HTTP** | 8500 | HTTP | Service Registry API |
| **Consul DNS** | 8600 | DNS | Service Discovery DNS |

---

## 🚀 Быстрый старт

### Требования

- Java 17 (для Mule ESB)
- Java 21 (для Payara и Movie Service)
- Maven 3.6+
- Flutter SDK (для сборки фронтенда)
- HAProxy
- Nginx
- Consul

### Запуск проекта

```bash
# Клонировать репозиторий
git clone <repository-url>
cd service-oriented-architecture-itmo

# Запустить все сервисы
./start.sh

# Проверить статус
curl http://localhost:8080/service1/actuator/health
curl http://localhost:8081/service2/oscar/directors/get-loosers -X POST -H "Content-Type: application/json" -d '{}'
```

### Остановка проекта

```bash
# Остановить все сервисы
pkill -f "movie-service"
pkill -f "payara"
pkill -f "mule"
sudo systemctl stop haproxy
```

---

## 📡 API Endpoints

### Movie Service (REST)

**Базовый URL:** `http://localhost:8080/service1/api/v1` (через HAProxy)

- `GET /movies` - получить список фильмов
- `POST /movies/filters` - фильтрация фильмов
- `GET /movies/{id}` - получить фильм по ID
- `POST /movies` - создать фильм
- `PUT /movies/{id}` - обновить фильм
- `DELETE /movies/{id}` - удалить фильм

**Swagger UI:** `http://localhost:9003/service1/swagger-ui.html`

### Oscar Service (SOAP)

**WSDL:** `http://localhost:8080/service2/OscarSoapService?wsdl` (через HAProxy)

**Методы:**
- `getDirectorsWithoutOscars()` - получить режиссеров без наград
- `humiliateDirectorsByGenre(String genre)` - удалить награды по жанру

**Namespace:** `http://soa.itmo.ru/oscar`

### Mule ESB REST Proxy

**Базовый URL:** `http://localhost:8081/service2/oscar` (REST интерфейс для SOAP)

- `POST /directors/get-loosers` - получить режиссеров без наград (REST → SOAP)
- `POST /directors/humiliate-by-genre/{genre}` - удалить награды по жанру (REST → SOAP)

---

## 🔍 Мониторинг и логи

### Логи сервисов

```bash
# Movie Service
tail -f /tmp/movie-service-9003.log
tail -f /tmp/movie-service-9004.log

# Payara
tail -f payara/payara6/glassfish/domains/domain1/logs/server.log

# Mule ESB
tail -f /tmp/mule-esb.log

# HAProxy
sudo journalctl -u haproxy -f

# Nginx
sudo tail -f /var/log/nginx/error.log
```

### Проверка здоровья

```bash
# Movie Service
curl http://localhost:8080/service1/actuator/health

# Consul Services
curl http://localhost:8500/v1/catalog/services

# HAProxy Stats (если настроен stats endpoint)
curl http://localhost:8080/stats
```

---

## 🏛️ Архитектурные решения

### Балансировка нагрузки

- **HAProxy** использует round-robin для распределения запросов
- **Movie Service**: динамическое обнаружение через Consul DNS
- **Oscar Service**: статическая конфигурация (порты 9001, 9002)
- Health checks для обоих бэкендов

### Service Discovery

- **Consul** используется для Movie Service
- Регистрация через Consul Client в Spring Boot
- HAProxy использует Consul DNS resolver для динамического обнаружения инстансов

### Протоколы интеграции

- **REST** - основной протокол для Movie Service
- **SOAP 1.2** - протокол для Oscar Service
- **Mule ESB** обеспечивает прозрачное преобразование REST ↔ SOAP

### Безопасность

- **SSL/TLS** терминация на Nginx (порт 8443)
- **CORS** headers настроены в Nginx
- Все внутренние коммуникации через HTTP (внутренняя сеть)

---

## 📚 Технологии

- **Backend:**
  - Spring Boot (Movie Service)
  - Payara Server 6 (Oscar Service)
  - JAX-WS / SOAP 1.2
  - EJB 3.x
  - JPA / Hibernate

- **Integration:**
  - Mule ESB 4.6.0 Community Edition
  - DataWeave 2.0
  - HAProxy 2.8+

- **Infrastructure:**
  - Nginx (reverse proxy, SSL termination)
  - Consul (service discovery)
  - Maven (build tool)

- **Frontend:**
  - Flutter Web

---

## 📝 Структура проекта

```
service-oriented-architecture-itmo/
├── movie-service/          # Spring Boot REST API
│   ├── src/main/java/      # Java код
│   └── src/main/resources/ # Конфигурация
├── oscar-service/          # Payara EAR + EJB + SOAP
│   ├── oscar-service-ejb/  # EJB модуль
│   └── oscar-service-web/  # Web модуль (SOAP endpoint)
├── muleesb/                # Mule ESB приложение
│   └── lab4/               # REST Proxy слой
├── webapp/                 # Flutter Web приложение
├── start.sh               # Скрипт автоматического деплоя
└── README.md              # Документация
```

---

## 🔧 Конфигурация

### HAProxy

Конфигурация: `/etc/haproxy/haproxy.cfg`

- Frontend на порту 8080
- Backend `movie-service`: Consul DNS resolver
- Backend `oscar-service`: статическая конфигурация

### Nginx

Конфигурация: `/etc/nginx/sites-available/default`

- SSL сертификаты: `/etc/ssl/certs/soa.crt`, `/etc/ssl/private/soa.key`
- Проксирование на HAProxy (8080) и Mule ESB (8081)

### Consul

- HTTP API: `http://localhost:8500`
- DNS: `localhost:8600`
- Movie Service регистрируется автоматически через Consul Client

---
