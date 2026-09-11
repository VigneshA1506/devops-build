pipeline {
    agent any
 
    environment {
        DOCKER_IMAGE = "vickyamav/dev"
        DOCKER_CREDENTIALS = "dockerhub-credentials"
    }
 
    stages {
 
        stage('Checkout') {
            steps {
                echo "Checking out dev branch..."
                checkout scm
            }
        }
 
        stage('Docker Build') {
            steps {
                echo "Building Docker image..."
                sh '''
                    docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                '''
            }
        }
 
        stage('Docker Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${DOCKER_CREDENTIALS}",
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                    '''
                }
            }
        }
 
        stage('Docker Push') {
            steps {
                echo "Pushing image to Docker Hub..."
                sh '''
                    docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                '''
            }
        }
 
        stage('Docker Logout') {
            steps {
                sh '''
                    docker logout
                '''
            }
        }
    }
 
    post {
        success {
            echo "DEV image pushed successful: ${DOCKER_IMAGE}:${BUILD_NUMBER}"
        }
 
        failure {
            echo "DEV pipeline failed."
        }
    }
}