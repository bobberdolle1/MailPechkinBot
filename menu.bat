@echo off
chcp 65001 >nul
color 0A
title MailPechkinBot - Меню управления

:menu
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        MailPechkinBot - Меню управления                   ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo  [1] 🚀 Запустить бота (Poetry)
echo  [2] 🐳 Собрать Docker образ
echo  [3] 🏃 Запустить через Docker Compose
echo  [4] 🛑 Остановить Docker контейнер
echo  [5] 📊 Показать статус контейнера
echo  [6] 📋 Показать логи контейнера
echo  [7] 🔄 Перезапустить контейнер
echo  [8] 🧹 Очистить Docker (контейнеры и образы)
echo  [9] 📦 Установить зависимости (Poetry)
echo  [10] 🔧 Создать .env файл из примера
echo  [11] ℹ️  Информация о боте
echo  [0] ❌ Выход
echo.
echo ══════════════════════════════════════════════════════════
set /p choice="Выберите опцию: "

if "%choice%"=="1" goto poetry_run
if "%choice%"=="2" goto docker_build
if "%choice%"=="3" goto docker_up
if "%choice%"=="4" goto docker_down
if "%choice%"=="5" goto docker_status
if "%choice%"=="6" goto docker_logs
if "%choice%"=="7" goto docker_restart
if "%choice%"=="8" goto docker_clean
if "%choice%"=="9" goto poetry_install
if "%choice%"=="10" goto create_env
if "%choice%"=="11" goto info
if "%choice%"=="0" goto exit
goto menu

:poetry_run
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        Запуск бота через Poetry                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
if not exist .env (
    echo ⚠️  Внимание: файл .env не найден!
    echo Создайте файл .env с TELEGRAM_BOT_TOKEN
    echo.
    pause
    goto menu
)
echo 🚀 Запускаю бота...
poetry run python bot.py
pause
goto menu

:docker_build
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        Сборка Docker образа                               ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo 🔨 Собираю Docker образ...
docker-compose build
echo.
if %errorlevel% equ 0 (
    echo ✅ Образ успешно собран!
) else (
    echo ❌ Ошибка при сборке образа!
)
pause
goto menu

:docker_up
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        Запуск через Docker Compose                        ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
if not exist .env (
    echo ⚠️  Внимание: файл .env не найден!
    echo Создайте файл .env с TELEGRAM_BOT_TOKEN
    echo.
    pause
    goto menu
)
echo 🏃 Запускаю контейнер...
docker-compose up -d
echo.
if %errorlevel% equ 0 (
    echo ✅ Контейнер успешно запущен!
    echo 📋 Используйте опцию [6] для просмотра логов
) else (
    echo ❌ Ошибка при запуске контейнера!
)
pause
goto menu

:docker_down
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        Остановка Docker контейнера                        ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo 🛑 Останавливаю контейнер...
docker-compose down
echo.
if %errorlevel% equ 0 (
    echo ✅ Контейнер остановлен!
) else (
    echo ❌ Ошибка при остановке контейнера!
)
pause
goto menu

:docker_status
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        Статус Docker контейнера                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
docker-compose ps
echo.
echo ══════════════════════════════════════════════════════════
docker stats --no-stream mailpechkinbot 2>nul
if %errorlevel% neq 0 (
    echo ⚠️  Контейнер не запущен
)
pause
goto menu

:docker_logs
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        Логи Docker контейнера                             ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo 📋 Показываю последние 50 строк логов (Ctrl+C для выхода)...
echo.
docker-compose logs --tail=50 -f
pause
goto menu

:docker_restart
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        Перезапуск Docker контейнера                       ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo 🔄 Перезапускаю контейнер...
docker-compose restart
echo.
if %errorlevel% equ 0 (
    echo ✅ Контейнер перезапущен!
) else (
    echo ❌ Ошибка при перезапуске контейнера!
)
pause
goto menu

:docker_clean
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        Очистка Docker                                     ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo ⚠️  ВНИМАНИЕ: Это удалит все остановленные контейнеры и образы!
set /p confirm="Продолжить? (y/n): "
if /i not "%confirm%"=="y" goto menu
echo.
echo 🧹 Останавливаю контейнеры...
docker-compose down
echo 🧹 Удаляю образы...
docker-compose down --rmi all --volumes
echo 🧹 Очищаю систему...
docker system prune -f
echo.
echo ✅ Очистка завершена!
pause
goto menu

:poetry_install
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        Установка зависимостей                             ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo 📦 Проверяю установку Poetry...
poetry --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Poetry не установлен!
    echo 📖 Установите Poetry: https://python-poetry.org/docs/#installation
    pause
    goto menu
)
echo.
echo 📦 Устанавливаю зависимости...
poetry install
echo.
if %errorlevel% equ 0 (
    echo ✅ Зависимости установлены!
) else (
    echo ❌ Ошибка при установке зависимостей!
)
pause
goto menu

:create_env
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        Создание .env файла                                ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
if exist .env (
    echo ⚠️  Файл .env уже существует!
    set /p overwrite="Перезаписать? (y/n): "
    if /i not "%overwrite%"=="y" goto menu
)
echo.
copy .env.example .env >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Файл .env создан из .env.example
    echo.
    echo 📝 Отредактируйте файл .env и добавьте ваш TELEGRAM_BOT_TOKEN
    echo 💡 Получить токен: https://t.me/BotFather
) else (
    echo ❌ Ошибка: файл .env.example не найден!
)
pause
goto menu

:info
cls
echo ╔═══════════════════════════════════════════════════════════╗
echo ║        MailPechkinBot - Информация                        ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo 📧 Telegram-бот для работы с временной почтой
echo 🔧 Версия: 1.0.0
echo.
echo 📋 Требования:
echo   • Python 3.11+
echo   • Poetry (для локального запуска)
echo   • Docker и Docker Compose (для контейнеризации)
echo.
echo 🚀 Быстрый старт:
echo   1. Создайте .env файл (опция 10)
echo   2. Добавьте TELEGRAM_BOT_TOKEN в .env
echo   3. Запустите бота (опция 1 или 3)
echo.
echo 📖 Документация: README.md
echo 🐛 Баги: GitHub Issues
echo.
pause
goto menu

:exit
cls
echo.
echo 👋 До свидания!
timeout /t 2 >nul
exit
