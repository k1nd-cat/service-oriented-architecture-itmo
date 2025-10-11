#!/bin/bash

# Скрипт для установки Payara Server

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PAYARA_ZIP="payara-6.2025.9.zip"
PAYARA_DIR="payara6"
DOWNLOAD_URL="https://info.payara.fish/cs/c/?cta_guid=9d3ef224-15ca-4add-aeb3-caa5ecffee75&signature=AAH58kEheuDnVcLj4dIt9KOI1ARqZ-FyJg&portal_id=334594&placement_guid=333f68b3-3177-4fdc-b6b6-360169c8fa4e&click=e4248d57-dfaa-4467-aa23-77874a4c59e1&redirect_url=APefjpGJu4MBkBtx7CC_a1_J9JAjfSrmfXjxb6O2MDQniZoGp1AtvyzZ1RT-rTjXSQRtTbHGhbfImhw1YkHUBozBIWiElPY33199JMZyLUxHlD6gf-pqxKDxPobNcuGRxrC1wlK38MgO6_P97iAkRxmOVDIgNKsT8vOmyuofSw_Eu7zBJQRWs4c8w-9PFvAkGH0RfpTsc-lMyO4gAGhJgRZye41nwHGN_ZVi288IAHZka4kVAVR7uYE&hsutk=5bfa999633a41ae2c720dce5f68bd9f3&canon=https%3A%2F%2Fwww.payara.fish%2Fdownloads%2Fpayara-platform-community-edition%2F&ts=1759613862116&__hstc=229474563.5bfa999633a41ae2c720dce5f68bd9f3.1759613886486.1759613886486.1759613886486.1&__hssc=229474563.1.1759613886486&__hsfp=1220365062"

cd "$SCRIPT_DIR"

echo "=== Установка Payara Server ==="

# Проверяем, существует ли уже распакованная папка
if [ -d "$PAYARA_DIR" ]; then
    echo "✓ Payara уже установлена в папке $PAYARA_DIR"
    exit 0
fi

# Проверяем, существует ли zip файл
if [ ! -f "$PAYARA_ZIP" ]; then
    echo "→ Скачивание Payara..."
    
    # Проверяем наличие curl или wget
    if command -v curl &> /dev/null; then
        curl -L -o "$PAYARA_ZIP" "$DOWNLOAD_URL"
    elif command -v wget &> /dev/null; then
        wget -O "$PAYARA_ZIP" "$DOWNLOAD_URL"
    else
        echo "✗ Ошибка: не найден curl или wget для скачивания файла"
        exit 1
    fi
    
    if [ $? -ne 0 ]; then
        echo "✗ Ошибка при скачивании Payara"
        exit 1
    fi
    
    echo "✓ Payara успешно скачана"
else
    echo "✓ Файл $PAYARA_ZIP уже существует"
fi

# Распаковываем архив
echo "→ Распаковка архива..."

if command -v unzip &> /dev/null; then
    unzip -q "$PAYARA_ZIP"
else
    echo "✗ Ошибка: не найден unzip для распаковки архива"
    exit 1
fi

if [ $? -ne 0 ]; then
    echo "✗ Ошибка при распаковке архива"
    exit 1
fi

echo "✓ Payara успешно распакована"

# Делаем скрипты исполняемыми
if [ -d "$PAYARA_DIR/bin" ]; then
    chmod +x "$PAYARA_DIR/bin/"*
fi

if [ -d "$PAYARA_DIR/glassfish/bin" ]; then
    chmod +x "$PAYARA_DIR/glassfish/bin/"*
fi

echo "✓ Установка завершена!"
echo ""
echo "Для запуска сервера используйте:"
echo "  $SCRIPT_DIR/$PAYARA_DIR/bin/asadmin start-domain"

