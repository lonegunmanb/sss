For those who don't want to install docker on their machine(on windows, install docker needs turn on Hyper-V or WSL2), or docker build is very slow or impossible because of low network bandwidth or gfw, we can use packer to launch a virtual machine on UCloud (hk region advised) and use this virtual machine to run docker build and docker push for us.

This Dockerfile builds an image of magic ladder, feel free to replace Dockerfile with your own one.

1. [install packer](https://learn.hashicorp.com/tutorials/packer/getting-started-install)
2. [install terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)

3. touch terraform.tfvars and edit:

```hcl
public_key  = "{{your ucloud public key}}"
private_key = "{{your ucloud private key}}"
packer_vars = {
  region            = "hk"
  ssh_password      = "{{a temp ssh password for packer to use}}"
  ucloud_project_id = "{{your ucloud project id}}"
  region            = "hk"
  az                = "hk-02"
  docker_repo       = "{{your uhub repo name}}"
  docker_username   = "{{your ucloud username}}"
  docker_password   = "{{your ucloud password}}"
  repo_url          = "uhub.service.ucloud.cn"
  image     = "{{your image name}}"
  image_tag = "latest"
}
```
For those who want push to docker hub:

```hcl
public_key  = "{{your ucloud public key}}"
private_key = "{{your ucloud private key}}"
packer_vars = {
  region            = "hk"
  ssh_password      = "{{a temp ssh password for packer to use}}"
  ucloud_project_id = "{{your ucloud project id}}"
  region            = "hk"
  az                = "hk-02"
  docker_repo       = "{{your docker hub repo name}}"
  docker_username   = "{{your docker hub username}}"
  docker_password   = "{{your docker hub password}}"
  repo_url          = ""
  image     = "{{your image name}}"
  image_tag = "latest"
}
```

If you have built a CentOS image with docker installed, add image id to tfvars:

```hcl
builder_image_id = "{{your image id}}"
```

4. build

```shell script
terraform init
terraform apply
```

We execute packer in null_resource which has an uuid as trigger, so everytime you execute 'terraform apply' will trigger a build.
