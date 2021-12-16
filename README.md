# Awshark

[![GitHub Actions Test Status](https://github.com/jdahlke/awshark/workflows/Tests/badge.svg?branch=develop)](https://github.com/jdahlke/awshark/actions)

Simple command-line tool for some useful tasks for AWS *EC2*, *S3* and *CloudFormation*.


### Installation

```
gem install awshark
```


### Usage

Use `AWS_PROFILE=PROFILE` and/or `AWS_REGION=REGION` to configure the internal AWS clients.

#### S3 commands

List all S3 buckets
```
awshark s3 list
```

List all objects in a specific S3 bucket
```
awshark s3 objects BUCKET_NAME fonts/
```

#### EC2 commands

List all EC2 instances in a region
```
awshark ec2 list
```

#### ECS commands

List all EC2 instances in a region
```
awshark ecs list
```

#### Cloud Formation commands

Update (diff) Cloud Formation stack
```
awshark cf deploy TEMPLATE_PATH --stage=STAGE --bucket=S3_BUCKET.bundesimmo.de

awshark cf diff TEMPLATE_PATH --stage=STAGE --bucket=S3_BUCKET.bundesimmo.de
```

For a further information visit the [Wiki](https://github.com/jdahlke/awshark/wiki).


### Development

After checking out the repo, run `bin/setup` to install dependencies.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.


### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jdahlke/awshark.
