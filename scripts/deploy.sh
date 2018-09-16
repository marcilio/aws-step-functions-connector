#!/bin/bash

#======================================================================
# Deploys Media Processing Pipeline (Step Functions state machines )
# and related Lambda functions
#======================================================================

# Sample invoke:
# ./deploy.sh uat

set -e

# environment name (eg, dev, uat, prod)"
env_type=${1-my}

. "./scripts/${env_type}-env.sh"

stack_name="${env_type}-${app_name}-state-machine"
pack_root_dir="/tmp/${app_name}"
pack_dist_dir="${pack_root_dir}/dist"

(cd $pack_dist_dir \
&& aws cloudformation deploy \
    --template-file $gen_cfn_template \
    --stack-name $stack_name \
    --parameter-overrides \
        ProjectName="$app_name" \
        EnvType="$env_type" \
        TemplatesS3Bucket="$templates_s3_bucket" \
    --capabilities \
        CAPABILITY_IAM
)
