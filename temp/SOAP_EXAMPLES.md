# Примеры SOAP запросов к Oscar Service

## Информация о сервисе

- **Endpoint:** `http://158.160.85.230:8080/service2/OscarSoapService` (через HAProxy)
- **WSDL:** `http://158.160.85.230:8080/service2/OscarSoapService?wsdl`
- **Namespace:** `http://soa.itmo.ru/oscar`
- **Протокол:** SOAP 1.2

## Метод 1: getDirectorsWithoutOscars

Получить список режиссеров без Оскаров.

### cURL запрос:

```bash
curl -X POST http://158.160.85.230:8080/service2/OscarSoapService \
  -H "Content-Type: application/soap+xml; charset=utf-8" \
  -H 'SOAPAction: "http://soa.itmo.ru/oscar/getDirectorsWithoutOscars"' \
  -d '<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
               xmlns:oscar="http://soa.itmo.ru/oscar">
  <soap:Body>
    <oscar:getDirectorsWithoutOscars/>
  </soap:Body>
</soap:Envelope>'
```

### Однострочный вариант (для удобства копирования):

```bash
curl -X POST http://158.160.85.230:8080/service2/OscarSoapService -H "Content-Type: application/soap+xml; charset=utf-8" -H 'SOAPAction: "http://soa.itmo.ru/oscar/getDirectorsWithoutOscars"' -d '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:oscar="http://soa.itmo.ru/oscar"><soap:Body><oscar:getDirectorsWithoutOscars/></soap:Body></soap:Envelope>'
```

### Пример ответа:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body>
    <ns2:getDirectorsWithoutOscarsResponse xmlns:ns2="http://soa.itmo.ru/oscar">
      <directors>
        <name>Режиссер 1</name>
        <passportID>AB1234567</passportID>
        <filmsCount>5</filmsCount>
      </directors>
      <directors>
        <name>Режиссер 2</name>
        <passportID>CD7890123</passportID>
        <filmsCount>3</filmsCount>
      </directors>
    </ns2:getDirectorsWithoutOscarsResponse>
  </soap:Body>
</soap:Envelope>
```

---

## Метод 2: humiliateDirectorsByGenre

Отобрать Оскары у режиссеров по жанру.

### cURL запрос (для жанра COMEDY):

```bash
curl -X POST http://158.160.85.230:8080/service2/OscarSoapService \
  -H "Content-Type: application/soap+xml; charset=utf-8" \
  -H 'SOAPAction: "http://soa.itmo.ru/oscar/humiliateDirectorsByGenre"' \
  -d '<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
               xmlns:oscar="http://soa.itmo.ru/oscar">
  <soap:Body>
    <oscar:humiliateDirectorsByGenre>
      <genre>COMEDY</genre>
    </oscar:humiliateDirectorsByGenre>
  </soap:Body>
</soap:Envelope>'
```

### Однострочный вариант:

```bash
curl -X POST http://158.160.85.230:8080/service2/OscarSoapService -H "Content-Type: application/soap+xml; charset=utf-8" -H 'SOAPAction: "http://soa.itmo.ru/oscar/humiliateDirectorsByGenre"' -d '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:oscar="http://soa.itmo.ru/oscar"><soap:Body><oscar:humiliateDirectorsByGenre><genre>COMEDY</genre></oscar:humiliateDirectorsByGenre></soap:Body></soap:Envelope>'
```

### Другие доступные жанры:

- `COMEDY`
- `ADVENTURE`
- `TRAGEDY`
- `SCIENCE_FICTION`

### Пример запроса для жанра ADVENTURE:

```bash
curl -X POST http://158.160.85.230:8080/service2/OscarSoapService \
  -H "Content-Type: application/soap+xml; charset=utf-8" \
  -H 'SOAPAction: "http://soa.itmo.ru/oscar/humiliateDirectorsByGenre"' \
  -d '<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
               xmlns:oscar="http://soa.itmo.ru/oscar">
  <soap:Body>
    <oscar:humiliateDirectorsByGenre>
      <genre>ADVENTURE</genre>
    </oscar:humiliateDirectorsByGenre>
  </soap:Body>
</soap:Envelope>'
```

### Пример ответа:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body>
    <ns2:humiliateDirectorsByGenreResponse xmlns:ns2="http://soa.itmo.ru/oscar">
      <humiliateResponse>
        <affectedDirectors>3</affectedDirectors>
        <affectedMovies>10</affectedMovies>
        <removedOscars>15</removedOscars>
      </humiliateResponse>
    </ns2:humiliateDirectorsByGenreResponse>
  </soap:Body>
</soap:Envelope>
```

---

## Прямое обращение к инстансам (без HAProxy)

Если нужно обратиться напрямую к конкретному инстансу:

### Instance 1 (порт 9001):

```bash
curl -X POST http://158.160.85.230:9001/service2/OscarSoapService \
  -H "Content-Type: application/soap+xml; charset=utf-8" \
  -H 'SOAPAction: "http://soa.itmo.ru/oscar/getDirectorsWithoutOscars"' \
  -d '<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
               xmlns:oscar="http://soa.itmo.ru/oscar">
  <soap:Body>
    <oscar:getDirectorsWithoutOscars/>
  </soap:Body>
</soap:Envelope>'
```

### Instance 2 (порт 9002):

