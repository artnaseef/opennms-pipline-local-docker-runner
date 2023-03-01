FROM ubuntu:20.04

  RUN apt-get update
  RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
  RUN apt-get install -y curl openssl containerd git openjdk-11-jdk ca-certificates gnupg lsb-release sudo

  RUN mkdir /etc/apt/keyrings && \
      curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
      echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
      apt-get update

  RUN apt-get install -y cri-tools kubectl kubeadm kubelet && \
      echo 'runtime-endpoint: unix:///var/run/containerd/containerd.sock' > /etc/crictl.yaml

  RUN DEBIAN_FRONTEND=noninteractive apt-get install -y golang && \
      GO111MODULE="on" go get sigs.k8s.io/kind@v0.12.0

  RUN mkdir /root/helm-v3.10.3 && \
      cd /root/helm-v3.10.3 && \
      curl -fsSLo helm-v3.10.3-linux-amd64.tar.gz https://get.helm.sh/helm-v3.10.3-linux-amd64.tar.gz && \
      tar -zxvf helm-v3.10.3-linux-amd64.tar.gz

  RUN cd /root && \
      curl -fsSLo apache-maven-3.8.7-bin.tar.gz https://dlcdn.apache.org/maven/maven-3/3.8.7/binaries/apache-maven-3.8.7-bin.tar.gz && \
      tar -zxvf apache-maven-3.8.7-bin.tar.gz

  RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list && \
      apt-get update

  RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

  ENV PATH="${PATH}:/root/helm-v3.10.3/linux-amd64:/root/go/bin:/root/apache-maven-3.8.7/bin"


  ### ENTRYPOINT [ "/bin/bash", "-c", "containerd & dockerd & /bin/bash" ]
  ENTRYPOINT [ "/bin/bash", "-c", "containerd & dockerd" ]

  VOLUME /var/lib/docker

# install
# 	docker (containerd?)
# 	KIND
# 	kubectl
# 	helm3
# 	openssl
# 	git

# update /etc/hosts

# mount point for the sources
