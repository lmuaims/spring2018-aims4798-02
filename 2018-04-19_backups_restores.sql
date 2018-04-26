-- Backup All Tables in a Specified Database
mysqldump -u aims -p classwork > classwork_2018041901.sql

-- Backup All Databases
mysqldump -u aims -p --all-databases > all_databases_2018041901.sql

-- Restore
mysql -u aims -p sakila_restore_2018041901 < sakila_film_actor_2018041901.sql
