# 1cmulti-ubuntu
Easy installation of multiple 1C:Enterprise versions
[English version](#About)

## О сценарии
Изменённый под архитектуру DEB-пакетов сценарий с [вики АльтЛинукс]([)https://www.altlinux.org/1C/MultiClient). Предназначен для удобной установки множественных версий 1С:Предприятие в Ubuntu Linux 16.04 (может работать и в других версиях дистрибутива). Удобно, если вы — разработчик.

## Установка
Предварительно необходимо установить любую версию 1С:Предприятия обычным способом (при помощи dpkg -i). Затем загрузите с [сайта релизов 1С](https://releases.1c.ru) архивы **client_8_3_xx_yyyy.deb64.tar.gz** и **deb64_8_3_xx_yyyy.tar.gz**. Это архивы клиента и сервера 1С:Предприятие. Поместите эти файлы в любой каталог, права на запись в который у вас есть, но не в **/**. Разместите сценарий в том же каталоге, дайте ему права на исполнение и запустите.

## Интеграция в систему
Сценарий можно использовать для общесистемной установки. Для этого потребуется аккаунт с возможностью запуска программ с правами суперпользователя. Если пользователь не имеет прав суперпользователя, сценарий генерирует архив, установить который можно вручную командой 

    tar -xzvf 1С_$VERSION.tgz -C /

## About
This is a rewritten script from [AltLinux Wiki](https://www.altlinux.org/1C/MultiClient), adapted for the **.deb** package arhitecture. Tested on Ubuntu 16.04, may work in other releases.

## Installation
Install any version of 1C:Enterprise (using packages from the official [release site](https://releases.1c.ru.)) with the standard method (dpkg -i) first. Put **client_8_3_xx_yyyy.deb64.tar.gz** AND **deb64_8_3_xx_yyyy.tar.gz** to any directory, for which you have write permissions, except **/**. Put this script alongside, make it executable and run it.

## System integration
You can use this script to install 1C:Enterprise system-wide. For this, the superuser privileges will be required (you will be asked your password for running with elevated privileges via sudo). If you don't have those privileges or choose not to install the package system-wide, you will get an archive, which could be installed manually:

     tar -xzvf 1С_$VERSION.tgz -C /
