@echo off
setlocal enabledelayedexpansion

REM Скрипт для установки Payara Server

set "PAYARA_ZIP=payara-6.2025.9.zip"
set "PAYARA_DIR=payara6"
set "DOWNLOAD_URL=https://info.payara.fish/cs/c/?cta_guid=9d3ef224-15ca-4add-aeb3-caa5ecffee75&signature=AAH58kEheuDnVcLj4dIt9KOI1ARqZ-FyJg&portal_id=334594&placement_guid=333f68b3-3177-4fdc-b6b6-360169c8fa4e&click=e4248d57-dfaa-4467-aa23-77874a4c59e1&redirect_url=APefjpGJu4MBkBtx7CC_a1_J9JAjfSrmfXjxb6O2MDQniZoGp1AtvyzZ1RT-rTjXSQRtTbHGhbfImhw1YkHUBozBIWiElPY33199JMZyLUxHlD6gf-pqxKDxPobNcuGRxrC1wlK38MgO6_P97iAkRxmOVDIgNKsT8vOmyuofSw_Eu7zBJQRWs4c8w-9PFvAkGH0RfpTsc-lMyO4gAGhJgRZye41nwHGN_ZVi288IAHZka4kVAVR7uYE&hsutk=5bfa999633a41ae2c720dce5f68bd9f3&canon=https://www.payara.fish/downloads/payara-platform-community-edition/&ts=1759613862116&__hstc=229474563.5bfa999633a41ae2c720dce5f68bd9f3.1759613886486.1759613886486.1759613886486.1&__hssc=229474563.1.1759613886486&__hsfp=1220365062"

cd /d "%~dp0"

echo === Установка Payara Server ===
echo.

REM Проверяем, существует ли уже распакованная папка
if exist "%PAYARA_DIR%" (
    echo [OK] Payara уже установлена в папке %PAYARA_DIR%
    exit /b 0
)

REM Проверяем, существует ли zip файл
if not exist "%PAYARA_ZIP%" (
    echo [*] Скачивание Payara...
    
    REM Используем PowerShell для скачивания
    powershell -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%PAYARA_ZIP%' -UseBasicParsing } catch { Write-Host 'Ошибка при скачивании'; exit 1 }"
    
    if errorlevel 1 (
        echo [ERROR] Ошибка при скачивании Payara
        exit /b 1
    )
    
    echo [OK] Payara успешно скачана
) else (
    echo [OK] Файл %PAYARA_ZIP% уже существует
)

REM Распаковываем архив
echo [*] Распаковка архива...

powershell -Command "try { Expand-Archive -Path '%PAYARA_ZIP%' -DestinationPath '.' -Force } catch { Write-Host 'Ошибка при распаковке'; exit 1 }"

if errorlevel 1 (
    echo [ERROR] Ошибка при распаковке архива
    exit /b 1
)

echo [OK] Payara успешно распакована
echo [OK] Установка завершена!
echo.
echo Для запуска сервера используйте:
echo   %~dp0%PAYARA_DIR%\bin\asadmin.bat start-domain
echo.

endlocal

