FROM ubuntu:focal

RUN apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install \
        python3 \
        python3-pip \
        less \
        curl \
        unzip \
        jq \
        git \
        software-properties-common \
        build-essential \
        wget \
        git \
        maven \
        openjdk-8-jdk \
        ant \
        ssh-client \
        netcat \
        dnsutils \
        iputils-ping \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        < /dev/null \
        > /dev/null \
    && apt-get clean

# install python dependencies
RUN pip3 install --no-cache-dir \
        pyyaml \
        pandas \
        numpy \
        scipy \
        country-converter \
        python-dateutil

# aws cli
RUN bash -c 'curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"' \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip \
    && aws --version

# eksctl
RUN bash -c 'curl -s -L0 "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp' \
    && mv /tmp/eksctl /usr/local/bin \
    && eksctl version

# kubectl
RUN bash -c 'curl -s -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"' \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && kubectl version --client

# helm3
# as per https://helm.sh/docs/intro/install/
RUN bash -c 'curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash'

# docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && apt-key fingerprint 0EBFCD88 \
    && bash -c 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"' \
    && apt-get update \
    && apt-get install -qq docker-ce docker-ce-cli containerd.io \
    && apt-get clean

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash - \
    && apt-get install -qq nodejs \
    && apt-get clean

# nodejs tools
RUN npm install -g json

# shell config
COPY bashrc /root/.bashrc

# keep running indefinitely
CMD tail -f /dev/null

