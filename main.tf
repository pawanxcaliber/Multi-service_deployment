# Configure the Render provider
terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = "1.0.0"
    }
  }
}

provider "render" {
  api_key = var.render_api_key
}

# Define the private network for inter-service communication
resource "render_private_network" "app_network" {
  name = "app-network"
}

# Define the PostgreSQL database service
resource "render_postgres" "my_database" {
  name = "my-database"
  plan_type = "free"
  private_network_id = render_private_network.app_network.id
  database_name = "myapp"
}

# Define the backend web service
resource "render_web_service" "backend_service" {
  name = "backend-service"
  repo_url = "https://github.com/your-username/your-repository.git"
  docker_command = "flask run --host=0.0.0.0"
  env = "docker"
  owner_id = "your-owner-id"
  build_command = "pip install -r requirements.txt"
  plan_type = "starter"
  private_network_id = render_private_network.app_network.id
}

# Define the frontend static site
resource "render_static_site" "frontend_site" {
  name = "frontend-site"
  repo_url = "https://github.com/your-username/your-repository.git"
  publish_path = "./frontend"
  build_command = ""
  owner_id = "your-owner-id"
}

# Variable to securely pass the Render API key
variable "render_api_key" {
  type = string
}

variable "your_repository" {
  type = string
}

# Output the live URL of the frontend
output "frontend_url" {
  value = render_static_site.frontend_site.url
}