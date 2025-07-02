# 🛡️ DevSecOps Pipeline: Spring PetClinic

[![Scanned by Frogbot](https://raw.github.com/jfrog/frogbot/master/images/frogbot-badge.svg)](https://docs.jfrog-applications.jfrog.io/jfrog-applications/frogbot)

A DevSecOps pipeline built around the [Spring PetClinic](https://github.com/spring-projects/spring-petclinic) app, showcasing the integration of modern security best practices. This repo demonstrates how to embed multi-layer scanning, policy enforcement, and compliance reporting directly into CI workflows using GitHub Actions and the JFrog Platform.

## Features

### Multi-Layer Security Scanning
- Pre-build dependency scan (SCA, secrets, SAST) with Frogbot
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
   - Automated security scanning of pull requests with Frogbot
   - Run SCA (Software Composition Analysis), secrets detection, and SAST
   - **Interactive feedback**: Security findings posted directly on pull requests
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