```bash
curl -X POST http://158.160.85.230:9002/service2/OscarSoapService \
  -H "Content-Type: application/soap+xml; charset=utf-8" \
  -H 'SOAPAction: "http://soa.itmo.ru/oscar/getDirectorsWithoutOscars"' \
  -d '<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
               xmlns:oscar="http://soa.itmo.ru/oscar">
  <soap:Body>
    <oscar:getDirectorsWithoutOscars/>
  </soap:Body>
</soap:Envelope>'
```

---

## Преобразование через Mule ESB (REST → SOAP → REST)

Mule ESB предоставляет REST API прокси, который автоматически преобразует REST запросы в SOAP и обратно в JSON.

### Метод 1: getDirectorsWithoutOscars (через Mule ESB) ✅ Протестировано

REST запрос, который преобразуется в SOAP и возвращает JSON:

```bash
curl -X POST http://158.160.85.230:8081/service2/oscar/directors/get-loosers \
  -H "Content-Type: application/json" \
  -d '{}'
```

### Однострочный вариант:

```bash
curl -X POST http://158.160.85.230:8081/service2/oscar/directors/get-loosers -H "Content-Type: application/json" -d '{}'
```

### Пример ответа (JSON):

```json
[
  {
    "name": "Квентин Тарантино",
    "passportID": "QT123456",
    "filmsCount": 1
  },
  {
    "name": "Балабанов",
    "passportID": "234123234",
    "filmsCount": 1
  }
]
```

### Что происходит внутри:

1. **REST запрос** → Mule ESB (порт 8081)
2. **Преобразование** → REST JSON → SOAP XML
3. **SOAP запрос** → HAProxy (порт 8080) → Oscar Service
4. **SOAP ответ** → Oscar Service → HAProxy → Mule ESB
5. **Преобразование** → SOAP XML → REST JSON
6. **REST ответ** → JSON клиенту

### Метод 2: humiliateDirectorsByGenre (через Mule ESB)

REST запрос с параметром жанра в URL:

> **Примечание:** Этот метод может требовать дополнительной настройки Mule ESB. Для прямого SOAP вызова используйте примеры выше.

```bash
curl -X POST http://158.160.85.230:8081/service2/oscar/directors/humiliate-by-genre/COMEDY \
  -H "Content-Type: application/json" \
  -d '{}'
```

### Однострочный вариант:

```bash
curl -X POST http://158.160.85.230:8081/service2/oscar/directors/humiliate-by-genre/COMEDY -H "Content-Type: application/json" -d '{}'
```

### Примеры для разных жанров:

```bash
# COMEDY
curl -X POST http://158.160.85.230:8081/service2/oscar/directors/humiliate-by-genre/COMEDY -H "Content-Type: application/json" -d '{}'

# ADVENTURE
curl -X POST http://158.160.85.230:8081/service2/oscar/directors/humiliate-by-genre/ADVENTURE -H "Content-Type: application/json" -d '{}'

# TRAGEDY
curl -X POST http://158.160.85.230:8081/service2/oscar/directors/humiliate-by-genre/TRAGEDY -H "Content-Type: application/json" -d '{}'

# SCIENCE_FICTION
curl -X POST http://158.160.85.230:8081/service2/oscar/directors/humiliate-by-genre/SCIENCE_FICTION -H "Content-Type: application/json" -d '{}'
```

### Пример ответа (JSON):

```json
{
  "affectedDirectors": 3,
  "affectedMovies": 10,
  "removedOscars": 15
}
```

### Преимущества использования Mule ESB:

- ✅ **Простота**: Используйте обычные REST запросы с JSON
- ✅ **Прозрачность**: Преобразование SOAP ↔ REST происходит автоматически
- ✅ **Единый интерфейс**: Все сервисы доступны через REST API
- ✅ **Балансировка**: Запросы проходят через HAProxy для распределения нагрузки

---

## Использование SoapUI или Postman

1. **Импорт WSDL:**
   - URL: `http://158.160.85.230:8080/service2/OscarSoapService?wsdl`
   - SoapUI автоматически создаст запросы для всех методов

2. **Настройка запроса:**
   - Endpoint: `http://158.160.85.230:8080/service2/OscarSoapService`
   - SOAPAction: `"http://soa.itmo.ru/oscar/getDirectorsWithoutOscars"` или `"http://soa.itmo.ru/oscar/humiliateDirectorsByGenre"`
   - Content-Type: `application/soap+xml; charset=utf-8`

---

## Проверка балансировки

Чтобы проверить, что запросы распределяются между инстансами, можно добавить логирование или использовать несколько последовательных запросов:

```bash
# Выполнить запрос несколько раз и проверить логи Payara
for i in {1..5}; do
  echo "Request $i:"
  curl -X POST http://158.160.85.230:8080/service2/OscarSoapService \
    -H "Content-Type: application/soap+xml; charset=utf-8" \
    -H 'SOAPAction: "http://soa.itmo.ru/oscar/getDirectorsWithoutOscars"' \
    -d '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:oscar="http://soa.itmo.ru/oscar"><soap:Body><oscar:getDirectorsWithoutOscars/></soap:Body></soap:Envelope>'
  echo -e "\n"
  sleep 1
done
```

Затем проверить логи Payara на обоих инстансах:
```bash
# Логи instance1
tail -f payara/payara6/glassfish/domains/domain1/logs/server.log | grep "SOAP:"

# Или проверить, что запросы приходят на разные порты
```
