# VLE-7 viva quick notes

- **CI/CD:** Continuous Integration validates integrated code; Continuous Delivery/Deployment automates release and deployment.
- **Jenkins:** Automation server that runs jobs and pipelines.
- **Docker image:** Packaged application and runtime dependencies.
- **Container:** Running instance of an image.
- **Pod:** Smallest deployable Kubernetes unit.
- **Deployment:** Maintains the desired replica count and manages rolling updates.
- **Service:** Stable network endpoint selecting matching Pods.
- **Minikube:** Single-node Kubernetes cluster used for this lab.
- **Helm:** Kubernetes package manager used to install kube-prometheus-stack.
- **Prometheus:** Scrapes and stores time-series metrics and evaluates alert rules.
- **Grafana:** Visualizes metrics using dashboards.
- **Alertmanager:** Groups, routes, deduplicates and sends notifications for Prometheus alerts.
- **ServiceMonitor:** Prometheus Operator custom resource describing service scrape configuration.
- **PrometheusRule:** Custom resource containing recording or alerting rules.
- **PodCrashLoop:** Lab alert when `kube_pod_container_status_restarts_total > 3` remains true for 2 minutes.

## Demonstrated evidence

1. Minikube node reached Ready and system pods became Running.
2. kube-prometheus-stack pods reached Ready.
3. Grafana dashboards were accessible through an SSH tunnel.
4. `vle7-pod-alerts` PrometheusRule was created.
5. BusyBox `crash-demo` entered CrashLoopBackOff and `PodCrashLoop` changed from Pending to Firing with critical severity.
6. Jenkins pipeline files are included; final integration requires the Jenkins user to have Docker and Minikube access.
