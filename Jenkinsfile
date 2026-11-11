
pipeline {
    agent any

    environment {
        APP_NAME = 'vle7-demo'
        K8S_NAMESPACE = 'default'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
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
                    # Apply the deployment with the image built in this pipeline.
                    # This avoids creating an intermediate rollout with :local.
                    sed "s|vle7-demo:local|${APP_NAME}:${BUILD_NUMBER}|g" \
                        k8s/deployment.yaml | kubectl apply -f -

                    kubectl apply -f k8s/service.yaml

                    kubectl rollout status deployment/${APP_NAME} \
                        -n ${K8S_NAMESPACE} --timeout=240s

                    kubectl get deployment,service,pods \
                        -l app=${APP_NAME} -n ${K8S_NAMESPACE}
                '''
            }
        }
    }

    post {
        success {
            echo 'VLE-7 deployment completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check Docker, Minikube image loading and Kubernetes events.'
        }
    }
}
