include .env
export $(shell sed 's/=.*//' .env)

up:
	docker-compose up

watch:
	npm run watch

sh:
	docker-compose exec php-fpm bash

ssh:
	ssh ${USER}@${HOST}


## Build Section
build: build-gateway build-app build-testing
build-testing: build-testing-gateway

build-app: build-app-nginx build-app-php-fpm

build-gateway:
	docker --log-level=debug build --pull --file=./docker/build/gateway/nginx/Dockerfile --tag=${REGISTRY}/cw-gateway:${IMAGE_TAG} ./

build-app-nginx:
	docker --log-level=debug build --pull --file=./docker/build/app/nginx/Dockerfile --tag=${REGISTRY}/cw-app-nginx:${IMAGE_TAG} ./

build-app-php-fpm:
	docker --log-level=debug build --pull --file=./docker/build/app/php-fpm/Dockerfile --tag=${REGISTRY}/cw-app-php-fpm:${IMAGE_TAG} ./

build-testing-gateway:
	docker build --pull --file=./docker/testing/gateway/nginx/Dockerfile --tag=${REGISTRY}/cw-gateway-testing:${IMAGE_TAG} ./


## Push Section
push: push-gateway push-app-nginx push-app-php-fpm push-testing
push-testing: push-testing-gateway

push-gateway:
	docker push ${REGISTRY}/cw-gateway:${IMAGE_TAG}

push-app-nginx:
	docker push ${REGISTRY}/cw-app-nginx:${IMAGE_TAG}

push-app-php-fpm:
	docker push ${REGISTRY}/cw-app-php-fpm:${IMAGE_TAG}

push-testing-gateway:
	docker push ${REGISTRY}/cw-gateway-testing:${IMAGE_TAG}

## Deploy Section
redeploy-full: shutdown build push deploy
redeploy-current: shutdown deploy

deploy:
	ssh ${USER}@${HOST} -p ${PORT} 'rm -rf ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}'
	ssh ${USER}@${HOST} -p ${PORT} 'mkdir ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}'
	ssh ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && mkdir env'
	scp -P ${PORT} docker-compose.prod.yml ${USER}@${HOST}:${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}/docker-compose.prod.yml
	scp -P ${PORT} .env ${USER}@${HOST}:${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}/env/.env
	scp -P ${PORT} .env.production ${USER}@${HOST}:${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}/env/.env.production
	scp -P ${PORT} .env.test ${USER}@${HOST}:${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}/env/.env.test
	scp -P ${PORT} .env.database ${USER}@${HOST}:${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}/env/.env.database
	ssh ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml pull'
	ssh ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml up -d --build --remove-orphans'
	ssh ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml run --rm app-php-fpm wait-for-it mysql:3306 -t 30'
	ssh ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml run --rm app-php-fpm php artisan migrate --force'
	ssh ${USER}@${HOST} -p ${PORT} 'rm -f ${COMPOSE_PROJECT_NAME}'
	ssh ${USER}@${HOST} -p ${PORT} 'ln -sr ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} ${COMPOSE_PROJECT_NAME}'

shutdown:
	ssh ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml down --remove-orphans'
	ssh ${USER}@${HOST} -p ${PORT} 'rm -rf ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}'
	ssh ${USER}@${HOST} -p ${PORT} 'rm -rf ${COMPOSE_PROJECT_NAME}'

rollback:
	ssh ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} &&  docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml pull'
	ssh ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} &&  docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml up --build --remove-orphans -d'
	ssh ${USER}@${HOST} -p ${PORT} 'rm -f ${COMPOSE_PROJECT_NAME}'

ssh:
	ssh root@${HOST}

## Testing Environment Section
testing-init:
	COMPOSE_PROJECT_NAME=testing docker-compose -f docker-compose.test.yml up --build -d
	COMPOSE_PROJECT_NAME=testing docker-compose -f docker-compose.test.yml run --rm app-php-fpm wait-for-it mysql:3306 -t 30
	COMPOSE_PROJECT_NAME=testing docker-compose -f docker-compose.test.yml run --rm app-php-fpm php artisan migrate --force

testing-down:
	COMPOSE_PROJECT_NAME=testing docker-compose -f docker-compose.test.yml down -v --remove-orphans
