# 🛡️ DevSecOps CI/CD Demo with JFrog Platform

[![Scanned by Frogbot](https://raw.github.com/jfrog/frogbot/master/images/frogbot-badge.svg)](https://docs.jfrog-applications.jfrog.io/jfrog-applications/frogbot)

A complete DevSecOps pipeline demonstrating **JFrog Platform integration** with GitHub Actions, featuring OIDC authentication, multi-layer security scanning, and policy enforcement.

## 🎯 Key Features

### 🔐 Secure Authentication
- **OIDC Integration**: Zero static tokens - authenticate to JFrog using GitHub's OIDC provider
- Automatic token rotation and secure credential management

### 📦 Unified Dependency Management
- **Maven & Gradle**: All dependencies proxied through JFrog Artifactory
- **Docker Base Images**: Pulled through JFrog for caching and security scanning
- Single source of truth for all artifacts

### 🛡️ Multi-Layer Security
- **Pre-Merge**: Frogbot scans PRs for vulnerabilities, secrets, and license issues
- **Build-Time**: Docker images scanned before push (security gate)
- **Post-Build**: XRay policy enforcement with watch-based scanning
- **Fail-Fast**: Builds blocked on policy violations

### 🚀 CI/CD Workflows

**Maven/Gradle Builds** (`ci-maven.yml`, `ci-gradle.yml`)
- Dependencies resolved from JFrog via `jf mvn` and `jf gradle` commands
- Automatic configuration through JFrog CLI

**Docker Build** (`ci-build.yml`)
```
Build → Scan → Push → Publish → XRay Scan
```
1. Build Docker image with base images from JFrog
2. Scan locally with XRay
3. Push to JFrog only if scan passes
4. Publish build info for traceability
5. Scan build against XRay watches

**Frogbot PR Scanning** (`frogbot-scan-pull-request.yaml`)
- Automated security scanning on every PR
- Comments findings directly on pull requests

## 📋 Prerequisites

### JFrog Configuration
- Artifactory with repositories:
  - `demo-dev-libs-release` (Maven)
  - `demo-dev-gradle-dev` (Gradle)
  - `demo-docker` (Docker virtual with remote proxy)
- XRay watches and policies configured
- OIDC integration set up

### GitHub Configuration
- **Secrets**:
  - `JF_URL`: JFrog platform URL (e.g., `https://yourcompany.jfrog.io`)
- **Variables**:
  - `DOCKER_REPO`: Docker repository path (e.g., `yourcompany.jfrog.io/demo-docker`)
- **Permissions**:
  - `id-token: write` (for OIDC)
  - `contents: write`
  - `pull-requests: write`
  - `security-events: write`

## 🚀 Usage

### Trigger the Pipeline

Changes to `app/**` trigger the workflows:

```bash
# Make a change
echo "# Update" >> app/spring-petclinic/README.md

# Create PR
git checkout -b feature/my-change
git add .
git commit -m "feat: my feature"
git push origin feature/my-change
gh pr create --title "My Feature" --body "Description"

# Merge to trigger full pipeline
gh pr merge --merge
```

### Pipeline Behavior

- **PR Opened**: Frogbot scans for vulnerabilities
- **PR Merged**: Full build pipeline executes
  - Maven/Gradle builds resolve deps from JFrog
  - Docker build pulls base images through JFrog
  - Security scans at multiple stages
  - **Deployment blocked if security violations found**

## 📁 Repository Structure

```
CI-demo/
├── .github/workflows/
│   ├── ci-build.yml                    # Docker build with security scanning
│   ├── ci-maven.yml                    # Maven build via JFrog
│   ├── ci-gradle.yml                   # Gradle build via JFrog
│   ├── frogbot-scan-pull-request.yaml  # PR security scanning
│   └── frogbot-scan-repository.yaml    # Repository scanning
├── app/spring-petclinic/               # Spring Boot application
│   ├── Dockerfile                      # Multi-stage secure build
│   ├── pom.xml                         # Maven config (no JFrog URLs!)
│   └── build.gradle                    # Gradle config (no JFrog URLs!)
└── infra/helm/                         # Kubernetes deployment charts
```

## 🔑 Key Design Principles

1. **No Credentials in Code**: OIDC authentication eliminates static tokens
2. **Clean Source Code**: JFrog URLs only in CI workflows, not in app code
3. **Security Gates**: Multiple scan points with automatic blocking
4. **Fail Fast**: Violations caught early, before deployment
5. **Full Traceability**: Build info published for audit and governance

## 🛠️ Technology Stack

- **Application**: Spring Boot (PetClinic)
- **CI/CD**: GitHub Actions
- **Artifact Management**: JFrog Artifactory
- **Security Scanning**: JFrog XRay, Frogbot
- **Container Runtime**: Docker
- **Deployment**: Kubernetes + Helm
- **Authentication**: GitHub OIDC

## 📖 Learn More

- [JFrog CLI Documentation](https://jfrog.com/help/r/jfrog-cli)
- [JFrog OIDC Integration](https://jfrog.com/help/r/jfrog-platform-administration-documentation/oidc-integration)
- [Frogbot Documentation](https://docs.jfrog-applications.jfrog.io/jfrog-applications/frogbot)
- [Spring PetClinic](https://github.com/spring-projects/spring-petclinic)

---

**Built with ❤️ to demonstrate modern DevSecOps practices**
