# 🛡️ DevSecOps Pipeline: Spring PetClinic

A DevSecOps pipeline implementation showcasing modern security practices through the [Spring PetClinic](https://github.com/spring-projects/spring-petclinic) application. This repository demonstrates how to integrate multi-layer security scanning, policy enforcement, and compliance reporting into CI workflows using GitHub Actions, JFrog Platform, and Kubernetes.

## Features

### Multi-Layer Security Scanning
- Pre-build dependency scan (SCA, secrets, SAST) with JFrog CLI
- Post-build policy enforcement via JFrog XRay
- GitHub native security (Dependabot, secret scanning, CodeQL)

### Container Security
- Multi-stage Dockerfile with non-root user
- Secure image builds and distribution via JFrog Artifactory
- Vulnerability blocking on High+ severity findings

## Prerequisites

- JFrog Artifactory with XRay policies configured
- GitHub secrets: `JF_URL`, `JF_ACCESS_TOKEN`

## 🚀 CI Pipeline Overview

### Pipeline Flow

1. **Build Preparation**
   - Generate unique image tags from Git commit SHA
   - Parse Docker registry endpoints from JFrog URL
   - Set up environment variables for downstream jobs

2. **Pre-Build Security Scan** 
   - Scan local project dependencies (Maven/Gradle) for vulnerabilities
   - Run SCA (Software Composition Analysis), secrets detection, and SAST
   - **Fail-fast approach**: Build stops immediately on High+ severity CVEs
   - Prevents building and distributing vulnerable artifacts

3. **Container Build & Push**
   - Build secure multi-stage Docker image with non-root user
   - Push container to JFrog Artifactory repository
   - Collect build metadata and Git information
   - Publish build info to JFrog for tracking and governance

4. **Post-Build Policy Enforcement**
   - Scan published artifacts against JFrog XRay security policies
   - Enforce organizational security standards and compliance requirements
   - **Automatic deployment blocking**: High+ severity CVEs trigger immediate build failure
   - Generate comprehensive vulnerability reports with remediation guidance

5. **Compliance & Reporting**
   - Generate Software Bill of Materials (SBOM)
   - Export security scan results in JSON format
   - Upload artifacts for audit trails and compliance reporting

## 📁 Repository Structure

```
CI-demo/
├── .github/workflows/        # CI pipeline configuration
├── app/spring-petclinic/     # Spring PetClinic application + Dockerfile
└── infra/helm/              # Helm charts for Kubernetes deployment
    ├── charts/
    │   ├── petclinic-app/   # Application chart
    │   └── postgresql/      # Database chart
    └── umbrella-petclinic/  # Umbrella chart
```

