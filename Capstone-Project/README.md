# Capstone Project - 


```
zip -j functions/get_api_lambda.zip functions/get_api_lambda.py
zip -j functions/post_api_lambda.zip functions/post_api_lambda.py
zip -j functions/delete_api_lambda.zip functions/delete_api_lambda.py



python3 -m venv myenv
source myenv/bin/activate


pip install mysql-connector-python -t ./package


zip -r9 ../lambda_function.zip .

```


```

# Fetch parameters from AWS Systems Manager Parameter Store
export DATABASE_HOST=$(aws ssm get-parameter --name "/myapp/db_host" --query "Parameter.Value" --region "us-east-2" --output text)
export DATABASE_PASSWORD=$(aws ssm get-parameter --name "/myapp/db_password" --with-decryption --query "Parameter.Value" --region "us-east-2" --output text)
export DATABASE_USER=admin
export OUTPUT_BUCKET_NAME=$(aws ssm get-parameter --name "/myapp/output_bucket" --query "Parameter.Value" --region "us-east-2" --output text)

export API_BASE_URL=$(aws ssm get-parameter --name "/myapp/invoke_url" --query "Parameter.Value" --region "us-east-2" --output text)

# Create example database and table, and insert sample data
mysql -h $(aws ssm get-parameter --name "/myapp/db_host" --query "Parameter.Value" --region "us-east-2" --output text) -u admin -p$(aws ssm get-parameter --name "/myapp/db_password" --with-decryption --query "Parameter.Value" --region "us-east-2" --output text) -e "
CREATE DATABASE IF NOT EXISTS example_db;
USE example_db;

CREATE TABLE IF NOT EXISTS example_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    email VARCHAR(100)
);

INSERT INTO example_table (name, age, email) VALUES 
('Alice Johnson', 30, 'alice.johnson@example.com'),
('Bob Smith', 25, 'bob.smith@example.com'),
('Carol Brown', 40, 'carol.brown@example.com');
"

```