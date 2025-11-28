# Homework 6 - JAVA Project 

FROM ubuntu:20.04
MAINTAINER Sherali Turabov <turabov.sh@gmail.com>

# Переменные окружения (отключает интерактивные диалоги)
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

# Устанавливаем все зависимости (wget, git,default-jdk, maven)
RUN apt-get update && apt-get install -y wget git default-jdk maven

# Установка Apache Tomcat
RUN mkdir -p /opt/tomcat
WORKDIR /opt

RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.112/bin/apache-tomcat-9.0.112.tar.gz && \
    tar xzvf apache-tomcat-9.0.112.tar.gz -C /opt/tomcat --strip-components=1 && \
    chmod +x /opt/tomcat/bin/*.sh

# Клонирование репозитория Addressbook
RUN git clone https://github.com/vaadin/addressbook.git /root/addressbook

# Сборка Maven проекта
WORKDIR /root/addressbook
RUN mvn -B package

# Копирование WAR в Tomcat
RUN cp /root/addressbook/target/addressbook-*.war /opt/tomcat/webapps/addressbook.war

# Tomcat port
EXPOSE 8080

# Запуск Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
