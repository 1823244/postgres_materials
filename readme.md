
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

#ff
#ff
#ff
#ff