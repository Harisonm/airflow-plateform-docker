#!/bin/bash

export AIRFLOW__CORE__SQL_ALCHEMY_CONN=${AIRFLOW__CORE__SQL_ALCHEMY_CONN:-`echo $AIRFLOW_CONN_POSTGRES_DEFAULT | cut -d'?' -f 1`}
export AIRFLOW_CONN_POSTGRES_VSD={$AIRFLOW_CONN_POSTGRES_VSD:-$AIRFLOW__CORE__SQL_ALCHEMY_CONN}
airflow db init  # db init is not destructive, so can be re-run at startup
airflow db upgrade  # upgrade DB if needed
python scripts/mkvars.py

# creating an admin and regular users (necessary when using RABC=True in the airflow.cnf)
airflow users create -r Admin -u admin -e admin@example.com -f admin -l admin -p ${AIRFLOW_USER_ADMIN_PASSWD:-admin}

airflow users create -r User -u dataservices -e dataservices@example.com -f dataservices -l dataservices -p ${AIRFLOW_USER_DATASERVICES_PASSWD:-dataservices}
airflow users create -r User -u team_ruimte -e team_ruimte@example.com -f team_ruimte -l team_ruimte -p ${AIRFLOW_USER_TEAM_RUIMTE_PASSWD:-team_ruimte}

# Airflow does not support slack connection config through environment var
# So we (re-)create the slack connection on startup.
#
# WARNING: DEPRECATED way of creating Connections, please use Env variables.
airflow connections delete slack
airflow connections add slack --conn-host $SLACK_WEBHOOK_HOST \
    --conn-password "/$SLACK_WEBHOOK" --conn-type http

# airflow variables -i vars/vars.json &
# airflow scheduler &
# airflow webserver
airflow variables import vars/vars.json
# create airflow pools
airflow pools import /usr/local/airflow/config/pools.json

# Check all dags by running them as python modules.
# This is whait the Airflow dagbag is also doing.
# If one of the DAGs fails, the check script exits
# with a non-zero exit state.
# A fully configured Airflow instance is needed to be able
# to run the checkscript.
# Make sure that the the containing shell script (run.sh)
# stops on errors (set -e).
#python scripts/checkdags.py || exit

# sleep infinity
/usr/local/bin/supervisord --config /usr/local/airflow/etc/supervisord.conf
