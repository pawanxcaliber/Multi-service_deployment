terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = ">= 1.0.0"
    }
  }
}

provider "render" {
  api_key  = var.render_api_key
  owner_id = var.render_owner_id
}

# Backend web service
resource "render_web_service" "backend" {
  name          = "backend-service"
  region        = "oregon"
  plan          = "starter"
  start_command = "flask run --host=0.0.0.0"

  runtime_source = {
    native_runtime = {
      repo_url      = var.your_repository
      branch        = "main"
      build_command = "pip install -r requirements.txt"
      auto_deploy   = true
      runtime       = "python"
    }
  }
}

# Frontend static site
resource "render_static_site" "frontend" {
  name          = "frontend-site"
  repo_url      = var.your_repository
  branch        = "main"
  build_command = ""          # e.g. "npm run build" if frontend needs building
  publish_path  = "frontend"  # directory to publish
  auto_deploy   = true
}

# Variables
variable "render_api_key" {
  type = string
}

variable "render_owner_id" {
  type = string
}

variable "your_repository" {
  type = string
}

# Outputs
output "backend_url" {
  value = render_web_service.backend.url
}

output "frontend_url" {
  value = render_static_site.frontend.url
}
