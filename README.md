# Universal Helm Chart

A universal Helm chart for Kubernetes applications with feature-flag driven capabilities. This chart can be used for both frontend and backend applications, supporting multiple deployments per application with a clean, consistent approach.

## Features

- **Universal Design**: Single chart for both frontend and backend applications
- **Feature-Flag Driven**: All capabilities are optional and controlled via feature flags
- **Multiple Deployments**: Support for multiple deployments per application via arrays
- **Environment-Agnostic**: Works across different environments (staging, production, etc.)
- **Dockerfile-Driven**: Relies on Dockerfiles for startup commands (no chart-level overrides)
- **Security-First**: Built-in security features with configurable contexts
- **Monitoring Ready**: Prometheus and Grafana integration support
- **Cost Optimized**: Resource management and autoscaling capabilities

## Quick Start

### Basic Usage

```yaml
# values.yaml
deployments:
  - name: "main-app"
    enabled: true
    image:
      repository: "your-ecr-repo/your-app"
      tag: "latest"
      pullPolicy: IfNotPresent
    replicas: 1
    resources:
      limits:
        cpu: 500m
        memory: 512Mi
      requests:
        cpu: 100m
        memory: 128Mi
    ports:
      - name: http
        containerPort: 8080
        protocol: TCP
    healthCheck:
      enabled: true
      path: "/health"
      initialDelaySeconds: 30
      periodSeconds: 10

service:
  enabled: true
  type: ClusterIP
  ports:
    - name: http
      port: 80
      targetPort: 8080
      protocol: TCP
```

### Advanced Usage with Multiple Deployments

```yaml
# values.yaml
deployments:
  - name: "api-server"
    enabled: true
    image:
      repository: "your-ecr-repo/api-server"
      tag: "latest"
    replicas: 3
    resources:
      limits:
        cpu: 1000m
        memory: 1Gi
      requests:
        cpu: 200m
        memory: 256Mi
    ports:
      - name: http
        containerPort: 8080
    healthCheck:
      enabled: true
      path: "/health"
    env:
      - name: NODE_ENV
        value: "production"
    envFrom:
      - configMapRef:
          name: "api-config"
      - secretRef:
          name: "api-secrets"

  - name: "worker"
    enabled: true
    image:
      repository: "your-ecr-repo/worker"
      tag: "latest"
    replicas: 2
    resources:
      limits:
        cpu: 500m
        memory: 512Mi
      requests:
        cpu: 100m
        memory: 128Mi
    env:
      - name: WORKER_MODE
        value: "true"

# Feature flags
autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 80

pdb:
  enabled: true
  minAvailable: 1

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: "api.your-domain.com"
      paths:
        - path: /
          pathType: Prefix

service:
  enabled: true
  type: ClusterIP
  ports:
    - name: http
      port: 80
      targetPort: 8080

security:
  enabled: true
  serviceAccount:
    create: true
    automountServiceAccountToken: false
  podSecurityContext:
    runAsNonRoot: true
    runAsUser: 1000
  containerSecurityContext:
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
```

## Configuration

### Global Configuration

```yaml
global:
  labels: {}
  imagePullSecrets: []
```

### Deployments

The `deployments` array supports multiple deployments per application:

```yaml
deployments:
  - name: "deployment-name"
    enabled: true
    image:
      repository: "image-repository"
      tag: "image-tag"
      pullPolicy: IfNotPresent
    replicas: 1
    resources: {}
    ports: []
    healthCheck:
      enabled: false
      path: "/health"
      initialDelaySeconds: 30
      periodSeconds: 10
    env: []
    envFrom: []
    volumes: []
    volumeMounts: []
    command: []
    args: []
    initContainers: []
    sidecars: []
    affinity: {}
    tolerations: []
    nodeSelector: {}
    securityContext: {}
    podSecurityContext: {}
    annotations: {}
    podAnnotations: {}
    labels: {}
    podLabels: {}
    strategy: {}
    terminationGracePeriodSeconds: 60
```

### Feature Flags

#### Autoscaling

```yaml
autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80
  behavior: {}
```

#### Pod Disruption Budget

```yaml
pdb:
  enabled: false
  minAvailable: 1
  maxUnavailable: 1
  selectorLabels: {}
  annotations: {}
```

#### Ingress

```yaml
ingress:
  enabled: false
  className: "nginx"
  annotations: {}
  hosts: []
  tls: []
  extraPaths: []
```

#### Service

```yaml
service:
  enabled: true
  type: ClusterIP
  ports: []
  annotations: {}
  labels: {}
  sessionAffinity: ""
  sessionAffinityConfig: {}
```

#### Security

```yaml
security:
  enabled: false
  podSecurityContext: {}
  containerSecurityContext: {}
  serviceAccount:
    create: false
    name: ""
    annotations: {}
    automountServiceAccountToken: false
```

#### Monitoring

```yaml
monitoring:
  enabled: false
  prometheus:
    enabled: false
    scrape: false
    path: "/metrics"
    port: 8080
  grafana:
    enabled: false
    dashboard: false
```

#### Additional Resources

