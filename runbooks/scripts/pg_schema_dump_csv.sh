#!/usr/bin/env zsh

export PGDATABASE="schemabook_development"
export PGUSER="mkrisher"

psql -Atc "select schema_name from information_schema.schemata" |\
  while read SCHEMA; do
  echo "$SCHEMA"

  if [[ "$SCHEMA" != "pg_catalog" && "$SCHEMA" != "information_schema" ]]; then
      psql -Atc "select tablename from pg_tables where schemaname='$SCHEMA'" |\
          while read TBL; do
              psql -c "COPY $SCHEMA.$TBL TO STDOUT WITH CSV DELIMITER ';' HEADER ENCODING 'UTF-8'" > $SCHEMA.$TBL.csv
          done
  fi
  done
