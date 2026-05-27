#!/bin/bash
set -e

if [ ! -d /var/lib/mysql/mysql ]; then
  echo "MySQL inicializálás..."
  mysql_install_db --user-mysql --ldata=var/lib/mysql
fi

mysqld_safe --skip-networking &
sleep 5

if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
  echo "Root jelszó beállítása..."
  mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
fi

if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
  echo "Remote root jelszó beállítása..."
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;"
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
fi

if [ -n "$MYSQL_DATABASE" ]; then
  echo "Adatbázis létrehozása: $MYSQL_DATABASE"
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \'$MYSQL_DATABASE\';"
fi

mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

exec "$@"