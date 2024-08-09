# 4. Day4-Dynamodb-ElastiCache
## 4.1. AWS ElastiCache

1. **Managed In-Memory Caching Service**: Amazon ElastiCache provides fully managed Redis and Memcached distributed memory caches, facilitating easy deployment, operation, and scaling of in-memory data stores.

2. **Supports Open-Source Engines**: ElastiCache supports Redis and Memcached, both of which are open-source in-memory cache engines. Redis is suited for complex data types and high availability, while Memcached is ideal for smaller, static data.

3. **Performance Enhancement**: By storing frequently accessed data in memory, ElastiCache reduces latency and improves application performance compared to traditional database access.

4. **Data Flow and Usage**: ElastiCache often sits between an application running on Amazon EC2 and a database. Applications first query ElastiCache, reducing the load on databases and improving response times.

5. **Cost-Effective**: ElastiCache offers a pay-as-you-go pricing model with On-Demand Nodes and Reserved Nodes options. On-Demand Nodes are charged per node-hour, while Reserved Nodes provide up to 75% savings with long-term commitments.

6. **Storage and Data Transfer**: The first database snapshot is free, with additional snapshots charged per gigabyte per month. Data transfer charges apply only for traffic in or out of Amazon EC2 instances, not within ElastiCache nodes.

7. **Integration with AWS Services**: ElastiCache integrates with other AWS services, such as Amazon DynamoDB, to enhance performance and reduce database queries.

8. **Security Features**: ElastiCache supports encryption at rest and in transit, with access control managed through AWS IAM. It also provides authentication features for Redis and compliance with standards like HIPAA, FedRAMP, and PCI DSS.

9. **Caching Approaches**: ElastiCache supports lazy loading (data is cached upon first request) and write-through (data is cached simultaneously with database write operations).

10. **Real-World Use Cases**:
    - **Real-Time Bidding**: Reduces database queries by up to 95%, saving costs for high-frequency data access scenarios.
    - **Data Collection Systems**: Frees users from managing cache infrastructure and scales efficiently.
    - **Web Servers**: Improves performance by caching frequently accessed content and session data.

11. **Scalability**: ElastiCache can scale up or down based on demand, providing a centralized cache that can handle varying loads independently of application and database scaling.

12. **Examples of Usage**:
    - **Dream11**: Handles peak demands and scales efficiently to support millions of requests per minute.
    - **KeptMe**: Provides offline functionality by caching frequently accessed data and integrates with Amazon S3 for media storage.

