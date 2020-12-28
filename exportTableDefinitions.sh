#!/bin/sh
DBPASSWORD="dbpassword"
DBNAME="dbname"
DBHOST="dbhost"

MYSQLPARTCOMMAND="mysql --defaults-file=<(printf '[client]\npassword=%s\n' $DBPASSWORD) -h $DBHOST -u user $DBNAME -e"

mkdir -p ./tableDefinitions

i=0
for var in `eval "$MYSQLPARTCOMMAND 'show tables;'" | xargs -n1`
do
  if [ $i -ne 0 ]; then
    eval "$MYSQLPARTCOMMAND 'desc $var;'" | sed -e 's/^/"/g' | sed -e 's/$/"/g' | sed -e 's/\t/","/g' > ./tableDefinitions/$var.csv
  fi

  i=$(( i + 1 ))
done
