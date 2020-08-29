# Awshark

[![GitHub Actions Test Status](https://github.com/jdahlke/awshark/workflows/Tests/badge.svg?branch=develop)](https://github.com/jdahlke/awshark/actions)

Simple commandline for some useful AWS tasks for *EC2* and *S3*.


## Installation

    gem install awshark


## Usage

1. List S3 objects
```
exe/awshark s3 list static.bundesimmobilien.de fonts/ --profile=bima
```

2. Update cache control for S3 object
```
exe/awshark s3 update_metadata static.bundesimmobilien.de fonts/ --meta=cache_control:"public, max-age=2592000, s-maxage=2592000" acl:public-read --profile=bima
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
