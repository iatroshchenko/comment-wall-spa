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

## Prepare Section
prepare-dev: libraries compile-assets

## Assets and Libs
libraries:
	docker-compose -f docker-compose.libs.yml up -d --build --remove-orphans
	docker-compose run --rm php-fpm composer install
	docker-compose -f docker-compose.libs.yml down --remove-orphans

compile-assets:
	docker run -v $(PWD):/app node:16-alpine3.11 /bin/sh -c "cd /app && npm install"
	docker run -v $(PWD):/app node:16-alpine3.11 /bin/sh -c "cd /app && npm run production"

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
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'rm -rf ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'mkdir ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && mkdir env'
	scp -o StrictHostKeyChecking=no -P ${PORT} docker-compose.prod.yml ${USER}@${HOST}:${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}/docker-compose.prod.yml
	scp -o StrictHostKeyChecking=no -P ${PORT} .env.production ${USER}@${HOST}:${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}/env/.env.production
	scp -o StrictHostKeyChecking=no -P ${PORT} .env.database ${USER}@${HOST}:${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}/env/.env.database
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && echo IMAGE_TAG=${BUILD_NUMBER} >> ./env/.env.production'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml pull'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml up -d --build --remove-orphans'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml run --rm app-php-fpm wait-for-it mysql:3306 -t 30'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml run --rm app-php-fpm php artisan migrate --force'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'rm -f ${COMPOSE_PROJECT_NAME}'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'ln -sr ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} ${COMPOSE_PROJECT_NAME}'

shutdown:
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} && docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml down --remove-orphans'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'rm -rf ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER}'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'rm -rf ${COMPOSE_PROJECT_NAME}'

rollback:
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} &&  docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml pull'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'cd ${COMPOSE_PROJECT_NAME}_${BUILD_NUMBER} &&  docker-compose --env-file ./env/.env.production -f docker-compose.prod.yml up --build --remove-orphans -d'
	ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} 'rm -f ${COMPOSE_PROJECT_NAME}'

## CI/CD
ci__unit-tests:
	docker-compose run --rm php-fpm composer test

ci__laravel-dusk:
	## runs on test environment
	docker-compose --env-file .env.test -f docker-compose.test.yml run --rm app-php-fpm php artisan dusk

## Environment Section -- DEV
## In DEV we don't use production images, so there's no mentions of "build command"
dev-start: dev-prepare dev-pull dev-build dev-up

dev-prepare: libraries compile-assets

dev-pull:
	docker-compose pull --include-deps

dev-migrations:
	docker-compose run --rm php-fpm wait-for-it mysql:3306 -t 30
	docker-compose run --rm php-fpm php artisan migrate --force

dev-build:
	docker-compose build --pull

dev-up:
	docker-compose up -d

dev-destroy:
	docker-compose down -v --remove-orphans

## Environment Section -- TESTING
test-prepare-env:
	echo "IMAGE_TAG=${BUILD_NUMBER}" >> .env.test

test-pull:
	docker-compose --env-file .env.test -f docker-compose.test.yml pull --include-deps --ignore-pull-failures || true

test-start:
	docker-compose --env-file .env.test -f docker-compose.test.yml up -d

test-migrations:
	docker-compose --env-file .env.test -f docker-compose.test.yml run --rm app-php-fpm wait-for-it mysql:3306 -t 30
	docker-compose --env-file .env.test -f docker-compose.test.yml run --rm app-php-fpm php artisan migrate --force

test-destroy:
	docker-compose --env-file .env.test -f docker-compose.test.yml down -v --remove-orphans

## validate Jenkinsfile
jenkins-validate:
	curl --user ${JENKINS_VALIDATE_USER} -X POST -F "jenkinsfile=<Jenkinsfile" ${JENKINS_VALIDATE_HOST}/pipeline-model-converter/validate

## Remove .env
remove-env-files:
	rm .env
	rm .env.test
	rm .env.production
	rm .env.database
