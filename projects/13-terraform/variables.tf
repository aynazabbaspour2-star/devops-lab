variable "image_name" {
  type    = string
  default = "nginx:latest"
}

variable "container_name" {
  type    = string
  default = "terraform-nginx"
}

variable "external_port" {
  type    = number
  default = 8088
}
