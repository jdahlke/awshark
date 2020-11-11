# Awshark

[![GitHub Actions Test Status](https://github.com/jdahlke/awshark/workflows/Tests/badge.svg?branch=develop)](https://github.com/jdahlke/awshark/actions)

Simple command-line tool for some useful tasks for AWS *EC2*, *S3* and *CloudFormation*.


## Installation

    gem install awshark


## Usage

These are just are few quick examples.
For a further information visit the [Wiki](https://github.com/jdahlke/awshark/wiki).

1. List all commands
```
awshark help
```

2. List all S3 buckets
```
awshark s3 list --profile=AWS_PROFILE
```

3. List all objects in a specific S3 bucket
```
awshark s3 objects BUCKET_NAME fonts/ --profile=AWS_PROFILE
```

4. List all EC2 instances in a region
```
awshark ec2 list --profile=AWS_PROFILE
```


## Development

After checking out the repo, run `bin/setup` to install dependencies.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run

    gem build awshark.gemspec
    gem install --local awshark-0.1.0.gem
    rm awshark-0.1.0.gem


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jdahlke/awshark.
