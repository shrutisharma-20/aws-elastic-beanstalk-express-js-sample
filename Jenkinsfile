pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'shrutisharma2003/isec6000-assessment-2:latest'
        DOCKER_HOST = 'tcp://jenkins-docker:2375'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh '''
                    docker run --rm \
                    -v "$WORKSPACE:/app" \
                    -w /app \
                    node:16 npm install
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                    docker run --rm \
                    -v "$WORKSPACE:/app" \
                    -w /app \
                    node:16 npm test
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Security Scan') {
            steps {
                sh '''
                    docker run --rm \
                        --add-host=jenkins-docker:host-gateway \
                        -e DOCKER_HOST=tcp://jenkins-docker:2375 \
                        aquasec/trivy:latest image \
                        --severity HIGH,CRITICAL \
                        --exit-code 1 \
                        $DOCKER_IMAGE
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKERHUB_PASSWORD" | docker login \
                        -u "$DOCKERHUB_USER" --password-stdin

                        docker push $DOCKER_IMAGE

                        docker logout
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }

        success {
            echo 'Build, security scan, and Docker Hub push completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Review the Jenkins logs.'
        }
    }
}
