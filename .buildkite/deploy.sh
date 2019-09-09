#!/bin/bash -e

# Create packaged template and upload to S3
#sam package --template-file template.yml --s3-bucket drewtechau-aws-deploy --output-template-file packaged.yml

# Apply CloudFormation template
#sam deploy --template-file ./packaged.yml --stack-name drewtech-buildkite-deployment-test --capabilities CAPABILITY_IAM

echo "before cd terraform"
cd terraform
echo "after cd terraform"
echo "before terraform init"
terraform init
echo "after terraform init"
echo "before terraform apply"
terraform apply -auto-approve
echo "after terraform apply"
