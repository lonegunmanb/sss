terraform {
  required_version = ">= 0.12.0"
  required_providers {
    ucloud = {
      source  = "ucloud/ucloud"
      version = "~> 1.24.0"
    }
    null = {
      version = "~> 3.0.0"
    }
  }
}

provider "ucloud" {
  public_key  = var.public_key
  private_key = var.private_key
  project_id  = var.packer_vars.ucloud_project_id
  region      = var.packer_vars.region
}

data "ucloud_images" "centos" {
  availability_zone = var.packer_vars.az
  image_type        = "base"
  name_regex        = "^CentOS 7.6 64"
  most_recent       = true
  os_type           = "linux"
}

resource "null_resource" "packer_exec" {
  triggers = {
    trigger = uuid()
  }
  provisioner "local-exec" {
    command = <<EOT
packer build \
-var 'ucloud_public_key=${var.public_key}' \
-var 'ucloud_private_key=${var.private_key}' \
%{for name, value in var.packer_vars~}
-var '${name}=${value}' \
%{endfor~}
-var 'image_id=${local.builder_image_id}' \
${path.module}/builder.json
EOT
  }
}
