#!/bin/bash

DB_CONTAINER=php-sample-db

for file in $(ls database/migrations/*.sql | sort); do
    filename=$(basename $file)

    EXISTS=$(docker exec $DB_CONTAINER \
        mysql -u root -p$MYSQL_ROOT_PASSWORD -N -e \
        "SELECT COUNT(*) FROM migrations WHERE filename='$filename'" $MYSQL_DATABASE)

    if [ "$EXISTS" -eq "0" ]; then
        echo "Running $filename"

        docker exec -i $DB_CONTAINER \
            mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < $file

        docker exec $DB_CONTAINER \
            mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE -e \
            "INSERT INTO migrations (filename) VALUES ('$filename')"
    else
        echo "Skipping $filename"
    fi
done