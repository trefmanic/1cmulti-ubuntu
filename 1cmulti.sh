#!/bin/bash
# now with GPG
# 1cmulti
####################################
# Сценарий устанавливает в систему
# дополнительные версии платформы 1С: Предприятие
# Для корректной работы нужно предварительно установить
# платформу любой версии обычным способом.
####################################

####################################
# Переменные
####################################

# Архитектура системы
ARCH=amd64
PKG_ARCH=$(echo $ARCH | sed -e 's/amd/deb/g')

# Имя пакета
NAME="1c-enterprise"

# Защита от дурака, запускающего сценарий из корня ФС:

if [[ $(pwd) = "/" ]]
    then
        echo "При запуске из / возможна потеря данных."
        echo "Не запускайте этот сценарий так."
        exit 1
fi

# Проверка на наличие исходных файлов
# для парсера версии

# Фикс для новых вариаций наименования архивов

if ! [ -f $PKG_ARCH*.tar.gz ]
    then
        echo "Отсутствует архив с пакетами сервера $PKG_ARCH.tar.gz"
        exit 1
fi

if ! [ -f client*.$PKG_ARCH.tar.gz ]
    then
        echo "Отсутствует архив с пакетами клиента client.$PKG_ARCH.tar.gz"
        exit 1
fi

# Если архивы найдены, пробуем их распаковать.
echo "Распаковываем архивы..."

tar xfz "$PKG_ARCH"*.tar.gz
if [[ $? != 0 ]]
    then
        # Если код возврата не равен нулю, tar завершился с ошибкой
        # Прерываем выполнение сценария
        echo "Ошибка tar при распаковке $PKG_ARCH.tar.gz"
        exit 1
fi

tar xfz client*."$PKG_ARCH".tar.gz
if [[ $? != 0 ]]
    then
        # Если код возврата не равен нулю, tar завершился с ошибкой
        # Прерываем выполнение сценария
        echo "Ошибка tar при распаковке client.$PKG_ARCH.tar.gz"
        exit 1
fi

# Проверяем, есть ли распакованные пакеты.
find ./ -name "$NAME*-client*.deb" | egrep '.*'
if [[ $? != 0 ]]
    then
        echo "Пакет $NAME не найден"
        exit 1
    else
        echo "Пакет $NAME найден..."
        echo "Парсим версию..."

        # Извлечение версии пакета из имени
        VERSION=$(ls --color=never $NAME*-client* | head -1 | sed -e "s/$NAME-//g" -e 's/-.*$//g')
        # Дополнительное колдунство, так как 1С не может определиться
        # как именовать пакеты
        VERSIONWITHDASH=$(echo $VERSION | sed -E 's/(.*)\./\1-/')

fi

echo "Версия:"$VERSION

# DEBUG
# exit 0

# TODO: упаковать в case
# Проверяем наличие всех требуемых пакетов

if ! [ -f "$NAME-$VERSION-client_"$VERSIONWITHDASH"_$ARCH.deb" ]
    then
        echo "$NAME-$VERSION-client_"$VERSIONWITHDASH"_$ARCH.deb не найден"
        echo "Проверьте наличие всех пакетов"
        exit 1
    else
        echo "$NAME-$VERSION-client_"$VERSIONWITHDASH"_$ARCH.deb НАЙДЕН"
fi

if ! [ -f "$NAME-$VERSION-client-nls_"$VERSIONWITHDASH"_$ARCH.deb" ]
    then
        echo "$NAME-$VERSION-client-nls_"$VERSIONWITHDASH"_$ARCH.deb не найден"
        echo "Проверьте наличие всех пакетов"
        exit 1
    else
        echo "$NAME-$VERSION-client-nls_"$VERSIONWITHDASH"_$ARCH.deb НАЙДЕН"
fi

if ! [ -f "$NAME-$VERSION-server_"$VERSIONWITHDASH"_$ARCH.deb" ]
    then
        echo "$NAME-$VERSION-server_"$VERSIONWITHDASH"_$ARCH.deb не найден"
        echo "Проверьте наличие всех пакетов"
        exit 1
    else
        echo "$NAME-$VERSION-server_"$VERSIONWITHDASH"_$ARCH.deb НАЙДЕН"
fi

if ! [ -f "$NAME-$VERSION-server-nls_"$VERSIONWITHDASH"_$ARCH.deb" ]
    then
        echo "$NAME-$VERSION-server-nls_"$VERSIONWITHDASH"_$ARCH.deb не найден"
        echo "Проверьте наличие всех пакетов"
        exit 1
    else
        echo "$NAME-$VERSION-server-nls_"$VERSIONWITHDASH"_$ARCH.deb НАЙДЕН"
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
dpkg -x "$NAME-$VERSION-client_"$VERSIONWITHDASH"_$ARCH.deb" .
dpkg -x "$NAME-$VERSION-client-nls_"$VERSIONWITHDASH"_$ARCH.deb" .
dpkg -x "$NAME-$VERSION-server_"$VERSIONWITHDASH"_$ARCH.deb" .
dpkg -x "$NAME-$VERSION-server-nls_"$VERSIONWITHDASH"_$ARCH.deb" .

# Генерация файла .desktop
DESKTOPFILE="1cestart.""$VERSIONWITHDASH"".desktop"
touch "$DESKTOPFILE"

#DEBUG

echo "[Desktop Entry]" >> "$DESKTOPFILE"
echo "Version=1.0" >> "$DESKTOPFILE"
echo "Type=Application" >> "$DESKTOPFILE"
echo "Terminal=false" >> "$DESKTOPFILE"
echo "Exec=/opt/1C/v"$VERSIONWITHDASH"/1cestart" >> "$DESKTOPFILE"
echo "Categories=Office;Finance;" >> "$DESKTOPFILE"
echo "Name[ru_RU]=1C:Предприятие" "$VERSIONWITHDASH" >> "$DESKTOPFILE"
echo "Name=1C:Enterprise" "$VERSIONWITHDASH" >> "$DESKTOPFILE"
echo "Icon=1cestart" >> "$DESKTOPFILE"

# Если пользователь согласился на установку:
if [[ $SETUP != 0 ]]
    then
        sudo mv "opt/1cv8/x86_64/$VERSION" "/opt/1C/v""$VERSIONWITHDASH"
        sudo desktop-file-install "1cestart.""$VERSIONWITHDASH"".desktop"
    else
        tar -cpzf 1C_"$VERSIONWITHDASH".tgz opt
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
