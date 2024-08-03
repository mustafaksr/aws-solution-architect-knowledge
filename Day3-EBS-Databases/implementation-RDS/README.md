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


#create state s3
aws s3 mb s3://terraform-state-day2-sf48er9gytr


#ssh for vm, log init script
sudo tail -f /var/log/cloud-init-output.log # follow log
sudo cat /var/log/cloud-init-output.log # all log

#access app from htpp://vm-external-ip:8501
#save data with adding new entries
#check bucket for versions
```

```
terraform init
terraform plan
terraform apply
terraform destroy

```