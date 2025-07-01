# 🛡️DevSecOps Pipeline: Spring PetClinic

This repository demonstrates a secure CI pipeline, Dockerfile creation and Helm charts based on DevSecOps best practices for the [Spring PetClinic](https://github.com/spring-projects/spring-petclinic) application, built using GitHub Actions, Docker, Helm, and JFrog Artifactory/XRay.

## Features

- GitHub’s built-in SAST, secret scanning and Dependabot applied as PR gates  
- Secure Dockerfile with non-root user and multi-stage build
- Image pushed to JFrog Artifactory
- XRay scan with SBOM generation and vulnerability blocking (High vulnerability and above will fail the build and make artifacts blocked)
- Kubernetes deployment via Helm chart
- Branch protection enforced (PRs only, required checks)


## CI Pipeline Overview

# Prerequisites

- JFrog Artifactory with XRay enabled and linked.
- XRay security policies configured to block builds on high+ vulnerabilities.
- GitHub repository secrets set: `JF_URL` and `JF_ACCESS_TOKEN`.

Pipeline defined in `.github/workflows/ci-build.yml`:

1. Security scan (code + secrets)
2. Build and test the application
3. Build Docker image
4. Push to Artifactory
5. XRay scan and SBOM generation


## Repository Structure

```
├── .github/workflows/        # CI pipeline
├── app/spring-petclinic/     # Source code + Dockerfile
├── infra/helm/               # Helm chart for deployment
```
# Run the Docker image locally:

```bash
docker pull yanirlab.jfrog.io/petclinic-docker/spring-petclinic:8595ea4f
docker run -p 8080:8080 yanirlab.jfrog.io/petclinic-docker/spring-petclinic:8595ea4f
```

Access the app at: http://localhost:8080

# Run with Helm (example)

```bash
helm upgrade --install petclinic ./infra/helm \
  --set image.repository=yanirlab.jfrog.io/petclinic-docker/spring-petclinic \
  --set image.tag=8595ea4f
```

## Exportable Artifacts

- Docker image
- Deployment Helm chart
- XRay scan report + SBOM (JSON)
