# Fetch parameters from AWS Systems Manager Parameter Store
export DATABASE_HOST=$(aws ssm get-parameter --name "/myapp/db_host" --query "Parameter.Value" --region us-east-2 --output text)
export DATABASE_PASSWORD=$(aws ssm get-parameter --name "/myapp/db_password" --with-decryption --query "Parameter.Value" --region us-east-2 --output text)
export DATABASE_USER=admin

# Define your query
QUERY0="USE tableau; SELECT row_id, order_id, order_date FROM orders LIMIT 3;"

QUERY1="USE tableau; SELECT * FROM people LIMIT 3;"

QUERY2="USE tableau; SELECT * FROM returns LIMIT 3;"

# Execute the query
echo ""
echo "orders table first 3 columns and 3 rows:"
mysql -h $DATABASE_HOST -u $DATABASE_USER -p$DATABASE_PASSWORD -e "$QUERY0"

echo ""
echo "people table first 3 rows:"
mysql -h $DATABASE_HOST -u $DATABASE_USER -p$DATABASE_PASSWORD -e "$QUERY1"

echo ""
echo "returns table first 3 rows:"
mysql -h $DATABASE_HOST -u $DATABASE_USER -p$DATABASE_PASSWORD -e "$QUERY2"

