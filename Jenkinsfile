pipeline {
    agent any

    environment {
        // This is the ID of the secret text credential you created in Jenkins
        RENDER_API_KEY = credentials('RENDER_API_KEY')
        // The URL of your GitHub repository
        GITHUB_REPO_URL = 'https://github.com/pawanxcaliber/Multi-service_deployment.git'
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
                    // Build the backend image
                    echo 'Building backend Docker image...'
                    dir('backend') {
                        docker.build("backend-image:${env.BUILD_NUMBER}")
                    }
                    // Build the frontend image
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
                            // Initialize Terraform
                            sh 'terraform init -no-color'
                            // Apply the configuration with the variables
                            sh "terraform apply -auto-approve -no-color -var=\"render_api_key=${RENDER_API_KEY}\" -var=\"your_repository=${GITHUB_REPO_URL}\""
                        }
                    }
                }
            }
        }
    }
}