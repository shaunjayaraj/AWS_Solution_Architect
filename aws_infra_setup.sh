#!/bin/zsh

# AWS Infrastructure as Code Directory Structure Setup
# This script creates a comprehensive directory structure for AWS CloudFormation infrastructure

set -e

echo "🚀 Creating AWS Infrastructure as Code Directory Structure..."

# Create root directory
ROOT_DIR="aws-infrastructure"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

# Core infrastructure directories
echo "📁 Creating core infrastructure directories..."

# 1. Foundation/Core Infrastructure
mkdir -p infrastructure/core/{accounts,organizations,security,networking,dns,monitoring}
mkdir -p infrastructure/core/accounts/{master,logging,security,shared-services}
mkdir -p infrastructure/core/security/{iam,kms,secrets-manager,security-hub,guardduty}
mkdir -p infrastructure/core/networking/{vpc,transit-gateway,direct-connect,vpn}
mkdir -p infrastructure/core/dns/{route53,certificate-manager}
mkdir -p infrastructure/core/monitoring/{cloudwatch,cloudtrail,config,systems-manager}

# 2. Shared Services
mkdir -p infrastructure/shared-services/{ecr,artifacts,backup,disaster-recovery}
mkdir -p infrastructure/shared-services/ecr/{repositories,lifecycle-policies}
mkdir -p infrastructure/shared-services/artifacts/{s3,lambda-layers,ami}

# 3. Environment-specific infrastructure
mkdir -p infrastructure/environments/{dev,staging,prod,sandbox}
for env in dev staging prod sandbox; do
    mkdir -p "infrastructure/environments/$env"/{compute,storage,databases,messaging,analytics}
    mkdir -p "infrastructure/environments/$env"/compute/{ec2,ecs,eks,lambda,batch}
    mkdir -p "infrastructure/environments/$env"/storage/{s3,efs,fsx}
    mkdir -p "infrastructure/environments/$env"/databases/{rds,dynamodb,elasticache,documentdb,neptune}
    mkdir -p "infrastructure/environments/$env"/messaging/{sqs,sns,eventbridge,mq}
    mkdir -p "infrastructure/environments/$env"/analytics/{kinesis,glue,athena,redshift,emr}
done

# 4. Application-specific infrastructure
echo "📱 Creating application directories..."
mkdir -p applications/{microservices,monoliths,serverless,data-platforms,ml-platforms}

# Microservices patterns
mkdir -p applications/microservices/{service-mesh,api-gateway,event-driven,saga-pattern}
mkdir -p applications/microservices/service-mesh/{istio,app-mesh,consul-connect}
mkdir -p applications/microservices/api-gateway/{rest,graphql,grpc}
mkdir -p applications/microservices/event-driven/{event-sourcing,cqrs,pub-sub}

# Serverless patterns
mkdir -p applications/serverless/{lambda-functions,step-functions,api-gateway,eventbridge}
mkdir -p applications/serverless/lambda-functions/{http-api,event-processing,scheduled-tasks,stream-processing}

# Data platforms
mkdir -p applications/data-platforms/{data-lake,data-warehouse,streaming,batch-processing}
mkdir -p applications/data-platforms/data-lake/{ingestion,processing,storage,cataloging}

# ML platforms
mkdir -p applications/ml-platforms/{training,inference,pipelines,feature-stores}

# 5. Templates and modules
echo "🔧 Creating templates and modules..."
mkdir -p templates/{cloudformation,nested-stacks,cross-stack-references}
mkdir -p templates/cloudformation/{compute,networking,storage,security,monitoring}

mkdir -p modules/{reusable-components,custom-resources,macros}
mkdir -p modules/reusable-components/{vpc-module,alb-module,rds-module,lambda-module}

# 6. Configuration and parameters
mkdir -p config/{environments,global,secrets}
mkdir -p config/environments/{dev,staging,prod,sandbox}
mkdir -p config/global/{tagging,naming-conventions,policies}

# 7. Scripts and automation
mkdir -p scripts/{deployment,validation,cleanup,migration}
mkdir -p scripts/deployment/{stack-sets,cross-region,blue-green}

# 8. Documentation
mkdir -p docs/{architecture,runbooks,troubleshooting,best-practices}
mkdir -p docs/architecture/{diagrams,decisions,patterns}

# 9. Testing
mkdir -p tests/{unit,integration,compliance,performance}
mkdir -p tests/compliance/{aws-config,security-hub,cost-optimization}

# 10. CI/CD
mkdir -p cicd/{pipelines,buildspecs,workflows}
mkdir -p cicd/pipelines/{codepipeline,github-actions,gitlab-ci}

