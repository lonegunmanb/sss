terraform {
  required_version = ">= 0.12.0"
  required_providers {
    ucloud = {
      source  = "ucloud/ucloud"
      version = "~> 1.27.0"
    }
    null   = {
      version = "~> 3.0.0"
    }
  }
}

provider "ucloud" {
  project_id = var.packer_vars.ucloud_project_id
  region     = var.packer_vars.region
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
%{for name, value in var.packer_vars~}
-var '${name}=${value}' \
%{endfor~}
-var 'image_id=${local.builder_image_id}' \
${path.module}/builder.json
EOT
  }
}


data "template_file" "pod_yaml" {
  template = file("${path.module}/pod.yaml")
  vars     = {
    sspassword = var.sspassword
    image_id   = "${var.packer_vars.repo_url}/${var.packer_vars.docker_repo}/${var.packer_vars.image}:${var.packer_vars.image_tag}"
  }
}

data "ucloud_vpcs" "default" {
  name_regex = "DefaultVPC"
}

data "ucloud_subnets" "default" {
  vpc_id     = data.ucloud_vpcs.default.vpcs.0.id
  name_regex = "DefaultNetwork"
}

resource "ucloud_cube_pod" "sss" {
  depends_on        = [null_resource.packer_exec]
  name              = "sss"
  availability_zone = var.packer_vars.az
  vpc_id            = data.ucloud_vpcs.default.vpcs.0.id
  subnet_id         = data.ucloud_subnets.default.subnets.0.id
  pod               = data.template_file.pod_yaml.rendered
}

resource "ucloud_eip" "sss_ip" {
  depends_on    = [null_resource.packer_exec]
  bandwidth     = 200
  charge_mode   = "traffic"
  charge_type   = var.eip_charge_type
  internet_type = "international"
  name          = "sss_eip"
}

resource "ucloud_eip_association" "sss_ip_association" {
  eip_id      = ucloud_eip.sss_ip.id
  resource_id = ucloud_cube_pod.sss.id
}
