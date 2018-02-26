#!/bin/bash
# 1cmulti
####################################
# Сценарий устанавливает в систему
# дополнительные версии платформы 1С: Предприятие
# Для корректной работы нужно предварительно установить
# платформу любой версии обычным способом.
####################################

####################################
# Предназначен для Ubuntu 16.04, в других версиях
# может работать, но не проверялся.
####################################

####################################
# Переменные
####################################

# Архитектура системы
ARCH=amd64
PKG_ARCH=`echo $ARCH | sed -e 's/amd/deb/g'`

# Имя пакета
NAME="1c-enterprise83"

# Защита от дурака, запускающего сценарий из корня ФС:

if [[ $(pwd) = "/" ]]
    then
        echo "При запуске из / возможна потеря данных."
        echo "Не запускайте этот сценарий так."
        exit 1
fi

# Проверка на наличие исходных файлов
# для парсера версии

if ! [ -f $PKG_ARCH.tar.gz ]
    then
        echo "Отсутствует архив с пакетами сервера $PKG_ARCH.tar.gz"
        exit 1
fi

if ! [ -f client.$PKG_ARCH.tar.gz ]
    then
        echo "Отсутствует архив с пакетами клиента client.$PKG_ARCH.tar.gz"
        exit 1
fi

# Если архивы найдены, пробуем их распаковать.
echo "Распаковываем архивы..."

tar xfz "$PKG_ARCH.tar.gz"
if [[ $? != 0 ]]
    then
        # Если код возврата не равен нулю, tar завершился с ошибкой
        # Прерываем выполнение сценария
        echo "Ошибка tar при распаковке $PKG_ARCH.tar.gz"
        exit 1
fi

tar xfz "client.$PKG_ARCH.tar.gz"
if [[ $? != 0 ]]
    then
        # Если код возврата не равен нулю, tar завершился с ошибкой
        # Прерываем выполнение сценария
        echo "Ошибка tar при распаковке client.$PKG_ARCH.tar.gz"
        exit 1
fi

# Проверяем, есть ли распакованные пакеты.
find ./ -name "$NAME-client*.deb" | egrep '.*'
if [[ $? != 0 ]]
    then
        echo "Пакет $NAME не найден"
        exit 1
    else
        echo "Пакет $NAME найден..."
        echo "Парсим версию..."

        # Извлечение версии пакета из имени
        VERSION=`ls $NAME-client* | head -1 | sed -e 's/'_"$ARCH"'//g' -e 's/^.*client_//g' -e 's/\.[^.]*$//'`

fi

echo "Версия:"$VERSION

# DEBUG
# exit 0


# Проверяем наличие всех требуемых пакетов

if ! [ -f "$NAME-client_"$VERSION"_"$ARCH".deb" ]
    then
        echo "$NAME-client_"$VERSION"_"$ARCH".deb не найден"
        echo "Проверьте наличие всех пакетов"
        #exit 1
    else
        echo "$NAME-client_"$VERSION"_"$ARCH".deb НАЙДЕН!"
fi

if ! [ -f "$NAME-client-nls_"$VERSION"_"$ARCH".deb" ]
    then
        echo "$NAME-client-nls_"$VERSION"_"$ARCH".deb не найден"
        echo "Проверьте наличие всех пакетов"
        #exit 1
    else
        echo "$NAME-client-nls_"$VERSION"_"$ARCH".deb НАЙДЕН"
fi

if ! [ -f "$NAME-server_"$VERSION"_"$ARCH".deb" ]
    then
        echo "$NAME-server_"$VERSION"_"$ARCH".deb не найден"
        echo "Проверьте наличие всех пакетов"
        #exit 1
    else
        echo "$NAME-server_"$VERSION"_"$ARCH".deb НАЙДЕН!"
fi

if ! [ -f "$NAME-server-nls_"$VERSION"_"$ARCH".deb" ]
    then
        echo "$NAME-server-nls_"$VERSION"_"$ARCH".deb не найден"
        echo "Проверьте наличие всех пакетов"
        #exit 1
    else
        echo "$NAME-server-nls_"$VERSION"_"$ARCH".deb НАЙДЕН!"
fi

echo "Все пакеты найдены!"
echo " "
echo "Установить пакет в систему? Потребуются права суперпользователя (Y/n)"

# Спрашиваем пользователя, нужна ли установка в систему
read item
case "$item" in
    y|Y) SETUP=1
        ;;
    n|N) SETUP=0
        ;;
    *) SETUP=1
        ;;
esac

# Распаковка пакетов
echo "Подождите, распаковка пакетов..."
dpkg -x $NAME"-client_"$VERSION"_"$ARCH".deb" . 
dpkg -x $NAME"-client-nls_"$VERSION"_"$ARCH".deb" . 
dpkg -x $NAME"-server_"$VERSION"_"$ARCH".deb" . 
dpkg -x $NAME"-common_"$VERSION"_"$ARCH".deb" . 

# Генерация файла .desktop
DESKTOPFILE="1cestart.$VERSION.desktop"
touch "$DESKTOPFILE"

#DEBUG

echo "[Desktop Entry]" >> "$DESKTOPFILE"
echo "Version=1.0" >> "$DESKTOPFILE"
echo "Type=Application" >> "$DESKTOPFILE"
echo "Terminal=false" >> "$DESKTOPFILE"
echo "Exec=/opt/1C/v"$VERSION"/x86_64/1cestart" >> "$DESKTOPFILE"
echo "Categories=Office;Finance;" >> "$DESKTOPFILE"
echo "Name[ru_RU]=1C:Предприятие "$VERSION >> "$DESKTOPFILE"
echo "Name=1C:Enterprise "$VERSION >> "$DESKTOPFILE"
echo "Icon=1cestart" >> "$DESKTOPFILE"

# Если пользователь согласился на установку:
if [[ $SETUP != 0 ]]
    then
        sudo mv "opt/1C/v8.3" "/opt/1C/"v$VERSION
        sudo desktop-file-install "1cestart.$VERSION.desktop"
    else
        tar -cpzf 1C_$VERSION.tgz opt
fi    

echo "Очистить установочные файлы (*.deb, *.desktop)? (Y/n)"

# Спрашиваем пользователя, нужно ли очищать временные файлы
read item
case "$item" in
    y|Y) rm -rf opt/ etc/ usr/; rm ./*.deb ./*.desktop
        ;;
    n|N) : #Ничего не делаем
        ;;
    *) rm -rf opt/ etc/ usr/; rm ./*.deb ./*.desktop
        ;;
esac

echo "Завершено успешно!"
exit 0
