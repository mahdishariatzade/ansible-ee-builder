# Ansible Execution Environment Builder

[![Build and Push Ansible Execution Environment](https://github.com/${{ github.repository }}/actions/workflows/build-ee.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/build-ee.yml)
[![Container Security](https://github.com/${{ github.repository }}/actions/workflows/security.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/security.yml)

A comprehensive Ansible Execution Environment (EE) built with `ansible-builder` that includes essential collections, tools, and dependencies for modern automation workflows.

## 🚀 Quick Start

### Pull and Run

```bash
# Pull the latest image
docker pull ghcr.io/$(echo $GITHUB_REPOSITORY | tr '[:upper:]' '[:lower:]'):latest

# Run Ansible commands
docker run --rm -v $(pwd):/workspace ghcr.io/$(echo $GITHUB_REPOSITORY | tr '[:upper:]' '[:lower:]'):latest ansible --version

# Run a playbook
docker run --rm -v $(pwd):/workspace -w /workspace ghcr.io/$(echo $GITHUB_REPOSITORY | tr '[:upper:]' '[:lower:]'):latest ansible-playbook site.yml
```

### With Ansible Navigator

```bash
# Install ansible-navigator
pip install ansible-navigator

# Configure navigator to use your EE
cat > ansible-navigator.yml << EOF
---
ansible-navigator:
  execution-environment:
    image: ghcr.io/$(echo $GITHUB_REPOSITORY | tr '[:upper:]' '[:lower:]'):latest
  mode: stdout
EOF

# Run playbooks with navigator
ansible-navigator run site.yml
```

## 📦 What's Included

### Core Tools
- **Ansible Core**: Latest stable version with all essential modules
- **Ansible Runner**: For programmatic Ansible execution
- **Python 3.11**: Modern Python runtime with comprehensive standard library

### Cloud & Infrastructure Collections
- `amazon.aws` - AWS automation
- `azure.azcollection` - Microsoft Azure automation  
- `google.cloud` - Google Cloud Platform automation
- `kubernetes.core` - Kubernetes resource management

### Network Automation
- `cisco.ios` - Cisco IOS device management
- `cisco.iosxr` - Cisco IOS-XR automation
- `cisco.nxos` - Cisco Nexus automation
- `arista.eos` - Arista EOS network automation
- `junipernetworks.junos` - Juniper JUNOS automation

### Essential Collections
- `community.general` - General purpose modules and plugins
- `community.docker` - Docker container and image management
- `community.crypto` - Cryptographic operations and certificate management
- `community.postgresql` - PostgreSQL database management
- `community.mysql` - MySQL/MariaDB database automation
- `ansible.posix` - POSIX system utilities
- `ansible.utils` - Utility plugins and filters

### Python Libraries
- **Cloud SDKs**: boto3, azure-mgmt-core, google-auth
- **HTTP/API**: requests, urllib3
- **Network Tools**: netaddr, textfsm, ntc-templates
- **Security**: cryptography, paramiko
- **Databases**: psycopg2-binary, PyMySQL
- **Utilities**: PyYAML, jinja2, jsonschema

### System Dependencies
- SSH clients and utilities
- SSL/TLS support libraries
- Database client libraries
- Compression and archive tools
- Network utilities (curl, wget, jq)

## 🔧 Configuration

### File Structure
```
├── execution-environment.yml    # Main EE configuration
├── requirements.txt            # Python dependencies
├── requirements.yml           # Ansible collections and roles
├── bindep.txt                # System package dependencies
├── .github/workflows/
│   └── build-ee.yml          # CI/CD pipeline
└── README.md                 # This file
```

### Customization

#### Adding Python Packages
Edit `requirements.txt`:
```
# Add your Python dependencies
my-custom-package>=1.0.0
```

#### Adding Ansible Collections
Edit `requirements.yml`:
```yaml
collections:
  - name: my.custom.collection
    version: ">=1.0.0"
```

#### Adding System Packages
Edit `bindep.txt`:
```
# Add system packages
my-system-package [platform:centos-8]
```

#### Modifying Build Steps
Edit `execution-environment.yml`:
```yaml
additional_build_steps:
  prepend_base:
    - RUN dnf install -y my-package
  append_final:
    - RUN my-configuration-command
```

## 🏗️ Building Locally

### Prerequisites
```bash
pip install ansible-dev-tools ansible-builder>=3.0.0
```

### Build Commands
```bash
# Basic build
ansible-builder build --tag my-custom-ee:latest

# Build with verbose output
ansible-builder build --tag my-custom-ee:latest --verbosity 2

# Build and push to registry
ansible-builder build --tag registry.example.com/my-ee:latest
docker push registry.example.com/my-ee:latest
```

## 🔄 CI/CD Pipeline

The GitHub Actions workflow automatically:

### On Push to Main/Develop
- ✅ Validates configuration files
- 🏗️ Builds multi-architecture images (amd64, arm64)
- 🧪 Tests the built image functionality
- 🔍 Scans for security vulnerabilities
- 📦 Pushes to GitHub Container Registry
- 📋 Generates Software Bill of Materials (SBOM)

### On Pull Requests
- ✅ Builds and tests without pushing
- 🔍 Security scanning and reporting
- 📊 Provides build status and logs

### On Version Tags
- 🏷️ Creates semantic version tags
- 📝 Generates release notes
- 🚀 Creates GitHub releases with SBOM

### Triggers
- **Automatic**: Push to main/develop branches
- **Manual**: Workflow dispatch with custom tags
- **Scheduled**: Weekly security scans (optional)

## 🔒 Security Features

- **Vulnerability Scanning**: Automated with Anchore/Grype
- **SBOM Generation**: Software Bill of Materials for compliance
- **Non-root User**: Runs as UID 1000 for security
- **Minimal Base**: Based on Red Hat UBI with minimal attack surface
- **Secret Management**: Supports HashiCorp Vault integration

## 📈 Usage Examples

### Basic Automation
```bash
# System information gathering
docker run --rm -v $(pwd):/workspace -w /workspace \
  ghcr.io/your-repo/ansible-ee:latest \
  ansible localhost -m setup

# File operations
docker run --rm -v $(pwd):/workspace -w /workspace \
  ghcr.io/your-repo/ansible-ee:latest \
  ansible localhost -m file -a "path=/tmp/test state=directory"
```

### Cloud Automation
```bash
# AWS EC2 instance management
docker run --rm -v $(pwd):/workspace -w /workspace \
  -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_REGION \
  ghcr.io/your-repo/ansible-ee:latest \
  ansible-playbook aws_instances.yml

# Kubernetes deployment
docker run --rm -v $(pwd):/workspace -v ~/.kube:/root/.kube \
  ghcr.io/your-repo/ansible-ee:latest \
  ansible-playbook k8s_deployment.yml
```

### Network Configuration
```bash
# Cisco router configuration
docker run --rm -v $(pwd):/workspace -w /workspace \
  ghcr.io/your-repo/ansible-ee:latest \
  ansible-playbook -i inventory/network.yml cisco_config.yml
```

## 🐛 Troubleshooting

### Common Issues

#### Build Failures
```bash
# Check ansible-builder version
ansible-builder --version

# Validate configuration
python -c "import yaml; print(yaml.safe_load(open('execution-environment.yml')))"

# Build with maximum verbosity
ansible-builder build --tag test:latest --verbosity 3
```

#### Runtime Issues
```bash
# Check image contents
docker run --rm -it ghcr.io/your-repo/ansible-ee:latest /bin/bash

# Verify collections
docker run --rm ghcr.io/your-repo/ansible-ee:latest ansible-galaxy collection list

# Check Python packages
docker run --rm ghcr.io/your-repo/ansible-ee:latest pip list
```

#### Permission Problems
```bash
# Run as specific user
docker run --rm --user $(id -u):$(id -g) -v $(pwd):/workspace \
  ghcr.io/your-repo/ansible-ee:latest ansible --version

# Check container user
docker run --rm ghcr.io/your-repo/ansible-ee:latest whoami
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with `ansible-builder build`
5. Submit a pull request

### Development Setup
```bash
git clone https://github.com/your-username/ansible-ee-builder.git
cd ansible-ee-builder
python -m venv venv
source venv/bin/activate
pip install ansible-dev-tools ansible-builder>=3.0.0
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 References

- [Ansible Builder Documentation](https://ansible-builder.readthedocs.io/)
- [Execution Environment Guide](https://docs.ansible.com/automation-controller/latest/html/userguide/execution_environments.html)
- [Ansible Navigator](https://ansible-navigator.readthedocs.io/)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## 📊 Project Status

- ✅ **Stable**: Core functionality working
- 🔄 **Active Development**: Regular updates and improvements
- 📈 **Growing**: Adding more collections and tools
- 🛡️ **Secure**: Regular security updates and scanning

---

**Built with ❤️ for the Ansible Community** 