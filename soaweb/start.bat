@echo off
set IMAGE_NAME=my-flutter-web
set CONTAINER_NAME=my-flutter-web-container
set PORT=8080
set TAR_PATH=build\soa-docker.tar

REM Сборка Docker-образа
docker build -t %IMAGE_NAME% .

REM Остановка и удаление старого контейнера (ошибку игнорировать)
docker stop %CONTAINER_NAME%
docker rm %CONTAINER_NAME%

REM Запуск нового контейнера
docker run -d --name %CONTAINER_NAME% -p %PORT%:80 %IMAGE_NAME%

REM Экспорт образа в tar
docker save -o %TAR_PATH% %IMAGE_NAME%

echo ---------------------------------------------
echo Docker образ сохранен: %TAR_PATH%
echo Его можно перенести на сервер и загрузить так:
echo   docker load -i my-flutter-web.tar
echo Flutter web приложение запущено на http://localhost:%PORT%
pause
