#!/usr/bin/env bash

# Environment and airflow config parameters are in $AIRFLOW_HOME/config.env.
# Make them accessible within the container

export $(grep -v '^#' $AIRFLOW_HOME/config.env | xargs)

# Poll for metadata mysql instance
while ! nc -z $MYSQLDB_SERVICE_NAME 3306; do
    sleep 5
done

# Poll for Redis Celery broker
while ! nc -z $REDIS_SERVICE_NAME 6379; do
    sleep 5
done

# Used to avoid running airflow init in case airflow container instance is persisted onto host volume.
airflow_init_f="$AIRFLOW_HOME/init_true"

if [[ "$1" == "webserver" ]]; then
    if [ ! -f $airflow_init_f ]
    then 
      # - cwl-airflow init runs an "airflow initdb".
      cwl-airflow init
      # - Flag the initialisation is complete so that we don't go through these steps
      #   each time we bring up the airflow containers
      touch $airflow_init_f
      # - Create a user for Airflow webui
      airflow create_user --role Admin --username $WEBUI_ADMIN_USER \
      --email admin@admin.org \
      --firstname admin \
      --lastname admin \
      --password $WEBUI_ADMIN_PASSWORD
    fi
    airflow webserver &
    cwl-airflow api --host 0.0.0.0 --port 8081
fi

# Wait 20 seconds.  THis should  be enough time for "cwl-airflow init" to run when initialising the backend db.  There's likely
# to be a much better way of doing this
sleep 20
if [[ "$1" == "scheduler" ]]; then
    airflow scheduler

fi

if [[ "$1" == "worker" ]]; then

    airflow worker

fi

if [[ "$1" == "flower" ]]; then

    airflow flower

fi