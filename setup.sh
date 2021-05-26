cd sss

sudo apt install -y jq

export PROJECT=$(ucloud project list --json | jq -r [.[].ProjectId][0])

# create terraform.tfvars
cat <<EOT > terraform.tfvars
packer_vars = {
  ssh_password      = "${SSH_PASSWORDD}"
  ucloud_project_id = "${PROJECT}"
  region            = "${REGION}"
  az                = "${AZ}"
  docker_repo       = "${DOCKER_REPO}"
  docker_username   = "${DOCKER_USERNAME}"
  docker_password   = "${DOCKER_PASSWORD}"
  repo_url          = "uhub.service.ucloud.cn"
  image     = "${DOCKER_IMAGE_NAME}"
  image_tag = "latest"
}
sspassword = "${SSPASSWORD}"
eip_charge_type = "${EIP_CHARGE_TYPE}"
EOT

terraform init
terraform apply -auto-approve
