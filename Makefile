# Utilisation :
# make up CONTAINER_PREFIX=prefix
# make down CONTAINER_PREFIX=prefix
# make pull CONTAINER_PREFIX=prefix
# make restart CONTAINER_PREFIX=prefix
# make rename-containers CONTAINER_PREFIX=prefix

CONTAINER_PREFIX ?=jeedom
PORT ?=52080
MYSQL_PASSWORD ?=jeedompass

DOCKER_COMPOSE_FILE=docker-compose.yml

rename-containers:
	@if [ -z "$(MYSQL_PASSWORD)" ]; then \
		MYSQL_PASSWORD=$$(openssl rand -base64 16 | tr -dc 'A-Za-z0-9' | head -c 16); \
		printf '\033[1;32mMot de passe MySQL généré : $$MYSQL_PASSWORD\033[0m\n'; \
	else \
		MYSQL_PASSWORD=$(MYSQL_PASSWORD); \
	fi; \
	echo "MYSQL_PASSWORD=$$MYSQL_PASSWORD" > .env; \
	echo "SERVICE_HTTP=$(CONTAINER_PREFIX)_jeedom_http" >> .env; \
	sed -i.bak \
		-e 's/jeedom_db/$(CONTAINER_PREFIX)_jeedom_db/g' \
		-e 's/jeedom_http/$(CONTAINER_PREFIX)_jeedom_http/g' \
		-e 's/v_jeedom_db/v_$(CONTAINER_PREFIX)_jeedom_db/g' \
		-e 's/v_jeedom_http/v_$(CONTAINER_PREFIX)_jeedom_http/g' \
		-e 's/\([ ]*\)- [0-9]*:80/\1- $(PORT):80/' \
		$(DOCKER_COMPOSE_FILE)

up:
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v

pull:
	docker compose -f $(DOCKER_COMPOSE_FILE) pull

stop:
	docker compose -f $(DOCKER_COMPOSE_FILE) stop

restart:
	docker compose -f $(DOCKER_COMPOSE_FILE) restart

logs:
	docker compose -f $(DOCKER_COMPOSE_FILE) logs -f

update:
	docker compose -f $(DOCKER_COMPOSE_FILE) pull
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

exec:
	@if [ -z "$(SERVICE)" ]; then \
		if [ -f .env ] && grep -q SERVICE_HTTP= .env; then \
			SERVICE=$$(grep SERVICE_HTTP .env | cut -d= -f2); \
		else \
			SERVICE=jeedom_http; \
		fi; \
	else \
		SERVICE=$(SERVICE); \
	fi; \
	if [ -z "$(CMD)" ]; then \
		echo "Usage : make exec [SERVICE=nom_du_service] CMD=commande"; \
		exit 1; \
	else \
		docker compose -f $(DOCKER_COMPOSE_FILE) exec $$SERVICE $(CMD); \
	fi

shell:
	@if [ -z "$(SERVICE)" ]; then \
		if [ -f .env ] && grep -q SERVICE_HTTP= .env; then \
			SERVICE=$$(grep SERVICE_HTTP .env | cut -d= -f2); \
		else \
			SERVICE=jeedom_http; \
		fi; \
	else \
		SERVICE=$(SERVICE); \
	fi; \
	if docker compose -f $(DOCKER_COMPOSE_FILE) exec $$SERVICE bash 2>/dev/null; then :; \
	else docker compose -f $(DOCKER_COMPOSE_FILE) exec $$SERVICE sh; fi

status:
	docker compose -f $(DOCKER_COMPOSE_FILE) ps


