# Swagger UI Развёртывание и Запуск на сервере helios

## Описание

Инструкция по развёртыванию интерактивной документации OpenAPI с помощью Swagger UI на сервере helios.

Пример документации:

[Swagger UI](https://se.ifmo.ru/~s333304/swagger-ui/swagger.html)  

---

## Шаги по развёртыванию

1. Скачать и распаковать архив Swagger UI со страницы релизов:  
   [https://github.com/swagger-api/swagger-ui/releases](https://github.com/swagger-api/swagger-ui/releases)

2. В проекте (например, в папке `swagger-ui`) скопировать **содержимое папки `dist`** из архива Swagger UI.

3. Добавить в эту же папку файл с вашей спецификацией OpenAPI (например, `movie-api-openapi.yaml`).

4. Создать в папке файл `swagger.html` с примерным содержимым:
   ```html
   <!DOCTYPE html>
   <html lang="ru">
   <head>
       <meta charset="UTF-8" />
       <title>Локальная документация Movie API</title>
       <link rel="stylesheet" href="swagger-ui.css" />
   </head>
   <body>
   <div id="swagger-ui"></div>
   
   <script src="swagger-ui-bundle.js"></script>
   <script src="swagger-ui-standalone-preset.js"></script>
   <script>
       window.onload = function() {
           SwaggerUIBundle({
               url: "movie-api-openapi.yaml",
               dom_id: '#swagger-ui',
               presets: [
                   SwaggerUIBundle.presets.apis,
                   SwaggerUIStandalonePreset
               ],
               layout: "BaseLayout"
           });
       };
   </script>
   </body>
   </html>
   ```

5. Подключитесь к серверу helios по SSH и создайте папку public_html в вашем домашнем каталоге (если её ещё нет):
   ```
   mkdir -p ~/public_html
   ```

6. Скопируйте папку с Swagger UI (например, swagger-ui) в директорию public_html

7. Теперь документацию можно будет открыть в браузере по адресу:
   ```
   https://se.ifmo.ru/~sXXXXXX/swagger-ui/swagger.html
   ```
   Где `sXXXXXX` — логин на helios.