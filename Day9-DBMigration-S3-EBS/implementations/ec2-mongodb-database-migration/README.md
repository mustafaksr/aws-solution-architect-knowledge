Configure AWS cli:
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
```
Deploy Infrastucture:
```bash
cd Day9-DBMigration-S3-EBS/implementations/rds-database-migration
terraform init
terraform plan
terraform graph | dot -Tpng > graph.png
terraform apply
```

Update and install dependencies if don't have mongodb and dbtools
```bash
# Update and install dependencies if don't have mongodb and dbtools
# sudo apt-get update
# sudo apt-get install -y gnupg curl
# curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
#    sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
# echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
# sudo apt-get update
# sudo apt-get install -y mongodb-org

# # Start MongoDB
# sudo systemctl start mongod
# sudo systemctl enable mongod

# # find right package for your os.https://www.mongodb.com/try/download/database-tools
# wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.10.0.deb
# sudo dpkg -i mongodb-database-tools-ubuntu2204-x86_64-100.10.0.deb

```

Dumb Database:
```bash
mongodump --uri <mongo-uri>/<database-name>
```

Restore database:
```bash
cd Day9-DBMigration-S3-EBS/implementations/ec2-mongodb-database-migration/
chmod +x import_data.sh
./import_data.sh
```

Run test queries:
```bash
cd Day9-DBMigration-S3-EBS/implementations/ec2-mongodb-database-migration/
chmod +x test_queries.sh
./test_queries.sh
```

Destroy Infrastructure:
```bash
terraform destroy
```