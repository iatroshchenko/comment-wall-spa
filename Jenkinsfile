pipeline {
    agent any
    options {
        timestamps()
    }
    environment {
        // These credentials are secret files. Upload them to Jenkins in admin panel
        ENV_FILE__DEV = credentials('commentwall__env-file__dev')
        ENV_FILE__TEST = credentials('commentwall__env-file__test')
        ENV_FILE__PROD = credentials('commentwall__env-file__prod')
        ENV_FILE__DB = credentials('commentwall__env-file__db')
        DOCKER_LOGIN__USERNAME = credentials('docker-login__username')
        DOCKER_LOGIN__PASSWORD = credentials('docker-login__password')
    }
    stages {
        stage("create .env files") {
            steps {
                sh "cp $ENV_FILE__DEV .env"
                sh "cp $ENV_FILE__TEST .env.test"
                sh "cp $ENV_FILE__PROD .env.production"
                sh "cp $ENV_FILE__DB .env.database"
                sh "cat .env"
            }
        }
        stage("npm install and compile assets") {
            steps {
                sh 'make compile-assets'
            }
        }
        stage("Dev environment pull images") {
            steps {
                sh 'make dev-pull'
            }
        }
        stage("Dev environment build") {
            steps {
                sh 'make dev-build'
            }
        }
        stage("Composer - install libs") {
            steps {
                sh 'make libraries'
            }
        }
        stage("Dev environment up") {
            steps {
                sh 'make dev-up'
            }
        }
        stage("Dev run migrations") {
            steps {
                sh 'make dev-migrations'
            }
        }
        stage("Unit tests") {
             steps {
                sh 'make dev-migrations'
             }
        }
        stage("Destroy dev") {
            steps {
                sh 'make dev-destroy'
            }
        }
        stage("Test environment - Prepare env") {
            steps {
                sh 'cat .env.test'
                sh 'echo "IMAGE_TAG=${BUILD_NUMBER}" >> .env.test'
            }
        }
        stage("Test environment - Pull images") {
            steps {
                sh 'make test-pull'
            }
        }
        stage("Build production images") {
            steps {
                sh 'IMAGE_TAG=${BUILD_NUMBER} make build'
            }
        }
        stage("Start test environment") {
            steps {
                sh 'make test-start'
            }
        }
        stage("Test environment - run migrations") {
            steps {
                sh 'make test-migrations'
            }
        }
        stage("Test environment - run Laravel Dusk") {
            steps {
                sh 'make ci__laravel-dusk'
            }
        }
        stage("Destroy test environment") {
            steps {
                sh 'make test-destroy'
            }
        }
        stage("Docker login") {
            steps {
                sh 'echo ${DOCKER_LOGIN__PASSWORD} | docker login --username ${DOCKER_LOGIN__USERNAME} --password-stdin'
            }
        }
        stage("Push production images") {
            steps {
                sh 'IMAGE_TAG=${BUILD_NUMBER} make push'
            }
        }
        stage("Deploy") {
            steps {
                sshagent (credentials: ['production-ssh']) {
                    sh 'BUILD_NUMBER=${BUILD_NUMBER} make deploy'
                }
            }
        }

    }
    post {
        always {
            sh "make dev-destroy || true"
            sh "make test-destroy || true"
            sh "make remove-env-files"
        }
    }
}
