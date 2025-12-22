# Jenkins build-agent с Maven и Docker
FROM maven:3.9.6-eclipse-temurin-17

# Устанавливаем Docker CLI и Git
RUN apt-get update && apt-get install -y \
    docker.io \
    git \
    sshpass \
    && apt-get clean

# Рабочая директория для сборки
WORKDIR /workspace

