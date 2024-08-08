```bash
#install aws cli 
sudo apt install python3-pip -y
pip3 install awscli --upgrade --user

#To configure first create credentials for test_user(create test_user also) from IAM.
#Then use Access key and Secret access key for configration aws cli.
#configure aws cli.
aws configure

#test configuration
aws ls 


#create state s3
aws s3 mb s3://terraform-state-day2-sf48er9gytr



```

```bash
cd Day9-DBMigration-S3-EBS/implementations/rds-database-migration
terraform init
terraform plan
terraform graph | dot -Tpng > graph.png
terraform apply
```

```bash
cd Day9-DBMigration-S3-EBS/implementations/rds-database-migration
chmod +x import_data.sh
./import_data.sh
```

```bash
cd Day9-DBMigration-S3-EBS/implementations/rds-database-migration
chmod +x test_queries.sh
./test_queries.sh
```

```bash
terraform destroy
```