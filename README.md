# 1cmulti-ubuntu
Easy installation of multiple 1C:Enterprise versions

## About
This is a rewrited script from https://www.altlinux.org/1C/MultiClient, adapted for .deb package arhitecture. Tested on Ubuntu 16.04, may work in other releases.

## Installation
Install any version of 1C:Enterprise first. Then you can download desired version from https://releases.1c.ru. Put "client_8_3_xx_yyyy.deb64.tar.gz" AND "deb64_8_3_xx_yyyy.tar.gz" (x64 client and server for DEB-based Linux systems) to any directory (except /) alongside this script and run ./1cmulti.sh.

## О сценарии
Изменённый под архитектуру DEB-пакетов сценарий с вики АльтЛинукс: https://www.altlinux.org/1C/MultiClient.
Сценарий предназначен для удобной установки множественных версий 1С:Предприятие в Ubuntu Linux 16.04 (может работать и в других версиях дистрибутива). 

## Установка
Предварительно необходимо установить любую версию 1С:Предприятия обычным способом (при помощи dpkg). Затем загрузите с https://releases.1c.ru архивы "client_8_3_xx_yyyy.deb64.tar.gz" и "deb64_8_3_xx_yyyy.tar.gz" - это архивы с пакетами "Клиент 1С:Предприятия (64-bit) для DEB-based Linux-систем" и "Cервер 1С:Предприятия (64-bit) для DEB-based Linux-систем". Поместите эти архивы в один каталог с этим сценарием (кроме /) и запустите ./1cmulti.sh.

## Установка в систему
Сценарий можно использовать для общесистемной установки. Для этого потребуется аккаунт с возможностью запуска программ с правами суперпользователя. Если пользователь не имеет прав суперпользователя, сценарий генерирует архив, установить который можно вручную командой 

    tar -xzvf 1С_$VERSION.tgz -C /
