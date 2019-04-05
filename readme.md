
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

log_destination = 'stderr' - оставляем
logging_collector = on - если не указать, то логи пойдут в журнал приложений windows
можно указать абсолютный путь, например D:/pg/data/log
log_duration = on                # Включает логирование запросов
log_min_duration_statement = 1   # Устанавливает минимальное время (в миллисекундах) выполнения запроса, который попадает в лог

и перезагрузить сервер

Логи находятся в папке log_directory
для основного инстанса это обычно data\log

# Второй кластер на одном сервере Windows

Чтобы запустить несколько инстансов на одной машине, надо проинициализировать кластеры в нужных папках данных (data)  

Справка initdb  
https://postgrespro.ru/docs/postgresql/9.6/app-initdb  

Здесь инструкции по запуску второго сервиса  
http://qaru.site/questions/719223/create-multiple-postgres-instances-on-same-machine  
```
$ pg_ctl -D /path/to/datadb1 -o "-p 5433" -l /path/to/logdb1 start  
$ pg_ctl -D /path/to/datadb2 -o "-p 5434" -l /path/to/logdb2 start  
```

## Примеры  

```
initdb -D D:\PostgreSQL1C11\dataru --locale=Russian_Russia --encoding=UTF8 --username=postgres --pwprompt  
initdb -D D:\PostgreSQL1C11\datavi --locale=Vietnamese_Vietnam --encoding=UTF8 --username=postgres --pwprompt  
``` 

старт инстанса (на указанном порту. считаем, что 5432 занят первым инстансом)  
```
pg_ctl -D ^"D^:^\PostgreSQL1C11^\dataru^" -o "-p 5433" -l logfile start  
pg_ctl -D ^"D^:^\PostgreSQL1C11^\datavi^" -o "-p 5434" -l logfile start  
```
(logfile создается в каталоге bin)  

стоп инстанса  
```
pg_ctl stop -D ^"D^:^\PostgreSQL1C11^\datavi^"  
```

Создадим сервис
(консоль с повышенными правами)
```  
sc create pgsql_11_vietnam displayname= "pgsql_11_vietnam" obj= ".\Admin" password= "password" start=auto binPath= "d:\PostgreSQL1C11\bin\bin\pg_ctl.exe runservice -w -N pgsql_11_vietnam -D D:\PostgreSQL1C11\datavi"
```
Здесь параметры  
obj= ".\Admin" password= "password" - это учетная запись Windows  

После создания сервиса надо зайти в postgresql.conf в новой папке данных и раскомментировать строку  
#port = 5432  
плюс указать нужный порт  

## Кодировки (локали)
Где брать, пока не понятно.  
Вариант 
```
--locale=Russian_Russia
```
найден в интернете,  
```--locale=Vietnamese_Vietnam
```
подобран экспериментально  


## Еще ссылки
  
https://infostart.ru/public/21930/  

# Запрос работает в 1С и не работает в PGAdmin JetBrains DataGrip (Postgres на Windows)
(Но работает в postgres на linux)  

Возможно, проблема в конвертации _IDRRef  
Перехваченный запрос в логе выглядит так
```
T85._Fld10662RRef = '\\221\\244\\310\\243\\357\\016\\250\\026M5\\324\\363\\304|\\337\\232'::bytea  
```

Чтобы это условие правильно работало на PG windows, нужно  
1) убрать `::bytea`
2) заменить `\\` на `\`

Эта функция переводит эскейп-запись в более привычную (сначала надо убрать двойные слэши)  
```
cast('+\200\000%\220r\277l\021\343\326\204\202C\367\266'::bytea as varchar)
```
получим  
```
\x2b8000259072bf6c11e3d6848243f7b6
```

Если не убрать двойные слэши, получим другой результат  
```
\x2b5c3230305c303030255c323230725c3237376c5c3032315c3334335c3332365c3230345c323032435c3336375c323636
```

#ff
#ff
