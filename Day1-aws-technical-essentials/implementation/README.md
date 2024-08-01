```
#install aws cli 
sudo apt install python3-pip -y
pip3 install awscli --upgrade --user

#To configure first create credentials for test_user(create test_user also) from IAM.
#Then use Access key and Secret access key for configration aws cli.
#configure aws cli.
aws configure

#test configuration
aws ls #aws mb s3://test-bucket-create-sd4gsge8 && aws rb s3://test-bucket-create-sd4gsge8
```

```
terraform init
terraform plan
terraform apply
terraform destroy

```