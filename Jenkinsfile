pipeline {
    agent any

    environment {
        GITHUB_REPO_URL = 'https://github.com/pawanxcaliber/Multi-service_deployment.git'
        RENDER_OWNER_ID = 'tea-d07mjgruibrs73fkpju0'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "${GITHUB_REPO_URL}"
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    echo 'Building backend Docker image...'
                    dir('backend') {
                        sh 'docker build -t backend-image:3 .'
                    }
                    echo 'Building frontend Docker image...'
                    dir('frontend') {
                        sh 'docker build -t frontend-image:3 .'
                    }
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'RENDER_API_KEY', variable: 'RENDER_API_KEY_SECRET')]) {
                        docker.image('hashicorp/terraform:latest').inside {
                            sh 'terraform init -no-color'
                            sh "terraform apply -auto-approve -no-color -var=\"render_api_key=${RENDER_API_KEY_SECRET}\" -var=\"your_repository=${GITHUB_REPO_URL}\" -var=\"render_owner_id=${RENDER_OWNER_ID}\""
                        }
                    }
                }
            }
        }
    }
}