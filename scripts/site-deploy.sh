#!/bin/bash

env_file="./.env"

if [[ -f "$env_file" ]]; then
   source "$env_file"
else
   echo $(pwd)
   # echo "Файл .env не найден"
   exit 1
fi

last_build=$(ls -lt site-*.tar.gz | head -n 1 | awk '{print $NF}')
archive_file="$BUILDS_FOLDER/$last_build"
temp_build="./temp_build"
mkdir -p "$temp_build"
tar -xzf "$archive_file" -C "$temp_build"

temp_old="./temp_old"
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