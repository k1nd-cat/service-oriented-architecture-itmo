# Oscar Service - Multi-module EJB Application

## Структура проекта

```
oscar-service/
├── pom.xml                    # Parent POM
├── oscar-service-ejb/         # EJB модуль с бизнес-логикой
│   ├── src/main/java/
│   │   └── ru/itmo/soa/oscar/
│   │       ├── service/
│   │       │   ├── OscarService.java      # Remote интерфейс
│   │       │   └── OscarServiceBean.java  # Stateless EJB
│   │       ├── dto/                       # Data Transfer Objects
│   │       └── config/                    # Конфигурация
│   └── src/main/resources/
│       ├── application.properties
│       └── glassfish-ejb-jar.xml         # Настройки EJB пула
├── oscar-service-web/         # Web модуль (JAX-RS)
│   ├── src/main/java/
│   │   └── ru/itmo/soa/oscar/web/
│   │       ├── OscarApplication.java     # JAX-RS Application
│   │       ├── OscarResource.java        # REST endpoints
│   │       ├── SwaggerUIResource.java    # Swagger UI
│   │       └── GenericExceptionMapper.java
│   └── src/main/webapp/
│       └── WEB-INF/glassfish-web.xml
└── oscar-service-ear/         # Enterprise Archive
    └── pom.xml                # Собирает EJB + WAR в EAR
```

## EJB Конфигурация

### Stateless Session Bean
- **Интерфейс**: `OscarService` (Remote)
- **Реализация**: `OscarServiceBean`
- **Тип**: Stateless

### Pool Settings (glassfish-ejb-jar.xml)
- **steady-pool-size**: 5 (начальный размер пула)
- **max-pool-size**: 20 (максимальный размер)
- **resize-quantity**: 2 (количество бинов при расширении)
- **pool-idle-timeout**: 600 секунд

## Endpoints

**Oscar Service (http://localhost:9001/service2)**
- POST `/oscar/directors/get-loosers` - Список режиссеров без Оскаров
- POST `/oscar/directors/humiliate-by-genre/{genre}` - Отобрать Оскары по жанру
- GET `/swagger-ui` - Swagger UI
- GET `/openapi.json` - OpenAPI спецификация

## Сборка и деплой

```bash
cd oscar-service
mvn clean package
```

Деплой в Payara:
```bash
asadmin deploy oscar-service-ear/target/oscar-service-1.0.0.ear
```

## Архитектура

1. **Web слой** (JAX-RS) - принимает HTTP запросы
2. **EJB слой** (Stateless Bean) - бизнес-логика и вызовы movie-service
3. **Remote интерфейс** - позволяет удаленный доступ к EJB

EJB пул автоматически расширяется при увеличении нагрузки.

