#!/bin/bash

# Test script for helm-templates chart
# This script validates the chart with all components enabled

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if helm is installed
check_helm() {
    if ! command -v helm &> /dev/null; then
        print_error "Helm is not installed. Please install Helm first."
        exit 1
    fi
    print_success "Helm is installed"
}

# Lint the chart
lint_chart() {
    print_status "Linting Helm chart..."
    
    if helm lint .; then
        print_success "Chart linting passed"
    else
        print_error "Chart linting failed"
        exit 1
    fi
}

# Test chart rendering
test_render() {
    print_status "Testing chart rendering with default values..."
    
    if helm template . --debug; then
        print_success "Chart rendering with default values passed"
    else
        print_error "Chart rendering with default values failed"
        exit 1
    fi
}

# Test chart rendering with test values
test_render_with_values() {
    print_status "Testing chart rendering with test values..."
    
    if helm template . -f test-values.yaml --debug; then
        print_success "Chart rendering with test values passed"
    else
        print_error "Chart rendering with test values failed"
        exit 1
    fi
}

# Test chart rendering with all components enabled
test_all_components() {
    print_status "Testing chart rendering with all components enabled..."
    
    # Test deployment
    if helm template . -f test-values.yaml --set deployment.enabled=true --debug | grep -q "kind: Deployment"; then
        print_success "Deployment template rendered correctly"
    else
        print_error "Deployment template failed"
        exit 1
    fi
    
    # Test service
    if helm template . -f test-values.yaml --set service.enabled=true --debug | grep -q "kind: Service"; then
        print_success "Service template rendered correctly"
    else
        print_error "Service template failed"
        exit 1
    fi
    
    # Test ingress
    if helm template . -f test-values.yaml --set ingress.enabled=true --debug | grep -q "kind: Ingress"; then
        print_success "Ingress template rendered correctly"
    else
        print_error "Ingress template failed"
        exit 1
    fi
    
    # Test HPA
    if helm template . -f test-values.yaml --set autoscaling.enabled=true --debug | grep -q "kind: HorizontalPodAutoscaler"; then
        print_success "HPA template rendered correctly"
    else
        print_error "HPA template failed"
        exit 1
    fi
    
    # Test PDB
    if helm template . -f test-values.yaml --set pdb.enabled=true --debug | grep -q "kind: PodDisruptionBudget"; then
        print_success "PDB template rendered correctly"
    else
        print_error "PDB template failed"
        exit 1
    fi
    
    # Test ServiceAccount
    if helm template . -f test-values.yaml --set serviceAccount.create=true --debug | grep -q "kind: ServiceAccount"; then
        print_success "ServiceAccount template rendered correctly"
    else
        print_error "ServiceAccount template failed"
        exit 1
    fi
    
    # Test ExternalSecret
    if helm template . -f test-values.yaml --set doppler.enabled=true --debug | grep -q "kind: ExternalSecret"; then
        print_success "ExternalSecret template rendered correctly"
    else
        print_error "ExternalSecret template failed"
        exit 1
    fi
    
    # Test CronJob
    if helm template . -f test-values.yaml --set cronjob.enabled=true --debug | grep -q "kind: CronJob"; then
        print_success "CronJob template rendered correctly"
    else
        print_error "CronJob template failed"
        exit 1
    fi
    
    # Test Job
    if helm template . -f test-values.yaml --set job.enabled=true --debug | grep -q "kind: Job"; then
        print_success "Job template rendered correctly"
    else
        print_error "Job template failed"
        exit 1
    fi
    
    # Test ConfigMap
    if helm template . -f test-values.yaml --set configmap.enabled=true --debug | grep -q "kind: ConfigMap"; then
        print_success "ConfigMap template rendered correctly"
    else
        print_error "ConfigMap template failed"
        exit 1
    fi
}

# Test chart packaging
test_package() {
    print_status "Testing chart packaging..."
    
    if helm package .; then
        print_success "Chart packaging passed"
        # Clean up the generated package
        rm -f helm-templates-*.tgz
    else
        print_error "Chart packaging failed"
        exit 1
    fi
}

# Test chart installation (dry-run)
test_install() {
    print_status "Testing chart installation (dry-run)..."
    
    if helm install test-release . -f test-values.yaml --dry-run --debug; then
        print_success "Chart installation test passed"
    else
        print_error "Chart installation test failed"
        exit 1
    fi
}

# Test chart upgrade (dry-run)
test_upgrade() {
    print_status "Testing chart upgrade (dry-run)..."
    
    if helm upgrade test-release . -f test-values.yaml --dry-run --debug; then
        print_success "Chart upgrade test passed"
    else
        print_error "Chart upgrade test failed"
        exit 1
    fi
}

# Main test execution
main() {
    echo "🧪 Testing Helm Chart: helm-templates"
    echo "====================================="
    echo ""
    
    check_helm
    lint_chart
    test_render
    test_render_with_values
    test_all_components
    test_package
    test_install
    test_upgrade
    
    echo ""
    print_success "All tests passed! 🎉"
    echo ""
    echo "Chart is ready for deployment with the following components:"
    echo "✅ Deployment with health checks"
    echo "✅ Service with configurable type"
    echo "✅ Ingress with TLS and external DNS"
    echo "✅ Horizontal Pod Autoscaler"
    echo "✅ Pod Disruption Budget"
    echo "✅ Service Account with IRSA support"
    echo "✅ External Secret for Doppler integration"
    echo "✅ CronJob for scheduled tasks"
    echo "✅ Job for one-time tasks"
    echo "✅ ConfigMap for configuration data"
    echo "✅ Comprehensive test templates"
    echo "✅ Cost-optimized resource limits"
}

# Run main function
main "$@" 