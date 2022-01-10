## Changelog

#### 1.3.0
- [new] add `awshark ec2 authorize` and `unauthorize`

#### 1.2.0
- [new] add `awshark ecs list`
- [break] remove options `--profile` and `--region`; use `AWS_PROFILE` and `AWS_REGION` instead

#### 1.1.0
- ssm support added `<%= ssm["/#{stage}/app/application/db_host"] %>`

#### 1.0.0
- initial version