For more information, visit the [AWS ElastiCache website](https://aws.amazon.com/elasticache/).


## 4.2. DynamoDB


### 4.2.1. Introduction

#### What is DynamoDB?

- **NoSQL Database**: DynamoDB is a NoSQL database that supports key-value and document data models.
- **Scalable and Serverless**: It enables the creation of modern, serverless applications that can scale globally from small to petabytes of data and millions of requests per second.
- **High-Performance**: Designed to handle high-performance, internet-scale applications that might overwhelm traditional relational databases.
- **Fully Managed**: DynamoDB is a fully managed service, offloading administrative tasks related to database operations and scaling.
- **Data Protection**: It offers encryption at rest to help secure sensitive data and eliminate operational tasks related to data protection.

#### Benefits of DynamoDB

- **Millisecond Performance**: Provides millisecond response times and supports automatic multi-region replication.
- **Data Encryption and Backup**: Ensures data encryption at rest with automatic backup and restore capabilities.
- **Serverless Database**: Operates as a fully managed, serverless database.
- **AWS Integration**: Integrates with other AWS services for analytics, performance monitoring, and traffic management.

#### Important Concepts and Terminology

- **Tables**: Data is organized into tables, each containing items. For example, a `People` table might store contact information, and a `Locations` table might store building details.
- **Items**: Each table contains items, which are groups of attributes that uniquely identify data. Items in DynamoDB are similar to rows or records in traditional databases.
- **Attributes**: Fundamental data elements within items, akin to fields or columns in other databases.
- **Primary Key**: Uniquely identifies each item in a table. DynamoDB supports two types of primary keys:
  - **Partition Key**: A simple primary key with one attribute.
  - **Partition Key and Sort Key**: A composite primary key with two attributes.
- **Secondary Indexes**: Allow querying data using alternative keys. Types include:
  - **Global Secondary Index**: Has a partition key and sort key different from those on the table.
  - **Local Secondary Index**: Shares the same partition key as the table but with a different sort key.
- **DynamoDB Streams**: Captures data modification events in near real-time. Records include images of added, updated, or deleted items.
- **Read Capacity Units (RCUs)**: Measure the number of reads per second. One RCU supports one strongly consistent read or two eventually consistent reads for items up to 4 KB.
- **Write Capacity Units (WCUs)**: Measure the number of writes per second. One WCU supports one write for items up to 1 KB.
- **Throttling**: Limits the number of requests to prevent overuse of capacity. Throttled requests result in an HTTP 400 error and a ProvisionedThroughputExceededException.
- **Read/Write Capacity Mode**: DynamoDB offers two modes:
  - **On-Demand**: Scales automatically with demand.
  - **Provisioned**: Users specify the read/write throughput capacity.



### 4.2.2. Gathering Information with the AWS Management Console


**Best Practice: Use an Architectural Diagram:**

- **Purpose**: Provides a quick overview of your DynamoDB deployment.
- **Components**: Helps understand major components such as load balancers, VPCs, subnets, frontend, and backend services.
- **Visualization**: Assists in visualizing request flow for troubleshooting.
- **Details**: Add names and IDs to quickly identify each component.

**How to Obtain Information About DynamoDB Resources**
- **Components**: Includes tables, items, attributes, primary keys, and read/write capacity mode.

**Using the DynamoDB Console**
- **Navigate**: Go to the DynamoDB console and select "Tables" from the left navigation pane.
- **Table Information**: Lists table names, status, partition key, sort key, indexes, read/write capacity mode, size, and class.

**Detailed Table Information**
- **Select Table**: Clicking on a table name shows detailed information.
- **Tabs Available**:
  - **Overview**: Includes general and additional information about the table.
  - **Indexes, Monitored Metrics, Global Tables, Backups, Exports and Streams**: Tabs for more detailed settings.

**Monitoring Actions on a Table**
- **Metrics**: Use the Monitor tab to view CloudWatch metrics such as Read usage, Write usage, and Read/Write throttled requests.

**Exploring Individual Table Items**
- **View Items**: Click "Explore table items" to see a list of items returned from the table.
  - **List View**: Scroll to see all items.
  - **Edit Item**: Choose the partition key to access and edit the item in form or JSON format.
  - **JSON Editing**: Click the JSON button to edit the item in JSON format.



### 4.2.3. Using the AWS CLI to Gather Information about DynamoDB

1. **List Tables**: Use `aws dynamodb list-tables` to retrieve a list of all tables in your AWS Region. This helps in identifying which tables are available for further operations.

2. **Describe Table**: Utilize `aws dynamodb describe-table --table-name <TableName>` to get detailed information about a specific DynamoDB table, including its schema, key structure, and provisioned throughput settings.

3. **Get Item**: The `aws dynamodb get-item` command fetches attributes for a particular item using its primary key. You must provide all key attributes for composite keys and can also track read capacity consumption using the `--return-consumed-capacity` option.

4. **Describe Limits**: The `aws dynamodb describe-limits` command provides information about current provisioned-capacity quotas for DynamoDB tables in your account and region.

5. **CloudTrail Integration**: DynamoDB integrates with AWS CloudTrail, which records API calls and provides detailed logs of actions taken by users, roles, or AWS services.

6. **Continuous Delivery**: You can configure CloudTrail to continuously deliver DynamoDB events to an S3 bucket, facilitating long-term storage and analysis of these logs.

7. **Event History**: CloudTrail's Event History allows you to view recent events and details such as the request made, IP address, user identity, and time of the request.

8. **CloudWatch Logs**: CloudTrail events can be linked to CloudWatch log groups, where you can examine detailed logs for further analysis.

9. **DynamoDB Logging**: Advanced logging features are available for more detailed insights into DynamoDB operations. Reviewing CloudTrail documentation can provide additional logging capabilities.

10. **Error Handling**: Understanding runtime errors and proper error handling in DynamoDB is crucial for troubleshooting and optimizing application performance.

11. **Additional Resources**: AWS provides further documentation and resources to help with configuring DynamoDB logging, understanding log file entries, and error handling.

12. **Command Reference**: For more details on each AWS CLI command and its options, refer to the AWS CLI Command Reference documentation.



### 4.2.4. Monitoring DynamoDB

**Importance of Monitoring for Troubleshooting**
- **Purpose**: Collect monitoring data to troubleshoot multipoint failures in AWS solutions.
- **Monitoring Plan**: Before monitoring Amazon ECS, define:
  - Monitoring goals
  - Resources to monitor
  - Frequency of monitoring
  - Monitoring tools
  - Personnel responsible
  - Notification procedures for issues

**How to Monitor DynamoDB**
- **Tool**: Use CloudWatch to monitor DynamoDB resources.
- **Functionality**: CloudWatch collects and processes raw data from DynamoDB into metrics, providing near real-time and historical performance insights.
- **Automatic Metrics**: CloudWatch automatically receives DynamoDB metric data.

**Types of Monitoring Metrics**

1. **Account Metrics**
   - **AccountMaxReads / AccountMaxWrites**: Max number of read/write capacity units used by an account (Unit: Count).
   - **AccountMaxTableLevelReads / AccountMaxTableLevelWrites**: Max read/write capacity units for tables or global secondary indexes (Unit: Count).
   - **AccountProvisionedReadCapacityUtilization / AccountProvisionedWriteCapacityUtilization**: Percentage of provisioned read/write capacity units used by an account (Unit: Percent).
   - **MaxProvisionedTableReadCapacityUtilization / MaxProvisionedTableWriteCapacityUtilization**: Percentage of provisioned read capacity used by the highest provisioned table or index (Unit: Percent).
   - **UserErrors**: Number of requests generating HTTP 400 errors (Unit: Count).

2. **Table Metrics**
   - **ConsumedReadCapacityUnits**: Number of read capacity units consumed (Unit: Count).
   - **ConsumedWriteCapacityUnits**: Number of write capacity units consumed (Unit: Count).
   - **ProvisionedReadCapacityUnits**: Number of provisioned read capacity units for a table or index (Unit: Count).
   - **ProvisionedWriteCapacityUnits**: Number of provisioned write capacity units for a table or index (Unit: Count).

3. **Table Operation Metrics**
   - **ReturnedItemCount**: Number of items returned by Query, Scan, or ExecuteStatement operations (Unit: Count).
   - **SuccessfulRequestLatency**: Elapsed time for successful requests (Unit: Milliseconds).

