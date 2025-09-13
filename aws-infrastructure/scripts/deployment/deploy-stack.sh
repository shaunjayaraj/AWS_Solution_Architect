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
