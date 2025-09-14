Multi-Service Application Deployment
====================================

This project demonstrates a robust CI/CD pipeline for deploying a multi-service application (a Python backend and a static HTML/JS frontend) to Render. The entire infrastructure is defined as code using Terraform, and the deployment process is fully automated with a Jenkins pipeline.

1: Infrastructure as Code with Terraform
--------------------------------------------

The first phase involved defining the application's infrastructure on Render using **Terraform**. Terraform allows us to manage and provision our cloud resources in a declarative manner.

### Key Concepts:

*   **Render Provider:** We used the official render-oss/render Terraform provider to interact with the Render API.
    
*   **Services as Resources:** The main.tf file defines two key resources:
    
    *   render\_web\_service: For deploying the Python backend.
        
    *   render\_static\_site: For deploying the static frontend.
        
*   **Input Variables:** The configuration uses variables (render\_api\_key, your\_repository) to make the code reusable and prevent sensitive data from being hard-coded.
    

### How it Works:

1.  **main.tf**: Describes the desired state of the infrastructure on Render. It specifies service types, regions, and build commands.
    
2.  **terraform.tfvars**: Provides values for the variables defined in main.tf. This file is intentionally excluded from Git to protect sensitive information.
    
3.  **terraform plan**: Generates an execution plan, showing what resources will be created, changed, or destroyed.
    
4.  **terraform apply**: Provisions the infrastructure on Render according to the plan.
    

2: Jenkins CI/CD & Automated Deployment
-------------------------------------------

The second phase built an automated pipeline using **Jenkins** to create a continuous delivery workflow. This ensures that every code change is automatically built and deployed.

### Key Components:

*   **Jenkins CI/CD Server:** A Jenkins instance running in a Docker container to orchestrate the pipeline.
    
*   **Jenkinsfile:** A declarative pipeline script located in the root of the repository. It defines a series of stages for the CI/CD process:
    
    1.  **Checkout:** Clones the latest code from the GitHub repository.
        
    2.  **Build Docker Images:** Builds Docker images for the backend and frontend. This step is a standard CI practice, although Render's platform handles the actual builds during deployment.
        
    3.  **Terraform Apply:** Executes the Terraform commands to deploy the services to Render. This stage uses **docker-in-docker** to run Terraform from a container, ensuring a consistent environment.
        
*   **Secure Credentials:** The Render API key is securely stored in Jenkins as a secret text credential and is passed to Terraform during the apply stage using the withCredentials step.
    

### Pipeline Workflow:

The Jenkins job is configured to:

1.  Poll the GitHub repository for new commits.
    
2.  When a change is detected, it triggers the pipeline defined in the Jenkinsfile.
    
3.  The pipeline runs through each stage, automating the build and deployment process.
