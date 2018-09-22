# Intro

Happily using [AWS Step Functions State Machines](https://aws.amazon.com/step-functions/) but spending too much time matching input and output parameters and writing transformation code? Your pain is over :)

Template Languages to the rescue!

## About this Project

This project provides a reusable Lambda function (Connector Lambda) that can be added multiple times to a Step Functions state machine to perform input/output transformations. The Connector Lambda takes any input parameters and uses [Jinja2](http://jinja.pocoo.org/docs/2.10/) template to transform the input into a JSON output. As a results, you can focus on writing reusable Lambda functions for your state machine (or reusing existing Lambdas) without having to write transformation code as part of the Lambda's logic. Instead, transformation code will now be written using a template language!

## Main Use Cases

The figure below illustrates the problem being addressed. On the left-side (A) you see a state machine with three states called ```state-1```, ```state-2```, and ```state-3```. These states could be represented by Lambda functions (state machine tasks) or EC2 workers (state machine activities). You're trying to add these Lambdas to a new state machine but their inputs/outputs don't match up. For example, ```state-1``` produces a red cicle while ```state-2``` expects a green square and ```state-3``` expects a red triangle as inputs. 

 On the right-hand side (B) you can see how the Connector Lambdas (blue ellipses ```Transform 1-2``` and ```Transform 1-3```) can be used to transform ```state-1```'s output to match the expected inputs of ```state-2``` and ```state-3```. The two connector/transform states are backed up by the same Lambda function. Notice that each Connector state uses their own Jinja2 template specified by you. That is, your tranformation code is not scattered through your Lambdas anymore but instead placed into templates that can be easily understood and managed.

![approach-overview](/doc/aws-step-functions-connector-overview.png)

The main use cases for using the Connector Lambda above are:

* You have already built several Lambda functions that take some input parameters and produce some output values and want to put them together as part of a new state machine you're building BUT you don't want to have to modify any Lambda code to match the expected inputs and outputs in the state machine. That is, you want to ```reuse your existing Lambda functions as-is```

* You are building a new state machine and thus several Lambda functions. You're spending a lot of time making sure the Lambda output of a particular state matches the expected input of another state but you feel something is not right. And you're right! You're building highly-coupled Lambdas that only work well in the context of the state machine you're building. Don't let the state machine dictate your Lambda inputs and outputs! You want to ```build context-free lowly-coupled Lambdas with inputs and outputs that make sense regardless of the context```.

## Advantages of using a Template Language for Input/Output Transformation

* (Re)Use any of your existing Lambdas to build new state machines; handle transformations via templates
* Don't worry about creating Lambda functions that fit a particular state machine (highly-coupled Lambdas); create reusable context-free Lambda functions with inputs and outputs that make sense
* Don't spend hours writing and debugging input/output transformation code, instead, write simple templates and rely on the Connector Lambda to do handle the transformation logic

# Example

In the state machine below states ```Legacy System Transform Output``` and ```New System Transform Output``` are Lambda Connectors added to the state machine to transform the outputs of states ```Fetch From Legacy System``` and ```Fetch From New System``` to match the inputs expected by single state ```Generate Employee Report```. A Jinja2 template uploaded to an S3 bucket is used by each transformation state.

![approach-overview](/doc/aws-step-functions-connector-example.png)

# Deploying the Solution on AWS

* Install [pipenv](https://pipenv.readthedocs.io/en/latest/) to manage Python dependencies

* Download and install the [AWS CLI](https://aws.amazon.com/cli/) and make sure you set up your AWS credentials.

* Edit file ```scripts/my-env.sh``` and update the S3 bucket values to use S3 buckets into your AWS account.

```bash
export templates_s3_bucket="[s3-bucket-that-will-contain-the-jinja2-templates]"
export lambda_package_s3_bucket="[s3-bucket-that-will-store-deployment-artifacts]"
```

* Install Python dependencies

```bash
pipenv sync
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
