terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = "1.8.0"
    }
  }
  backend "remote" {
    organization = "cloud-potatoes"
    workspaces {
      name = "crud-devops-pipeline"
    }

  }
}

provider "render" {
  api_key  = var.render_api_key
  owner_id = var.render_owner_id
}

resource "render_web_service" "web_app" {
  name           = "crud-devops-app" # Name of your app on Render
  plan           = "starter"         # Free tier plan
  region         = "oregon"          # required by provider (choose appropriate region)
  root_directory = "backend"

  # Optional: command that starts your app inside the container
  start_command = "npm start"

  runtime_source = {
    docker = {
      repo_url        = "https://github.com/galarconm/crud-devops-pipeline"
      branch          = "main"
      context         = "."
      dockerfile_path = "Dockerfile"
      auto_deploy     = true # Enable auto-deploy on push       
    }
  }
}
