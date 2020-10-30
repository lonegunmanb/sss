if [ -x "$(command -v docker)" ]; then
    echo "docker installed"
else
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
fi

cd /tmp
if [[ ! -z "${REPO_URL}" ]]; then
  docker build -t ${REPO_URL}/${REPO}/${IMAGE}:${IMAGE_TAG} .
else
  docker build -t ${REPO}/${IMAGE}:${IMAGE_TAG} .
fi
docker login --username ${DOCKER_USERNAME} --password ${DOCKER_PASSWORD} ${REPO_URL}

if [[ ! -z "${REPO_URL}" ]]; then
  docker push ${REPO_URL}/${REPO}/${IMAGE}:${IMAGE_TAG}
else
  docker push ${REPO}/${IMAGE}:${IMAGE_TAG}
fi
