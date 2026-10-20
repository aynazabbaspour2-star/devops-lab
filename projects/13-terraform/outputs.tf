output "container_names" {
  description = "Names of all Terraform-managed Nginx containers"
  value = {
    for key, container in docker_container.nginx_instances :
    key => container.name
  }
}

output "container_ids" {
  description = "IDs of all Terraform-managed Nginx containers"
  value = {
    for key, container in docker_container.nginx_instances :
    key => container.id
  }
}

output "container_image" {
  value = docker_image.nginx.name
}
