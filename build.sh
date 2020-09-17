echo "add yum repo"
sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf
if [[ ! -z "${YUM_BASE}" ]]; then
  rm -f /etc/yum.repos.d/CentOS-Base.repo
  curl ${YUM_BASE} -o /etc/yum.repos.d/CentOS-Base.repo
fi
if [[ ! -z "${YUM_DOCKER}" ]]; then
  yum-config-manager --add-repo ${YUM_DOCKER}
fi

yum makecache
yum install -y wget
echo "yum upgrade"
yum upgrade -y
yum install -y yum-utils device-mapper-persistent-data lvm2

echo "install docker-ce"
if [[ ! -z "${DOCKER_RPM}" ]]; then
  wget -nv -O docker-ce.rpm ${DOCKER_RPM}
  yum install -y docker-ce.rpm
  rm -f docker-ce.rpm
else
  yum install -y docker-ce
fi

if [[ ! -z "${DOCKER_CLI_RPM}" ]]; then
  wget -nv -O docker-cli.rpm ${DOCKER_CLI_RPM}
  yum install -y docker-cli.rpm
  rm -f docker-cli.rpm
else
  yum install -y docker-ce-cli
fi

systemctl enable docker
systemctl start docker

# echo "install wget && unzip"

# yum install -y wget unzip

# echo "install packer"

# wget -O packer.zip http://builder.hk.ufileos.com/packer_1.6.2_linux_amd64.zip
# unzip packer.zip
# rm packer.zip
# mv packer /usr/bin/packer
# chmod +x /usr/bin/packer

cd /tmp
docker build -t uhub.service.ucloud.cn/${REPO}/sss:latest .
docker login --username ${UHUB_USERNAME} --password ${UHUB_PASSWORD} uhub.service.ucloud.cn
docker push uhub.service.ucloud.cn/${REPO}/sss:latest