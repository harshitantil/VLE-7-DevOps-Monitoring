#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id -un)" != "ubuntu" ]]; then
  echo "Run this script as the ubuntu user (it uses sudo internally)." >&2
  exit 1
fi

sudo test -s /home/ubuntu/.kube/config || { echo "Ubuntu kubeconfig not found. Run: minikube status" >&2; exit 1; }
sudo test -d /home/ubuntu/.minikube || { echo "Minikube certificates directory not found." >&2; exit 1; }
sudo install -d -o jenkins -g jenkins -m 0700 /var/lib/jenkins/.kube
sudo cp /home/ubuntu/.kube/config /var/lib/jenkins/.kube/config
sudo cp -a /home/ubuntu/.minikube /var/lib/jenkins/
sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube /var/lib/jenkins/.minikube
sudo chmod 0600 /var/lib/jenkins/.kube/config
sudo sed -i 's#/home/ubuntu/.minikube#/var/lib/jenkins/.minikube#g' /var/lib/jenkins/.kube/config
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

echo 'Testing Jenkins Kubernetes access...'
sudo -u jenkins -H kubectl get nodes
echo 'Testing Jenkins Docker access...'
sudo -u jenkins docker info --format 'Docker server: {{.ServerVersion}}'
echo 'Jenkins is configured for the VLE-7 lab.'
