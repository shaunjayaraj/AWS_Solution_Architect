# AWS Infrastructure as Code

This repository contains CloudFormation templates and configurations for managing AWS infrastructure across multiple environments and applications.

## Directory Structure

- `infrastructure/` - Core AWS infrastructure components
- `applications/` - Application-specific infrastructure patterns
- `templates/` - Reusable CloudFormation templates
- `modules/` - Custom CloudFormation modules and macros
- `config/` - Configuration files and parameters
- `scripts/` - Automation and deployment scripts
- `docs/` - Architecture documentation and runbooks
- `tests/` - Infrastructure testing
- `cicd/` - CI/CD pipeline configurations

## Getting Started

1. Review the architecture documentation in `docs/architecture/`
2. Configure environment-specific parameters in `config/environments/`
3. Deploy core infrastructure first, then applications
4. Use the deployment scripts in `scripts/deployment/`

## Best Practices

- Always validate templates before deployment
- Use least privilege for IAM roles
- Tag all resources consistently
- Implement proper backup and disaster recovery
- Monitor costs and optimize regularly
