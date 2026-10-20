terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name = var.image_name
}

# انتقال آدرس کانتینر اول به ساختار مشترک for_each
moved {
  from = docker_container.nginx
  to   = docker_container.nginx_instances["primary"]
}

# انتقال کانتینر دوم از آدرس قبلی
moved {
  from = docker_container.nginx2
  to   = docker_container.nginx_instances["secondary"]
}

# هر دو کانتینر با یک منبع مدیریت می‌شوند
resource "docker_container" "nginx_instances" {
  for_each = var.nginx_instances

  name  = each.value.name
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = each.value.external_port
  }
}
