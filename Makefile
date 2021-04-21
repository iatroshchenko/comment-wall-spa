include .env
export $(shell sed 's/=.*//' .env)

up:
	docker-compose up

watch:
	npm run watch

sh:
	docker-compose exec php-fpm bash

ssh:
	ssh forge@${HOST}