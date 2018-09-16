#!/bin/bash

# Environment name (eg, dev, qa, prod)
export env_type="dev"

# Python virtual environment location for packaging
if [ -z "$virtual_env_location" ]; then
    virtual_env_location=`pipenv --venv`
fi

# S3 bucket where file will be copied to
export templates_s3_bucket="aws-step-functions-connector"

# S3 bucket to store packaged Lambdas
export lambda_package_s3_bucket="pipeline-creation-artifacts"

# You probably don't need to change these values
export app_name="aws-step-functions-connector"
export cfn_template="cfn_template.yaml"
export gen_cfn_template="generated-${cfn_template}"