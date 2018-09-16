#!/bin/bash

#======================================================================
# Package Lambda Function for AWS Serverless Repository
# - Make sure AWS_PROFILE env variable is set properly
#======================================================================

# Sample invoke using pipenv:
# ./package.sh uat

set -e

# environment name (eg, dev, uat, prod)"
env_type=${1-my}

. "./scripts/${env_type}-env.sh"

pack_root_dir="/tmp/${app_name}"
pack_dist_dir="${pack_root_dir}/dist"

rm -rf "$pack_root_dir"
mkdir -p $pack_dist_dir
cp -R . $pack_dist_dir/
cp -R "${virtual_env_location}/lib/python3.6/site-packages/" "${pack_dist_dir}/lambdas"

echo "Creating Lambda package under '${pack_dist_dir}' and uploading it to s3://${lambda_package_s3_bucket}"
(cd $pack_dist_dir \
 && aws cloudformation package \
    --template-file "cloudformation/${cfn_template}" \
    --s3-bucket $lambda_package_s3_bucket \
    --output-template-file $gen_cfn_template \
 && cat $gen_cfn_template)

