#!/usr/bin/env bash

AIRFLOW_HOME="/usr/local/airflow"
CMD="airflow"
TRY_LOOP="10"

AIRFLOW_DB_HOST_PORT=5432
AIRFLOW_DB_HOST=${AIRFLOW_DB_HOST}
AIRFLOW_DB_USER=${AIRFLOW_DB_USER}
AIRFLOW_DB_USER_PASS=${AIRFLOW_DB_USER_PASS}
REDIS_HOST=${REDIS_HOST}

: ${FERNET_KEY:=$(python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print FERNET_KEY")}

# Load DAGs exemples (default: Yes)
if [ "x$LOAD_EX" = "xn" ]; then
    sed -i "s/load_examples = True/load_examples = False/" "$AIRFLOW_HOME"/airflow.cfg
fi

# Install custome python package if requirements.txt is present
if [ -e "/requirements.txt" ]; then
    $(which pip) install --user -r /requirements.txt
fi

# Generate Fernet key
sed -i "s|\$FERNET_KEY|$FERNET_KEY|" "$AIRFLOW_HOME"/airflow.cfg

# wait for DB
if [ "$1" = "webserver" ] || [ "$1" = "worker" ] || [ "$1" = "scheduler" ] ; then
  i=0
  while ! nc -z $AIRFLOW_DB_HOST $AIRFLOW_DB_HOST_PORT >/dev/null 2>&1 < /dev/null; do
    i=$((i+1))
    if [ $i -ge $TRY_LOOP ]; then
      echo "$(date) - ${AIRFLOW_DB_HOST}:${AIRFLOW_DB_HOST_PORT} still not reachable, giving up"
      exit 1
    fi
    echo "$(date) - waiting for ${AIRFLOW_DB_HOST}:${AIRFLOW_DB_HOST_PORT}... $i/$TRY_LOOP"
    sleep 5
  done
  if [ "$1" = "webserver" ]; then
    echo "Initialize database..."
    $CMD initdb
  fi
  sleep 5
fi

# If we use docker-compose, we use Celery (rabbitmq or external).
if [ "x$EXECUTOR" = "xCelery" ]
then
# wait for redis
  if [ "$1" = "webserver" ] || [ "$1" = "worker" ] || [ "$1" = "scheduler" ] || [ "$1" = "flower" ] ; then
    j=0
    while ! redis-cli -h $REDIS_HOST ping |grep 'PONG'; do
      j=$((j+1))
      if [ $j -ge $TRY_LOOP ]; then
        echo "$(date) - $REDIS_HOST still not reachable, giving up"
        exit 1
      fi
      echo "$(date) - waiting for Redis Server... $j/$TRY_LOOP"
      sleep 5
    done
  fi
  exec $CMD "$@"
elif [ "x$EXECUTOR" = "xLocal" ]
then
  sed -i "s/executor = CeleryExecutor/executor = LocalExecutor/" "$AIRFLOW_HOME"/airflow.cfg
  exec $CMD "$@"
else
  if [ "$1" = "version" ]; then
    exec $CMD version
  fi
  sed -i "s/executor = CeleryExecutor/executor = SequentialExecutor/" "$AIRFLOW_HOME"/airflow.cfg
  sed -i "s#sql_alchemy_conn = postgresql+psycopg2://${AIRFLOW_DB_USER}:${AIRFLOW_DB_USER_PASS}@postgres/airflow#sql_alchemy_conn = sqlite:////usr/local/airflow/airflow.db#" "$AIRFLOW_HOME"/airflow.cfg
  echo "Initialize database..."
  $CMD initdb
  exec $CMD webserver
fi