```yaml
# ConfigMap
configMap:
  enabled: false
  name: ""
  data: {}
  annotations: {}
  labels: {}

# Secret
secret:
  enabled: false
  name: ""
  type: Opaque
  data: {}
  annotations: {}
  labels: {}

# PVC
pvc:
  enabled: false
  name: ""
  accessModes: ["ReadWriteOnce"]
  storageClassName: ""
  resources:
    requests:
      storage: 1Gi

# Job
job:
  enabled: false
  name: ""
  image:
    repository: ""
    tag: ""
    pullPolicy: IfNotPresent
  command: []
  args: []
  env: []
  envFrom: []
  resources: {}
  backoffLimit: 4
  activeDeadlineSeconds: null
  ttlSecondsAfterFinished: null

# CronJob
cronjob:
  enabled: false
  name: ""
  schedule: ""
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  image:
    repository: ""
    tag: ""
    pullPolicy: IfNotPresent
  command: []
  args: []
  env: []
  envFrom: []
  resources: {}
  backoffLimit: 4
  activeDeadlineSeconds: null
  ttlSecondsAfterFinished: null

# StatefulSet
statefulset:
  enabled: false
  name: ""
  replicas: 1
  serviceName: ""
  podManagementPolicy: OrderedReady
  image:
    repository: ""
    tag: ""
    pullPolicy: IfNotPresent
  ports: []
  env: []
  envFrom: []
  resources: {}
  volumes: []
  volumeMounts: []
  volumeClaimTemplates: []
  command: []
  args: []
  healthCheck:
    enabled: false
    path: "/health"
    port: 8080
  affinity: {}
  tolerations: []
  nodeSelector: {}
  securityContext: {}
  podSecurityContext: {}
  annotations: {}
  podAnnotations: {}
  labels: {}
  podLabels: {}
  terminationGracePeriodSeconds: 60
```

## Usage Examples

### Frontend Application

```yaml
# k8s/staging.yaml
deployments:
  - name: "frontend"
    enabled: true
    image:
      repository: "your-ecr-repo/frontend"
      tag: "latest"
    replicas: 2
    resources:
      limits:
        cpu: 500m
        memory: 512Mi
      requests:
        cpu: 100m
        memory: 128Mi
    ports:
      - name: http
        containerPort: 3000
    healthCheck:
      enabled: true
      path: "/health"

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: "app.staging.example.com"
      paths:
        - path: /
          pathType: Prefix

service:
  enabled: true
  type: ClusterIP
  ports:
    - name: http
      port: 80
      targetPort: 3000
```

### Backend API with Multiple Services

```yaml
# k8s/production.yaml
deployments:
  - name: "api-server"
    enabled: true
    image:
      repository: "your-ecr-repo/api-server"
      tag: "latest"
    replicas: 3
    resources:
      limits:
        cpu: 1000m
        memory: 1Gi
      requests:
        cpu: 200m
        memory: 256Mi
    ports:
      - name: http
        containerPort: 8080
    healthCheck:
      enabled: true
      path: "/health"
    env:
      - name: NODE_ENV
        value: "production"
    envFrom:
      - configMapRef:
          name: "api-config"
      - secretRef:
          name: "api-secrets"

  - name: "worker"
    enabled: true
    image:
      repository: "your-ecr-repo/worker"
      tag: "latest"
    replicas: 2
    resources:
      limits:
        cpu: 500m
        memory: 512Mi
      requests:
        cpu: 100m
        memory: 128Mi
    env:
      - name: WORKER_MODE
        value: "true"

autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 80

pdb:
  enabled: true
  minAvailable: 1

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: "api.production.example.com"
      paths:
        - path: /
          pathType: Prefix

service:
  enabled: true
  type: ClusterIP
  ports:
    - name: http
      port: 80
      targetPort: 8080

security:
  enabled: true
  serviceAccount:
    create: true
  podSecurityContext:
    runAsNonRoot: true
    runAsUser: 1000
  containerSecurityContext:
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
```

## CI/CD Integration

### GitHub Actions Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy to Kubernetes

on:
  push:
    branches: [main, develop]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-west-2
      
      - name: Update image tags
        run: |
          # Update image tags in values file for all deployments
          for deployment in $(yq eval '.deployments[].name' $VALUES_FILE); do
            yq eval ".deployments[] | select(.name == \"$deployment\") | .image.tag = \"$IMAGE_TAG\"" -i $VALUES_FILE
          done
        env:
          VALUES_FILE: k8s/${{ github.event.ref_name == 'main' && 'production' || 'staging' }}.yaml
          IMAGE_TAG: ${{ github.sha }}
      
      - name: Deploy with Helm
        run: |
          helm upgrade --install $SERVICE_NAME $CHART_REPO/$CHART_NAME \
            --version $CHART_VERSION \
            --namespace $NAMESPACE \
            --create-namespace \
            -f $VALUES_FILE
        env:
          SERVICE_NAME: my-app
          CHART_REPO: your-org/helm-charts
          CHART_NAME: universal
          CHART_VERSION: 1.0.0
          NAMESPACE: my-app
          VALUES_FILE: k8s/${{ github.event.ref_name == 'main' && 'production' || 'staging' }}.yaml
```

## Best Practices

1. **Use Feature Flags**: Enable only the features you need for each environment
2. **Dockerfile-Driven**: Let your Dockerfiles handle startup commands and entrypoints
3. **Resource Management**: Always specify resource limits and requests
4. **Security First**: Enable security features in production environments
5. **Monitoring**: Enable monitoring features for production workloads
6. **Environment-Specific Values**: Use separate values files for different environments
7. **Version Pinning**: Pin chart versions in CI/CD for reproducible deployments

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

MIT License - see LICENSE file for details. 