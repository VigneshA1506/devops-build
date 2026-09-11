pipeline {
    agent any
 
    environment {
        DOCKERHUB_USER = 'vickyamav'
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
 
                    if (env.JOB_NAME == 'devops-build-master') {
                        env.DOCKER_IMAGE = 'vickyamav/prod'
                    } else {
                        env.DOCKER_IMAGE = 'vickyamav/dev'
                    }
 
                    echo "Jenkins Job    : ${env.JOB_NAME}"
                    echo "Docker Image   : ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}"
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
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_TOKEN'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_TOKEN" | docker login \
                            -u "$DOCKER_USER" \
                            --password-stdin
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
                sh '''
                    docker logout || true
                '''
            }
        }
 
        stage('Test EC2 SSH') {
            when {
                expression {
                    env.JOB_NAME == 'devops-build-master'
                }
            }
 
            steps {
                sshagent(credentials: ['application-ec2-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no \
                        ec2-user@13.126.9.45 \
                        "hostname"
                    '''
                }
            }
        }
 
        stage('Deploy to Application EC2') {
            when {
                expression {
                    env.JOB_NAME == 'devops-build-master'
                }
            }
 
            steps {
 
                sshagent(credentials: ['application-ec2-ssh']) {
 
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'dockerhub-credentials',
                            usernameVariable: 'DOCKER_USER',
                            passwordVariable: 'DOCKER_TOKEN'
                        )
                    ]) {
 
                        sh '''
                            printf '%s\\n' "$DOCKER_TOKEN" | ssh \
                            -o StrictHostKeyChecking=no \
                            ec2-user@13.126.9.45 \
                            "docker login -u '$DOCKER_USER' --password-stdin && \
                             docker pull vickyamav/prod:${BUILD_NUMBER} && \
                             docker rm -f devops-app || true && \
                             docker run -d \
                             --name devops-app \
                             -p 80:80 \
                             --restart unless-stopped \
                             vickyamav/prod:${BUILD_NUMBER} && \
                             docker ps"
                        '''
                    }
                }
            }
        }
    }
 
    post {
 
        success {
            echo "========================================"
            echo "PIPELINE SUCCESSFUL"
            echo "Docker Image: ${DOCKER_IMAGE}:${BUILD_NUMBER}"
            echo "========================================"
        }
 
        failure {
            echo "========================================"
            echo "PIPELINE FAILED"
            echo "Please check the console output."
            echo "========================================"
        }
    }
}
 