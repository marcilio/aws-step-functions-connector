# Intro

```Use Jinja2 templates to perform complex stage-to-stage transforms on AWS Step Function State Machines``` and abstract data transformation from your main state machine logic.

Anyone who's built a reasonably-sized AWS Step Function state machine knows that a reasonable amount of time is spent managing stage inputs and outputs, ie, transforming the JSON output structure of one stage to fit the JSON input structure of another stage. While AWS provides a way to query the JSON input and do some basic tranformation via JsonPath there are scenarios where one needs a more expresive language to perform complext transformations. 

Jinja2 to the rescue!

This project uses Jinja2 and a Lambda function (connector) to perform transformations on state machine stage outputs to match the expected input of transitioned stages. Just add the connector Lambda function to the state machine and specify the Jinja2 template to be used. The input values received by the Lambda are automatically exposed to the Jinja2 template. Use multiple connectors if needed!

# Example

![approach-overview](/doc/aws-step-functions-connector.png)

# Deploying the Solution on AWS

* Download and install the [AWS CLI](https://aws.amazon.com/cli/) and make sure you set up your AWS credentials.

* Edit file ```scripts/my-env.sh``` and update the S3 bucket values to use S3 buckets into your AWS account.

```bash
export templates_s3_bucket="[s3-bucket-that-will-contain-the-jinja2-templates]"
export lambda_package_s3_bucket="[s3-bucket-that-will-store-deployment-artifacts]"
```

* Copy the sample Jinja2 templates to the S3 bucket:

```bash
aws s3 cp jinja/legacy-system-sample.jinja2 s3://[s3-bucket-that-will-contain-jinja2-templates]
aws s3 cp jinja/new-system-sample.jinja2 s3://[s3-bucket-that-will-contain-jinja2-templates]
```

* Deploy the Lambda function and Step Functions state machine:

```bash
export AWS_PROFILE=[your-aws-profile]
./scripts/package.sh
./scripts/deploy.sh
```

* Go to the AWS Console and run the Sample Step Functions State Machine.

 Look at the inputs and outputs and notice how the connector has transformed their structure.