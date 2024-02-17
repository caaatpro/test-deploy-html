#!/bin/bash

# Сохраняем в переменную BASEDIR путь к каталогу, где находится скрипт
BASEDIR=$(dirname $(realpath "$0"))

env_file="$BASEDIR/.env"

if [[ -f "$env_file" ]]; then
   source "$env_file"
else
   echo "Файл .env не найден"
   exit 1
fi

archive_file=$(ls -lt $BUILDS_FOLDER/*.tar.gz | head -n 1 | awk '{print $NF}')
temp_build="$BASEDIR/temp_build"
mkdir -p "$temp_build"
tar -xzf "$archive_file" -C "$temp_build"

temp_old="$BASEDIR/temp_old"
mkdir -p "$temp_old"

exlude_list=$(mktemp)
printf "%s\n" "${EXCLUDE_FILES}" > "${exlude_list}"

echo "${EXCLUDE_FILES}" | sed -e 's/ /\n/g' > "${exlude_list}"

# Копируем предыдущий сайт
rsync -av --exclude-from="${exlude_list}" --remove-source-files --prune-empty-dirs "$SITE_FOLDER"/ "$temp_old"/

# Копируем новый
rsync -av "$temp_build"/ "$SITE_FOLDER"/

# Удаляем временный файл
rm "$exlude_list"
rm -rf "$temp_build"
rm -rf "$temp_old"

# Удаляем лишние билды
ls -lt ${BUILDS_FOLDER}/*.tar.gz | tail -n +$((NUM_TO_KEEP + 1)) | awk '{print $NF}' | xargs rm -f