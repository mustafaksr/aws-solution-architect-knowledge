
```bash
# Create and activate a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows, use `venv\Scripts\activate`

# Install dependencies
pip install -r requirements.txt

# Prepare Lambda package directory
mkdir lambda_package
cp lambda_function.py lambda_package/
pip install --target=lambda_package/ -r requirements.txt

# Zip the Lambda package
cd lambda_package
zip -r ../lambda_function.zip .
cd ..

# Verify zip file
ls -lh lambda_function.zip

aws s3 mb s3://s3-fn-bucket-56g4dgr8
aws s3 cp lambda_function.zip  s3://s3-fn-bucket-56g4dgr8/



cd ..
```

```hcl
terraform init
terraform plan
terraform graph | dot -Tpng > graph.png
terraform apply
terraform destroy
```

```bash
cd Day7-NetworkMon-Lambda/implementations/lambda-s3/

#copy for trigger
aws s3 cp wallpaper.jpg s3://input-bucket-54s546gs4e84h/

#check processed image
aws s3 ls s3://output-bucket-54s546gs4e84h/



```

```hcl
terraform destroy
```