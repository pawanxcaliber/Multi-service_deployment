pipeline {
    agent any

    environment {
        // The URL of your GitHub repository
        GITHUB_REPO_URL = 'https://github.com/pawanxcaliber/Multi-service_deployment.git'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "${GITHUB_REPO_URL}"
            }
        }
        
        // This stage is not strictly necessary for Render's deployment, but it is part of a complete CI workflow
        stage('Build Docker Images') {
            steps {
                script {
                    echo 'Building backend Docker image...'
                    dir('backend') {
                        docker.build("backend-image:${env.BUILD_NUMBER}")
                    }
                    echo 'Building frontend Docker image...'
                    dir('frontend') {
                        docker.build("frontend-image:${env.BUILD_NUMBER}")
                    }
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    echo 'Applying Terraform configuration...'
                    dir('.') {
                        // Use a Docker container for Terraform
                        docker.image('hashicorp/terraform:latest').inside {
                            // Load the API key from Jenkins credentials and map it to the variable expected by Terraform
                            withCredentials([string(credentialsId: 'RENDER_API_KEY', variable: 'RENDER_API_KEY_SECRET')]) {
                                sh 'terraform init -no-color'
                                sh "terraform apply -auto-approve -no-color -var=\"render_api_key=${RENDER_API_KEY_SECRET}\" -var=\"your_repository=${GITHUB_REPO_URL}\" -var=\"render_owner_id=tea-d07mjgruibrs73fkpju0\""
                            }
                        }
                    }
                }
            }
        }
    }
}