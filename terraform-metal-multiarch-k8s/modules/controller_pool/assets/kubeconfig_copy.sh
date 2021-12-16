#!/bin/bash
/usr/bin/ssh -i $ssh_private_key_path -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$controller "while true; do if ! type kubeadm > /dev/null; then sleep 20; else break; fi; done"
sleep 520
/usr/bin/scp -i $ssh_private_key_path -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q root@$controller:/etc/kubernetes/admin.conf $local_path/kubeconfig;

