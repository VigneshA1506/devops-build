pipeline {
 
    agent any
 
    stages {
 
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
 
        stage('Checkout') {
            steps {
                echo "Checking out source code..."
                sh 'git status'
                sh 'git branch'
            }
        }
 
        stage('Set Docker Image') {
            steps {
                script {
 
                    if (env.JOB_NAME == 'devops-build-master') {
                        env.DOCKER_IMAGE = 'vickyamav/prod'
                    } else {
                        env.DOCKER_IMAGE = 'vickyamav/dev'
                    }
 
                    echo "Jenkins Job: ${env.JOB_NAME}"
                    echo "Docker Image: ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                }
            }
        }
 
        stage('Docker Build') {
            steps {
                script {
 
                    echo "Building Docker image..."
 
                    sh """
                        docker build \
                        -t ${DOCKER_IMAGE}:${BUILD_NUMBER} \
                        .
                    """
 
                    echo "Docker image built successfully."
                }
            }
        }
 
        stage('Docker Login') {
            steps {
                script {
 
                    echo "Logging in to Docker Hub..."
 
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'dockerhub-credentials',
                            usernameVariable: 'DOCKER_USERNAME',
                            passwordVariable: 'DOCKER_PASSWORD'
                        )
                    ]) {
 
                        sh '''
                            echo "$DOCKER_PASSWORD" | docker login \
                            -u "$DOCKER_USERNAME" \
                            --password-stdin
                        '''
                    }
 
                    echo "Docker Hub login successful."
                }
            }
        }
 
        stage('Docker Push') {
            steps {
                script {
 
                    echo "Pushing Docker image..."
 
                    sh """
                        docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    """
 
                    echo "Docker image pushed successfully."
                }
            }
        }
 
        stage('Docker Logout') {
            steps {
                sh 'docker logout'
 
                echo "Docker Hub logout successful."
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
 
        always {
            echo "Pipeline execution completed."
        }
    }
}