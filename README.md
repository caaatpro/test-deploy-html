# Пример автоматического деплоя проекта на Angular

## Настройка
1. Генерируем пару ключей. ssh-keygen -t ed25519
2. Передаём их на сервер. Пример: cat ./rsa.pub | ssh USER@HOST -p 2 'cat >> ~/.ssh/authorized_keys'
3. Перейти в Settings -> Secrets and variables -> Actions
4. В разделе Repository secrets добавить следующие переменные:
   SSH_HOST - хост сервера. Пример: 123.123.123.123
   SSH_PORT - порт. Пример: 22
   SSH_USER - имя пользователя. Пример: user
   SSH_KEY - Приватный SSH Key
   SERVER_PATH_SCRIPTS - путь до скриптов деплоя на сервере. Пример: /home/user/deploy/test-site
5. Заполнить scripts/.env файл по примеру .env.example
6. Загрузить папку scripts на сервер. ВАЖНО! Не в корень сайта.
   Пример: /home/user/deploy/test-site
7. Для работы скрипта на сервере требуется утилита rsync

## Как это работает?
При пуше в ветку "master" (указывается в файле .github/workflows/deploy_site.yml) происходит сборка проекта
При успешной сборке, проект упаковывается в архив {текущая дата-время}.tar.gz
После этого архивы загружаются на сервер и запускается скрипт site-deploy.sh
Скрипт распаковывает архив site-latest.tar.gz и заменяет файлы сайта на файлы из архива
