pipeline {
    agent any

    environment {
        APP_NAME = 'vle7-demo'
        K8S_NAMESPACE = 'default'
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Build Docker image') {
            steps {
                sh '''
                    docker build -t ${APP_NAME}:${BUILD_NUMBER} app/
                    minikube image load ${APP_NAME}:${BUILD_NUMBER}
                '''
            }
        }

        stage('Verify Kubernetes access') {
            steps {
                sh 'kubectl get nodes'
            }
        }

        stage('Deploy to Minikube') {
            steps {
                sh '''
                    kubectl apply -f k8s/
                    kubectl set image deployment/${APP_NAME} ${APP_NAME}=${APP_NAME}:${BUILD_NUMBER} -n ${K8S_NAMESPACE}
                    kubectl rollout status deployment/${APP_NAME} -n ${K8S_NAMESPACE} --timeout=120s
                    kubectl get deployment,service,pods -l app=${APP_NAME} -n ${K8S_NAMESPACE}
                '''
            }
        }
    }

    post {
        success { echo 'VLE-7 deployment completed successfully.' }
        failure { echo 'Pipeline failed. Check Docker and Kubernetes access from Jenkins.' }
    }
}
