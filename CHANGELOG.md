## Changelog

#### 1.6.0
- [new] `awshark cf [command] --format` option to export CF template not always as JSON ()

#### 1.5.1
- [new] `awshark cf [command] --bucket` option allows S3 path prefix

#### 1.5.0
- [new] add `awshark ssm list` to list AWS Parameter Store secrets
- [new] add `awshark ssm deploy` to update AWS Parameter Store secrets

#### 1.4.0
- [new] add `awshark cf save` to save AWS Cloud Formation templates as file

#### 1.3.0
- [new] add `awshark ec2 authorize` and `unauthorize`

#### 1.2.0
- [new] add `awshark ecs list`
- [break] remove options `--profile` and `--region`; use `AWS_PROFILE` and `AWS_REGION` instead

#### 1.1.0
- ssm support added `<%= ssm["/#{stage}/app/application/db_host"] %>`

#### 1.0.0
- initial version
