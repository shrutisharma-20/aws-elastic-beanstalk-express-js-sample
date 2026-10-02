pipeline {
    agent {
        docker {
            image 'node:16'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DOCKER_IMAGE = 'shrutisharma2003/isec6000-assessment-2:latest'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'npm test'
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
                    -v /var/run/docker.sock:/var/run/docker.sock \
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
