#!/bin/bash

# Подготовим переменные
LOCAL_DIR="/var/backups/simulator"
REMOTE_DIR="/var/backups/received"
REMOTE_HOST="10.128.0.6"
LOG="/var/log/rsync_transfer.log"

#Создаем директорию
mkdir -p "$LOCAL_DIR"

# Переменные для непустых файлов
FILENAME="backup_$(date +%Y-%m-%d_%H-%M-%S).bin"
FILEPATH="$LOCAL_DIR/$FILENAME"

# Создаем не пустой файл размером 15МБ
dd if=/dev/urandom of="$FILEPATH" bs=1M count=15 status=none
echo "Создаем файл: $FILEPATH"

# На удаленном сервере создаем директорию
ssh "$REMOTE_HOST" "mkdir -p $REMOTE_DIR"

# Далее передаемя файл на удаленный сервер и фиксируем это в логе
if rsync -av --remove-source-files "$FILEPATH" "${REMOTE_HOST}:${REMOTE_DIR}/"; then
    echo "$(date) — Успешная передача: $FILENAME" >> "$LOG"
else
    echo "$(date) — Ошибка передачи: $FILENAME" >> "$LOG"
    exit 1
fi

# На удаленном сервере удаляем файлы старше 7 дней.
ssh "$REMOTE_HOST" "find $REMOTE_DIR -type f -mtime +7 -delete"