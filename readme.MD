由于Cube只允许使用UHub的镜像，所以我们无法使用Docker Hub上的公共镜像，从Terraform中调用Packer启动一台CentOS虚拟机构建镜像，并推送到UHub，再自动Cube。

首先要在UHub中建立一个公共仓库，记住仓库的名字(仓库要建在准备运行Cube的区域)

[创建UHub仓库的教程](https://docs.ucloud.cn/uhub/guide)

![控制台右上角左起第二个图标，>_ 符号的图标，点击打开CloudShell](https://raw.githubusercontent.com/lonegunmanb/pic/master/2021-5-26/1622031510410-image.png)

**控制台右上角左起第二个图标，>_ 符号的图标，点击打开CloudShell**

在CloudShell中执行最下面的指令，但要先自行将变量值替换成自己需要的值，即可完成

{{sshpassword}}是给Packer用来启动虚拟机安装Docker运行时环境，构建Docker镜像用的
{{region}}是指Cube运行的region(建议写`hk`)
{{az}}是指Cube运行的可用区(建议写`hk-02`)
{{docker_repo}}是UHub仓库名
{{docker_username}}是你的UCloud账户名(邮箱地址)
{{docker_password}}是你的UCloud密码(登录网页控制台用的密码，UHub使用你的UCloud用户名密码验证身份)
{{docker_image_name}}是要构建或使用的Docker镜像名(不知道怎么写的就写`sss`)
{{sspassword}}是你的ssr password，这个得自己设置一个

```shell
git clone -b cloudshell https://github.com/lonegunmanb/sss.git && SSH_PASSWORD={{sshpassword}} REGION={{region}} AZ={{az}} DOCKER_REPO={{docker_repo}} DOCKER_USERNAME={{docker_username}} DOCKER_PASSWORD={{docker_password}} DOCKER_IMAGE_NAME={{docker_image_name}} SSPASSWORD={{sspassword}} EIP_CHARGE_TYPE=month sh setup.sh
```

以上命令是首次运行使用的，如果我们已经成功运行过一次，在UHub中已经有了Docker镜像，我们可以添加环境变量`TF_VAR_skip_bake_docker=true` 来跳过创建Docker镜像的部分：

```shell
git clone -b cloudshell https://github.com/lonegunmanb/sss.git && TF_VAR_skip_bake_docker=true SSH_PASSWORD={{sshpassword}} REGION={{region}} AZ={{az}} DOCKER_REPO={{docker_repo}} DOCKER_USERNAME={{docker_username}} DOCKER_PASSWORD={{docker_password}} DOCKER_IMAGE_NAME={{docker_image_name}} SSPASSWORD={{sspassword}} EIP_CHARGE_TYPE=month sh setup.sh
```
