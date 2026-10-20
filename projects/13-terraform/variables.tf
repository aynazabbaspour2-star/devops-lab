variable "image_name" {
  type    = string
  default = "nginx:latest"
}

variable "nginx_instances" {
  description = "Nginx containers managed by Terraform"

  type = map(object({
    name          = string
    external_port = number
  }))

  default = {
    primary = {
      name          = "terraform-nginx"
      external_port = 8089
    }

    secondary = {
      name          = "terraform-nginx-2"
      external_port = 8090
    }
  }
}
