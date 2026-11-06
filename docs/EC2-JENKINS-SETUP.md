# Jenkins → Minikube setup on the same EC2 host

Run from EC2 Instance Connect as `ubuntu`, in the extracted repository directory:

```bash
bash scripts/configure-jenkins-on-ec2.sh
```

This lab helper copies the Ubuntu user's Minikube kubeconfig and certificate directory to Jenkins, adjusts file ownership and certificate paths, grants Jenkins Docker-group access, restarts Jenkins, and checks both access paths.

**Security:** this reuses the Ubuntu user's Minikube administrative identity and gives Docker socket access. Both are effectively highly privileged. Use only for this isolated classroom lab; production should use a dedicated service account with namespace-scoped RBAC and a hardened image-building strategy.

## Create the Jenkins job

1. Jenkins Home → New Item → `VLE-7-DevOps-Monitoring` → Pipeline.
2. Pipeline → Definition: **Pipeline script from SCM**.
3. SCM: **Git**.
4. Repository URL: `https://github.com/harshitantil/VLE-7-DevOps-Monitoring.git`.
5. Branch: `*/main`.
6. Script Path: `Jenkinsfile`.
7. Save → Build Now.

The Jenkinsfile checks out the repository, builds `vle7-demo:<BUILD_NUMBER>`, applies the Kubernetes manifests, updates the Deployment image, and waits for rollout completion. Minikube's Docker driver on this host uses the same host Docker daemon, so no external registry is required for this lab.
