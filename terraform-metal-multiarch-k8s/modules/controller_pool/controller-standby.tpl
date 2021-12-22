#!/bin/bash

export HOME=/root

function install_docker() {
 apt-get update; \
 apt-get install -y docker.io && \
 cat << EOF > /etc/docker/daemon.json
 {
   "exec-opts": ["native.cgroupdriver=systemd"]
 }
EOF
}

function enable_docker() {
 systemctl enable docker ; \
 systemctl restart docker
}

function ceph_pre_check {
  apt install -y lvm2 ; \
  modprobe rbd
}

function install_kube_tools() {
 swapoff -a  && \
 apt-get update && apt-get install -y apt-transport-https
 curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
 echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
 apt-get update
 apt-get install -y kubelet=${kube_version} kubeadm=${kube_version} kubectl=${kube_version}
}

install_docker && \
if [ "${storage}" = "ceph" ]; then
  ceph_pre_check
fi ; \
enable_docker && \
install_kube_tools && \
sleep 30 && \
if [ "${ccm_enabled}" = "true" ]; then
  echo KUBELET_EXTRA_ARGS=\"--cloud-provider=external\" > /etc/default/kubelet
fi

sleep 180 ; \
backoff_count=`echo $((5 + RANDOM % 100))` ; \
sleep $backoff_count # Shouldn't there be a kubeadm join command somewhere? Looks like we just install tools and do nothing else
