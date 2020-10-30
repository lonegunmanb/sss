variable "packer_vars" {
  type = object({
    ssh_password      = string
    ucloud_project_id = string
    region            = string
    az                = string
    docker_repo       = string
    docker_username   = string
    docker_password   = string
    repo_url          = string
    image             = string
    image_tag         = string
  })
}
variable "public_key" {
  type = string
}
variable "private_key" {
  type = string
}

variable "builder_image_id" {
  type    = string
  default = ""
}
locals {
  builder_image_id = var.builder_image_id == "" ? data.ucloud_images.centos.images[0].id : var.builder_image_id
}
