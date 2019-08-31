#!/bin/bash -e

# Create packaged template and upload to S3
sam package --template-file template.yml --s3-bucket drewtechau-aws-deploy --output-template-file packaged.yml

# Apply CloudFormation template
sam deploy --template-file ./packaged.yml --stack-name drewtech-buildkite-deployment-test --capabilities CAPABILITY_IAM

