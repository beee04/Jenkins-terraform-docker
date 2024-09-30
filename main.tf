terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "jenkins" {
  name = "jenkins-custom:latest"
  build {
    context = "."
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "jenkins" {
  name  = "jenkins"
  image = docker_image.jenkins.name
  ports {
    internal = 8080
    external = 8080
  }
  ports {
    internal = 50000
    external = 50000
  }
  restart = "unless-stopped"
  volumes {
    container_path = "/var/jenkins_home"
    host_path      = "/home/youruser/jenkins_data"
    read_only     = false
  }
}