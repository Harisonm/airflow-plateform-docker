# Start DEV by default
all: dev

# Stop and delete PROD container by default
stop: stop-prod rm-prod

logs:
	docker logs airflow 

####### VARIABLES #######
CURR_DIR=$(shell basename $(PWD))
DOCKERFILE=Dockerfile
DOCKER_COMPOSE=docker-compose.yml
#########################

####### DEV ENV #######
# Deploy docker DEV
dev: build-global-dev run-airflow-dev

# Build DEV docker image
build-global-dev:
	docker-compose -f ${DOCKER_COMPOSE} build
	docker-compose -f docker-compose.yml up -d database

# Run DEV container (NB: container will be deleted at Ctrl+C)
run-airflow-dev:
	docker-compose -f docker-compose.yml up -d airflow

# Stop DEV container
refresh-aiflow-dev:
	docker stop airflow && docker start airflow
#######################

####### PROD ENV #######
# Deploy docker PROD
prod: build-prod run-airflow-prod install-ssh-agent

# Build PROD docker image
build-prod:
	docker-compose -f ${DOCKER_COMPOSE} build
	docker-compose -f docker-compose.yml up -d database

# Run PROD container
run-airflow-prod:
	docker-compose -f docker-compose.yml up -d airflow

install-ssh-agent:
	docker exec airflow bash -c "apt update -y"
	docker exec airflow bash -c "apt upgrade -y"
	docker exec airflow bash -c "apt install openssh-server -y"
	docker exec airflow bash -c "apt install sshpass -y"
	docker exec airflow bash -c "systemctl enable ssh"
	docker exec airflow bash -c "service ssh start"
	docker exec airflow bash -c "/usr/sbin/sshd -D &"
	docker exec airflow bash -c "useradd -m --no-log-init --system  --uid 1000 airflow -s /bin/bash -g sudo -G root"
	docker exec airflow bash -c "echo 'airflow:dbt_serve' | chpasswd"

start-airflow-container:
	docker start airflow
	docker exec airflow bash -c "service ssh start"

check-ssh-status:
	docker exec airflow bash -c "service ssh status"
########################

# TODO ?
clean:
	echo "todo"

deploy:
	gcloud config set project loreal-sds-mgmt-dv360
	gcloud app deploy --quiet
	gcloud app browse --service sds-aeg-mgmt-dv360