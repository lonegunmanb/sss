1. [install packer](https://learn.hashicorp.com/tutorials/packer/getting-started-install)
2. [install ucloud cli](https://github.com/ucloud/ucloud-cli/blob/master/README.md) and confiure to hk region
3. obtain base image id (CentOS 7+)

```shell script
ucloud image list
```

4. touch builder-var.json and edit:

```json
{
    "ucloud_public_key": "{{your ucloud public key}}",
    "ucloud_private_key": "{{your ucloud private key}}",
    "ssh_password": "{{a temp ssh password for packer to use once-time}}",
    "ucloud_project_id": "{{your ucloud project id}}",
    "image_id": "{{ucloud centos base image id, obtain from ucloud cli}}",
    "region": "hk",
    "az": "hk-02",
    "uhub_repo": "{{your uhub repo name}}",
    "uhub_username": "{{your ucloud user name(username for web login)}}",
    "uhub_password": "{{your ucloud password(password for web login)}}"
}
```

5. build

```shell script
packer build -var-file=builder-var.json builder.json
```
