pipeline {
    agent any
 
    environment {
        DOCKER_CREDENTIALS = 'dockerhub-credentials'
    }
 
    stages {
 
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
 
        stage('Set Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'master') {
                        env.DOCKER_IMAGE = 'vickyamav/prod'
                    } else {
                        env.DOCKER_IMAGE = 'vickyamav/dev'
                    }
 
                    echo "Branch: ${env.BRANCH_NAME}"
                    echo "Docker Image: ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                }
            }
        }
 
        stage('Docker Build') {
            steps {
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
                sh '''
                    docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                '''
            }
        }
 
        stage('Docker Logout') {
            steps {
                sh 'docker logout'
            }
        }
    }
 
    post {
        success {
            echo "SUCCESS: ${DOCKER_IMAGE}:${BUILD_NUMBER} pushed to Docker Hub."
        }
 
        failure {
            echo "Pipeline failed."
        }
    }
}