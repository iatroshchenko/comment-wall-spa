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
    }
    stages {
        stage("create .env files") {
            steps {
                sh "echo $ENV_FILE__DEV >> .env"
                sh "echo $ENV_FILE__TEST >> .env.test"
                sh "echo $ENV_FILE__PROD >> .env.production"
                sh "echo $ENV_FILE__DB >> .env.database"
                sh "echo ENV_FILE__DEV"
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
        stage("Remove .env files") {
            steps {
                sh "rm .env"
                sh "rm .env.test"
                sh "rm .env.production"
                sh "rm .env.database"
            }
        }
    }
}
