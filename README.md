# Пример автоматического деплоя проекта на Angular

## Настройка
1. Перейти в Settings -> Secrets and variables -> Actions
2. В разделе Repository secrets добавить следующие переменные:
   SSH_HOST - хост сервера. Пример: 123.123.123.123
   SSH_PORT - порт. Пример: 22
   SSH_USER - имя пользователя. Пример: user
   SSH_KEY - Приватный SSH Key
   SERVER_PATH_SCRIPTS - путь до скриптов деплоя на сервере. Пример: /home/user/deploy/test-site/
3. Заполнить scripts/.env файл по примеру .env.example
4. Загрузить папку scripts на сервер. ВАЖНО! Не в корень сайта.
   Пример: /home/user/deploy/test-site/

## Как это работает?
При пуше в ветку "release" (указывается в файле .github/workflows/deploy_site.yml) происходит сборка проекта.
При успешной сборке, проект упаковывается в два архива: site-latest.tar.gz и {текущая дата-время}.tar.gz.
После этого архивы загружаются на сервер и запускается скрипт site-deploy.sh
Скрипт распаковывает архив site-latest.tar.gz и заменяет файлы сайта на файлы из архива