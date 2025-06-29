#!/bin/bash

# Spring PetClinic DevSecOps Setup Script
# This script helps configure JFrog repositories and provides setup instructions

set -e

echo "🐕 Spring PetClinic DevSecOps Setup"
echo "===================================="
echo

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}➤ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
print_step "Checking prerequisites..."

# Check if JFrog CLI is installed
if ! command -v jf &> /dev/null; then
    print_warning "JFrog CLI not found. Installing..."
    curl -fL https://getcli.jfrog.io | sh
    sudo mv jf /usr/local/bin/
    print_success "JFrog CLI installed"
else
    print_success "JFrog CLI found"
fi

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    print_error "Helm is required but not installed. Please install Helm 3.x"
    exit 1
else
    print_success "Helm found"
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is required but not installed"
    exit 1
else
    print_success "kubectl found"
fi

echo

# Get JFrog configuration
print_step "JFrog Configuration"
echo -e "${YELLOW}Please provide your JFrog Cloud details:${NC}"

read -p "JFrog URL (e.g., https://yourinstance.jfrog.io): " JFROG_URL
read -p "JFrog Username: " JFROG_USERNAME
read -s -p "JFrog Password/API Key: " JFROG_PASSWORD
echo

# Configure JFrog CLI
print_step "Configuring JFrog CLI..."
jf config add petclinic --url="$JFROG_URL" --user="$JFROG_USERNAME" --password="$JFROG_PASSWORD" --interactive=false
jf config use petclinic
print_success "JFrog CLI configured"

# Create repositories
print_step "Creating JFrog repositories..."

# Maven repositories
print_step "Creating Maven repositories..."
cat > maven-local-repo.json << EOF
{
  "rclass": "local",
  "packageType": "maven",
  "description": "Local Maven repository for PetClinic",
  "repoLayoutRef": "maven-2-default"
}
EOF

cat > maven-remote-repo.json << EOF
{
  "rclass": "remote",
  "packageType": "maven",
  "url": "https://repo1.maven.org/maven2/",
  "description": "Remote Maven Central proxy",
  "repoLayoutRef": "maven-2-default"
}
EOF

cat > maven-virtual-repo.json << EOF
{
  "rclass": "virtual",
  "packageType": "maven",
  "repositories": ["petclinic-maven-local", "petclinic-maven-remote"],
  "description": "Virtual Maven repository for PetClinic",
  "repoLayoutRef": "maven-2-default"
}
EOF

# Create repositories
jf rt repo-create maven-local-repo.json --key=petclinic-maven-local 2>/dev/null || print_warning "Maven local repo may already exist"
jf rt repo-create maven-remote-repo.json --key=petclinic-maven-remote 2>/dev/null || print_warning "Maven remote repo may already exist"
jf rt repo-create maven-virtual-repo.json --key=petclinic-maven 2>/dev/null || print_warning "Maven virtual repo may already exist"

# Docker repository
print_step "Creating Docker repository..."
cat > docker-local-repo.json << EOF
{
  "rclass": "local",
  "packageType": "docker",
  "description": "Local Docker repository for PetClinic",
  "dockerApiVersion": "V2"
}
EOF

jf rt repo-create docker-local-repo.json --key=petclinic-docker 2>/dev/null || print_warning "Docker repo may already exist"

print_success "Repositories created successfully"

# Cleanup temp files
rm -f maven-local-repo.json maven-remote-repo.json maven-virtual-repo.json docker-local-repo.json

echo

# Generate GitHub secrets configuration
print_step "Generating GitHub Secrets Configuration"
echo -e "${YELLOW}Please add these secrets to your GitHub repository:${NC}"
echo
echo "Repository Settings > Secrets and variables > Actions > New repository secret"
echo
echo "Required secrets:"
echo "=================="
echo "JFROG_URL: $JFROG_URL"
echo "JFROG_USERNAME: $JFROG_USERNAME"
echo "JFROG_PASSWORD: [Your JFrog password/API key]"
echo "JFROG_REGISTRY_URL: ${JFROG_URL#https://}/petclinic-docker"
echo "DB_USERNAME: petclinic"
echo "DB_PASSWORD: [Generate a secure password]"
echo "COSIGN_PASSWORD: [Generate a secure password for image signing]"
echo

# Generate sample values file
print_step "Generating Helm values file..."
cat > helm-values-sample.yaml << EOF
# Sample Helm values for deployment
image:
  repository: "${JFROG_URL#https://}/petclinic-docker/spring-petclinic"
  tag: "latest"

database:
  username: "petclinic"
  password: "changeme-secure-password"

postgresql:
  auth:
    username: "petclinic"
    password: "changeme-secure-password"
    database: "petclinic"

# Enable security features
networkPolicy:
  enabled: true

# Enable monitoring
monitoring:
  enabled: true
EOF

print_success "Sample Helm values created: helm-values-sample.yaml"

echo

# Kubernetes setup
print_step "Kubernetes Setup Instructions"
echo "To deploy the application:"
echo
echo "1. Add Bitnami Helm repository:"
echo "   helm repo add bitnami https://charts.bitnami.com/bitnami"
echo "   helm repo update"
echo
echo "2. Deploy with Helm:"
echo "   helm install petclinic ./helm/spring-petclinic -f helm-values-sample.yaml"
echo
echo "3. Access the application:"
echo "   kubectl port-forward svc/petclinic-spring-petclinic 8080:80"
echo "   Open: http://localhost:8080"
echo

print_step "Next Steps"
echo "1. Push your code to GitHub to trigger the CI/CD pipeline"
echo "2. Monitor the pipeline in GitHub Actions"
echo "3. Check XRay scan results in your JFrog instance"
echo "4. Deploy to Kubernetes using Helm"
echo

print_success "Setup completed! 🎉"
echo
echo -e "${BLUE}For support and documentation, see: README.md${NC}" 