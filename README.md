# JARAKEY Helm Templates

This repository contains the universal Helm chart for JARAKEY microservices deployment.

## 📦 Published Helm Repository

The universal chart is published as a Helm repository and can be accessed at:
```
https://jarakey.github.io/helm-templates
```

## 🚀 Usage

### Add the Repository
```bash
helm repo add jarakey https://jarakey.github.io/helm-templates
helm repo update
```

### Install/Upgrade a Service
```bash
helm upgrade --install <service-name> jarakey/universal \
  --namespace <namespace> \
  --create-namespace \
  -f values.yaml \
  --wait --timeout=10m
```

## 📁 Repository Structure

```
helm-templates/
├── universal/           # The universal chart
│   ├── Chart.yaml      # Chart metadata
│   ├── values.yaml     # Default values
│   └── templates/      # Kubernetes templates
├── templates/          # Shared templates
├── tests/             # Chart tests
└── .github/workflows/ # CI/CD workflows
```

## 🔧 Chart Features

- **Universal Design**: Single chart for all microservices
- **Feature Flags**: Conditional resource creation
- **Multi-Environment**: Staging and production support
- **Resource Optimization**: Configurable CPU/memory limits
- **Autoscaling**: Horizontal Pod Autoscaler support
- **Monitoring**: Prometheus and Grafana integration
- **Security**: RBAC, security contexts, and network policies

## 📋 Service Configuration

Each service should provide a `values.yaml` file with:

```yaml
global:
  image:
    repository: <ecr-repository>
    tag: <image-tag>
    pullPolicy: IfNotPresent

deployments:
  - name: <service-name>
    enabled: true
    replicas: 1
    resources:
      requests:
        cpu: 50m
        memory: 64Mi
      limits:
        cpu: 200m
        memory: 128Mi

ingress:
  - name: <service-ingress>
    enabled: true
    hosts:
      - host: <hostname>
        paths:
          - path: /
            pathType: Prefix

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 2

doppler:
  enabled: true
  project: <service-name>
  config: staging
```

## 🔄 Publishing

The chart is automatically published when changes are pushed to the `main` branch. The workflow:

1. Bumps the chart version
2. Lints and packages the chart
3. Publishes to GitHub Pages
4. Creates a new release tag

## 📊 Available Services

1. **Use Feature Flags**: Enable only the features you need for each environment
2. **Dockerfile-Driven**: Let your Dockerfiles handle startup commands and entrypoints
3. **Resource Management**: Always specify resource limits and requests
4. **Security First**: Enable security features in production environments
5. **Monitoring**: Enable monitoring features for production workloads
6. **Environment-Specific Values**: Use separate values files for different environments
7. **Version Pinning**: Pin chart versions in CI/CD for reproducible deployments

## 🤝 Contributing

1. Make changes to the `universal/` chart
2. Test with `helm lint universal`
3. Push to `main` branch
4. Chart will be automatically published

## 📞 Support

For issues or questions, contact: t@jarakey.com 