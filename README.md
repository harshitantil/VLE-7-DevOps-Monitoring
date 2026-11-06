# VLE-7 — Full DevOps Monitoring System

Lab implementation using AWS EC2, Terraform, Ansible, Jenkins, Docker, Minikube, Helm, Prometheus, Grafana and Alertmanager.

## Architecture

GitHub → Jenkins → Docker image → Kubernetes (Minikube) → Prometheus → Grafana / Alertmanager

## Lab progress

- [x] EC2 Ubuntu 22.04 provisioned with Terraform
- [x] Base packages and Jenkins configured with Ansible
- [x] Docker Engine installed
- [x] Minikube cluster running with Docker driver
- [x] kube-prometheus-stack installed using Helm
- [x] Grafana dashboards accessible through an SSH tunnel
- [x] `PodCrashLoop` PrometheusRule tested (Pending → Firing)
- [ ] Jenkins pipeline deployment to Kubernetes (final integration)
- [ ] External email/Slack notification receiver (requires receiver credentials)

## Repository layout

- `app/`: sample HTTP application and Dockerfile
- `k8s/`: Kubernetes Deployment and Service
- `Jenkinsfile`: CI/CD pipeline
- `monitoring/`: Prometheus alert rule
- `scripts/`: EC2 Jenkins setup helper
- `docs/`: configuration and viva notes

## Build and run on the EC2 host

```bash
docker build -t vle7-demo:local app/
docker run --rm -p 8080:8080 vle7-demo:local
```

Kubernetes deployment after building the image locally:

```bash
kubectl apply -f k8s/
kubectl set image deployment/vle7-demo vle7-demo=vle7-demo:local
kubectl rollout status deployment/vle7-demo
kubectl get deployment,service,pods -l app=vle7-demo
```

The pipeline imports the newly built image into Minikube with `minikube image load`, so no external container registry is needed for this lab.

## Configure Jenkins

1. Run `scripts/configure-jenkins-on-ec2.sh` on EC2 as the Ubuntu user.
2. In Jenkins, create **New Item → Pipeline**.
3. Select **Pipeline script from SCM → Git**.
4. Repository URL: `https://github.com/harshitantil/VLE-7-DevOps-Monitoring.git`.
5. Branch: `*/main`; Script Path: `Jenkinsfile`.
6. Save and click **Build Now**.

The pipeline checks out this repository, builds a uniquely tagged Docker image, applies the Kubernetes manifests, updates the Deployment image, and waits for rollout completion.

## Security

This is a teaching lab, not a production deployment. Do not expose Jenkins, Prometheus, Grafana or Alertmanager directly to the internet; use SSH tunnels. Never commit private keys, kubeconfigs, passwords, SMTP credentials or cloud credentials. Membership in the Docker group is effectively root-equivalent. The helper script copies the Ubuntu user's Minikube admin kubeconfig to Jenkins for this isolated lab; use a dedicated service account with namespace-scoped RBAC in production.

## Monitoring rule

`monitoring/pod-crash-alert.yaml` fires when `kube_pod_container_status_restarts_total > 3` remains true for 2 minutes. It was demonstrated with a deliberately failing BusyBox deployment.

## Cleanup

```bash
kubectl delete deployment crash-demo --ignore-not-found
kubectl delete -f k8s/ --ignore-not-found
```

Destroy the Terraform-managed EC2 lab resources after the exercise and verify AWS resources and billing.