# Create essential files
echo "📄 Creating essential configuration files..."

# Root level files
cat > README.md << 'EOF'
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
EOF

cat > .gitignore << 'EOF'
# AWS
.aws/
*.pem
*.key

# Environment files
.env
.env.local
.env.*.local

# Logs
logs/
*.log

# Temporary files
tmp/
temp/
.tmp/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# CloudFormation
*-stack-outputs.json
*-changeset.json

# Terraform (if mixed)
*.tfstate
*.tfstate.backup
.terraform/
EOF

# Global configuration template
cat > config/global/tags.yaml << 'EOF'
# Global tagging strategy
default_tags:
  Organization: "MyOrg"
  Project: "InfrastructureAsCode"
  Owner: "InfrastructureTeam"
  Environment: "{{ environment }}"
  ManagedBy: "CloudFormation"
  CostCenter: "IT"
  
required_tags:
  - Environment
  - Project
  - Owner
  - CostCenter
EOF

cat > config/global/naming-conventions.yaml << 'EOF'
# Naming conventions for AWS resources
naming_patterns:
  vpc: "{{ org }}-{{ env }}-vpc-{{ region }}"
  subnet: "{{ org }}-{{ env }}-{{ type }}-{{ az }}"
  security_group: "{{ org }}-{{ env }}-{{ service }}-sg"
  lambda: "{{ org }}-{{ env }}-{{ function_name }}"
  s3_bucket: "{{ org }}-{{ env }}-{{ purpose }}-{{ random }}"
  iam_role: "{{ org }}-{{ env }}-{{ service }}-role"
  
abbreviations:
  production: "prod"
  development: "dev"
  staging: "stg"
  sandbox: "sbx"
EOF

# Sample environment configuration
for env in dev staging prod sandbox; do
    cat > "config/environments/${env}/parameters.yaml" << EOF
# ${env} environment parameters
environment:
  name: "${env}"
  region: "us-east-1"
  
networking:
  vpc_cidr: "10.0.0.0/16"
  availability_zones: ["us-east-1a", "us-east-1b", "us-east-1c"]
  
compute:
  instance_types:
    small: "t3.small"
    medium: "t3.medium"
    large: "t3.large"
    
monitoring:
  log_retention_days: 30
  enable_detailed_monitoring: true
EOF
done

# Sample CloudFormation template
cat > templates/cloudformation/networking/vpc-template.yaml << 'EOF'
AWSTemplateFormatVersion: '2010-09-09'
Description: 'VPC with public and private subnets across multiple AZs'

Parameters:
  Environment:
    Type: String
    Description: Environment name
    AllowedValues: [dev, staging, prod, sandbox]
  
  VpcCidr:
    Type: String
    Description: CIDR block for VPC
    Default: '10.0.0.0/16'
  
  AvailabilityZones:
    Type: CommaDelimitedList
    Description: List of Availability Zones
    Default: 'us-east-1a,us-east-1b,us-east-1c'

Resources:
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: !Ref VpcCidr
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: !Sub '${Environment}-vpc'
        - Key: Environment
          Value: !Ref Environment

  # Internet Gateway
  InternetGateway:
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
        - Key: Name
          Value: !Sub '${Environment}-igw'
        - Key: Environment
          Value: !Ref Environment

  AttachGateway:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref VPC
      InternetGatewayId: !Ref InternetGateway

Outputs:
  VpcId:
    Description: VPC ID
    Value: !Ref VPC
    Export:
      Name: !Sub '${Environment}-vpc-id'
  
  VpcCidr:
    Description: VPC CIDR block
    Value: !Ref VpcCidr
    Export:
      Name: !Sub '${Environment}-vpc-cidr'
EOF

# Deployment script template
cat > scripts/deployment/deploy-stack.sh << 'EOF'
#!/bin/bash

# CloudFormation Stack Deployment Script
set -e

ENVIRONMENT=""
STACK_NAME=""
TEMPLATE_PATH=""
PARAMETERS_FILE=""
REGION="us-east-1"

usage() {
    echo "Usage: $0 -e ENVIRONMENT -s STACK_NAME -t TEMPLATE_PATH [-p PARAMETERS_FILE] [-r REGION]"
    exit 1
}

while getopts "e:s:t:p:r:h" opt; do
    case $opt in
        e) ENVIRONMENT="$OPTARG" ;;
        s) STACK_NAME="$OPTARG" ;;
        t) TEMPLATE_PATH="$OPTARG" ;;
        p) PARAMETERS_FILE="$OPTARG" ;;
        r) REGION="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [[ -z "$ENVIRONMENT" || -z "$STACK_NAME" || -z "$TEMPLATE_PATH" ]]; then
    usage
