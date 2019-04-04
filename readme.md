
# Объясняя необъяснимое. Часть 2
нюансы планов запросов  

https://habr.com/ru/post/276973/

# Включить логирование текстов запросов

## оф документация
https://www.postgresql.org/docs/current/runtime-config-logging.html

## коротко
http://pgcookbook.ru/article/slow_queries_search.html

Задача
Необходимо найти долговыполняющиеся запросы к базе данных.

Решение
Необходимо включить вывод в лог запросов, длительность которых больше заданной длительности.

Для этого в файле postgresql.conf (он в каталоге data) необходимо установить следующие параметры:

log_duration = on                # Включает логирование запросов
log_min_duration_statement = 1   # Устанавливает минимальное время (в миллисекундах) выполнения запроса, который попадает в лог

и перезагрузить сервер

Логи находятся в папке data\log

# Второй кластер на одном сервере Windows

Чтобы запустить несколько инстансов на одной машине, надо проинициализировать кластеры в нужных папках данных (data)  

Здесь инструкции по запуску второго сервиса  
http://qaru.site/questions/719223/create-multiple-postgres-instances-on-same-machine  
(  
$ pg_ctl -D /path/to/datadb1 -o "-p 5433" -l /path/to/logdb1 start  
$ pg_ctl -D /path/to/datadb2 -o "-p 5434" -l /path/to/logdb2 start  
)  

## Примеры  

initdb -D d:\PostgreSQL1C11\datavi --locale=Russian_Russia --encoding=UTF8  
initdb -D d:\PostgreSQL1C11\datavi --locale=Vietnamese_Vietnam --encoding=UTF8  

старт сервиса (на указанном порту. считаем, что 5432 занят первым инстансом) 
pg_ctl -D ^"d^:^\PostgreSQL1C11^\datavi^" -o "-p 5433" -l logfile start
(logfile создается в каталоге bin) 

## Кодировки (локали)
Где брать, пока не понятно.
Вариант --locale=Russian_Russia найден в интернете, --locale=Vietnamese_Vietnam подобран экспериментально


## Еще ссылки  
https://infostart.ru/public/21930/

#ff
#ff
#ff