fi

echo "Deploying CloudFormation stack..."
echo "Environment: $ENVIRONMENT"
echo "Stack Name: $STACK_NAME"
echo "Template: $TEMPLATE_PATH"
echo "Region: $REGION"

# Validate template
aws cloudformation validate-template --template-body file://"$TEMPLATE_PATH" --region "$REGION"

# Deploy stack
DEPLOY_CMD="aws cloudformation deploy --template-file $TEMPLATE_PATH --stack-name $STACK_NAME --region $REGION --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM"

if [[ -n "$PARAMETERS_FILE" ]]; then
    DEPLOY_CMD="$DEPLOY_CMD --parameter-overrides file://$PARAMETERS_FILE"
fi

eval $DEPLOY_CMD

echo "Stack deployed successfully!"
EOF

chmod +x scripts/deployment/deploy-stack.sh

# Create sample architectural pattern templates
cat > applications/serverless/lambda-functions/http-api/template.yaml << 'EOF'
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31
Description: 'HTTP API with Lambda functions'

Parameters:
  Environment:
    Type: String
    Description: Environment name

Resources:
  HttpApi:
    Type: AWS::Serverless::HttpApi
    Properties:
      StageName: !Ref Environment
      
  HelloWorldFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: src/
      Handler: index.handler
      Runtime: nodejs18.x
      Events:
        ApiEvent:
          Type: HttpApi
          Properties:
            ApiId: !Ref HttpApi
            Path: /hello
            Method: get

Outputs:
  ApiUrl:
    Description: HTTP API URL
    Value: !Sub 'https://${HttpApi}.execute-api.${AWS::Region}.amazonaws.com/${Environment}'
EOF

# Documentation template
cat > docs/architecture/README.md << 'EOF'
# Architecture Documentation

This directory contains architectural documentation for the AWS infrastructure.

## Architecture Patterns Implemented

### 1. Core Infrastructure
- Multi-account setup with AWS Organizations
- Centralized logging and monitoring
- Network segmentation with VPCs and Transit Gateway
- Security baseline with IAM, KMS, and security services

### 2. Application Patterns
- **Microservices**: Service mesh, API gateway patterns
- **Serverless**: Lambda-based architectures
- **Data Platforms**: Data lakes, streaming, and batch processing
- **ML Platforms**: Training, inference, and MLOps pipelines

### 3. Deployment Patterns
- Blue-Green deployments
- Canary releases
- Infrastructure as Code with CloudFormation
- GitOps workflows

## Getting Started

1. Review the architectural decision records (ADRs)
2. Understand the naming conventions
3. Follow the deployment procedures
4. Implement monitoring and alerting

## Best Practices

- Use least privilege access
- Implement proper tagging
- Enable logging and monitoring
- Regular security assessments
- Cost optimization reviews
EOF

# Create package.json for any Node.js tooling
cat > package.json << 'EOF'
{
  "name": "aws-infrastructure",
  "version": "1.0.0",
  "description": "AWS Infrastructure as Code with CloudFormation",
  "scripts": {
    "validate": "find . -name '*.yaml' -o -name '*.yml' | grep -E 'templates|infrastructure' | xargs -I {} aws cloudformation validate-template --template-body file://{}",
    "lint": "cfn-lint templates/**/*.yaml infrastructure/**/*.yaml",
    "test": "npm run validate && npm run lint"
  },
  "keywords": ["aws", "cloudformation", "infrastructure", "iac"],
  "author": "Infrastructure Team",
  "license": "MIT",
  "devDependencies": {
    "cfn-lint": "^0.24.0"
  }
}
EOF

echo ""
echo "✅ AWS Infrastructure as Code directory structure created successfully!"
echo ""
echo "📁 Directory structure overview:"
echo "├── infrastructure/          # Core AWS infrastructure"
echo "├── applications/           # Application patterns"
echo "├── templates/              # Reusable CloudFormation templates"
echo "├── modules/                # Custom modules and macros"
echo "├── config/                 # Configuration and parameters"
echo "├── scripts/                # Automation scripts"
echo "├── docs/                   # Documentation"
echo "├── tests/                  # Infrastructure tests"
echo "└── cicd/                   # CI/CD configurations"
echo ""
echo "🚀 Next steps:"
echo "1. Review and customize config/global/ settings"
echo "2. Update environment parameters in config/environments/"
echo "3. Start with core infrastructure deployment"
echo "4. Explore architectural patterns in applications/"
echo "5. Set up CI/CD pipelines"
echo ""
echo "💡 Use scripts/deployment/deploy-stack.sh to deploy CloudFormation stacks"
echo "📖 Check docs/architecture/ for detailed documentation"