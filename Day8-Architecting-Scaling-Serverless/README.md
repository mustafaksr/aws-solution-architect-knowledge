# 8. Day8-Architecting-Scaling-Serverless
## 8.1. Architecting Serverless Applications

### 8.1.1. Migrating to Serverless

  - **Think in Patterns:** When migrating to serverless, focus on patterns and applications rather than individual functions or resources.
  - **Migration Paradigms:** Two key shifts to consider: implementing computing infrastructure and approaching application development and deployment.
  - **Migration Patterns:**
    - **Leapfrog:** Bypass interim steps and move directly from on-premises legacy architecture to serverless cloud architecture.
    - **Organic:** Migrate on-premises applications to the cloud with minimal changes, often using lift-and-shift to services like EC2 or container services (EKS, ECS, Fargate).
    - **Strangler:** Incrementally refactor and replace monolithic applications with serverless components, enabling safe and gradual migration.
  - **Domain-Driven Design:** Understand the business purpose of each application component to properly decompose and migrate it as a microservice.
  - **CQRS Pattern:** Use Command Query Responsibility Segregation (CQRS) to separate command and query operations, allowing independent scaling of components.
  - **Scalability:** Decouple components to scale them independently, reducing the need to allocate capacity for the entire system.
  - **Schedule-Based Tasks:** Replace cron jobs with Lambda functions triggered by CloudWatch Events or EventBridge rules.
  - **Queue-Based Workers:** Introduce Amazon SQS for queue handling, which can simplify migration without extensive code changes.
  - **Incremental Refactoring:** Use ALB or API Gateway to integrate new serverless components without disrupting the existing system.
  - **Cost Considerations:** Compare infrastructure costs, development effort, and maintenance time between traditional and serverless architectures.
  - **Granular Cost Estimation:** Serverless allows cost estimation on a per-event or per-customer basis, aligning costs closely with business growth.
  - **Not Always the Right Fit:** Serverless may not be suitable for every architecture, so evaluate all factors before migrating.
  - **Increased Agility:** After the initial investment in serverless, applications can be updated more quickly and with greater agility.
  - **APIs and Authorization:** Choose between ALB and API Gateway based on the specific features needed, such as traffic management or API authorization.
  - **Cost Comparison:** Consider the steady vs. spiky traffic patterns when choosing between ALB (hourly charge) and API Gateway (per-request charge).


### 8.1.2. Choosing Compute Services and Data Stores

#### 8.Compute Services
  - **AWS Lambda**:
  - Serverless compute ideal for short-running tasks (<15 mins).
  - Best for spiky, unpredictable workloads.
  - Supports real-time data processing and stateless computing.
  - Simplifies IT automation and reduces operational complexity.
  
  - **AWS Fargate**:
  - Managed compute engine for containers; no need to manage EC2 clusters.
  - Suitable for longer-running processes or larger deployment packages.
  - Ideal for predictable, consistent workloads needing more than 3 GB memory.
  - Supports applications with non-HTTP/S listeners and container image portability via Docker.

  - **Lambda vs. Fargate**:
    - **Lambda**: Best for spiky, less predictable workloads and lightweight applications.
    - **Fargate**: Better for lift-and-shift migrations, longer-running tasks, and consistent workloads.
  - A combination of both may be optimal for certain applications, e.g., orchestrating Docker images in Fargate using AWS Step Functions.

#### 8.Data Stores
  - **Amazon S3**:
  - Versatile storage solution; ideal for data lakes and state storage with low throughput requirements.
  - Supports claim-check pattern and can filter data retrieved by Lambda using S3 Select.

  - **Amazon DynamoDB**:
  - Key-value store with millisecond response times, ideal for high-volume transactional data.
  - Integrates with DynamoDB Streams to capture changes and index them in other stores like S3 or OpenSearch.

  - **Amazon ElastiCache for Redis**:
  - In-memory data store offering sub-millisecond latency; suitable for real-time leaderboards and other low-latency applications.

  - **Amazon Quantum Ledger Database (QLDB)**:
  - Provides cryptographically provable state changes with a distributed ledger system.

  - **Amazon Aurora**:
  - MySQL- and Postgres-compatible relational database with high-throughput and parallelized processing.
  - Aurora Serverless adapts to variable workloads, automatically scaling with traffic demands.

  - **Amazon RDS**:
  - Managed relational database service that supports familiar database engines with reduced administrative overhead.

#### 8.Key Considerations
  - **Optimized Compute**: Match compute services (Lambda, Fargate) to workload requirements for the best performance and efficiency.
  - **Data Store Selection**: Use the CQRS pattern to differentiate between transactional and query needs, optimizing data store choices accordingly.
  - **Handling Multiple Data Stores**: Implement strategies like the saga pattern with AWS Step Functions to manage business transactions across microservices.
  - **ETL and Data Processing**: Choose ETL methods based on needs—real-time (Kinesis, DynamoDB Streams) or batch processing (AWS Glue, Redshift Spectrum).


### 8.1.3. Application Architecture Patterns

  - **Serverless IT Automation**:
    - **Lambda as a Cron Job Replacement**: Replace traditional cron jobs with scheduled AWS Lambda functions triggered by Amazon CloudWatch Events or Amazon EventBridge.
    - **Event-Driven Orchestration**: Use AWS Step Functions and Lambda to orchestrate routine, event-based tasks, such as processing images uploaded to Amazon S3.
    - **Configuration Enforcement**: Implement IT automation with Lambda functions to prevent unwanted configuration changes by automatically reverting unauthorized security group updates and notifying via Amazon SNS.

  - **Serverless Web Applications**:
    - **Core Architecture**: Use Amazon API Gateway for HTTP requests, AWS Lambda for application logic, and Amazon DynamoDB for database functionality.
    - **Authentication**: Incorporate Amazon Cognito for user authentication and identity management, including social identity federation.
    - **Static Content Delivery**: Serve static website assets from Amazon S3 with global distribution via Amazon CloudFront.
    - **Single-Page Applications**: Adapt for single-page apps by leveraging S3 object versioning, CloudFront cache settings, and content TTL management.

  - **Serverless Mobile Backends**:
    - **Real-Time and Offline Data**: Use AWS AppSync for GraphQL-based data synchronization across devices, supporting real-time and offline access.
    - **User Management**: Amazon Cognito handles user management, enabling sign-in with social identities.
    - **Distributed Data Access**: Address challenges of microservice-based architecture by using GraphQL to manage multiple backend service connections.
    - **Enhanced Search and Analytics**: Integrate Amazon Elasticsearch Service via DynamoDB Streams and Lambda for both search and analytics functionalities.

  - **Best Practices**:
    - **Use Managed Services**: Leverage AWS managed services, the Serverless Patterns Collection, and AWS Serverless Application Repository to minimize custom development.
    - **Embrace Event-Driven Design**: Don’t just port code; apply event-driven patterns to fully exploit serverless benefits.
    - **Stay Updated**: Regularly review AWS services for new features or easier ways to implement functionality.
    - **Idempotent, Stateless Functions**: Prefer stateless, idempotent functions; use AWS Step Functions when stateful control is required.
    - **Internal Event Handling**: Keep event processing within AWS services to reduce custom code and increase reliability.
    - **Service Quota Awareness**: Monitor and manage AWS service limits using the AWS Service Quotas console.


## 8.2. Scaling Serverless Architectures

### 8.2.1. Thinking Serverless at Scale
  - **Scalability**: The ability of a system to adapt to increasing demand, crucial for successful, growing systems.
  - **Build Today with Tomorrow in Mind**: Design scalable architectures considering future needs; modularity helps in breaking complex components into smaller, manageable parts.
  - **Microservices Architecture**: Utilize microservices for modern application development, reducing complexity at the component level but introducing new complexities at scale.
  - **Serverless Design Model**: Avoid the need to provision, manually scale, or maintain servers, operating systems, or runtimes by leveraging serverless services.
  - **Scaling Best Practices**:
    - **Separate Application and Database**: Decouple your application from the database to enhance scalability and manageability.
    - **Leverage AWS Global Cloud Infrastructure**: Utilize AWS’s global infrastructure for scalability and reliability.
    - **Avoid Heavy Lifting**: Identify and avoid tasks that require extensive manual effort or resources.
    - **Monitor for Percentile**: Focus on monitoring key performance metrics to ensure optimal scaling.
    - **Refactor Continuously**: Iterate and refine your architecture to accommodate growth and improve performance.
  - **Traditional vs. Serverless Scaling**: Traditional scaling involves managing EC2 instances with Auto Scaling and ElastiCache, while serverless scaling benefits from built-in horizontal scaling and event-driven patterns.
  - **Concurrency in Serverless**: Concurrency refers to the number of AWS Lambda invocations that can run simultaneously; exceeding limits results in throttling.
  - **Event Source Concurrency**:
    - **Synchronous and Asynchronous**: Concurrency is calculated as the request rate multiplied by the average duration; synchronous sources do not have retries.
    - **Streaming Event Sources**: Concurrency is based on the number of shards, with one concurrent Lambda invocation per shard; retries continue until the record is processed or retention expires.
  - **Lambda Parallelization Factor**: AWS Lambda supports a parallelization factor for streams, enabling more than one function invocation per shard.
  - **Polling Event Sources**: Concurrency adjusts based on the depth of the queue in Amazon SQS, up to the function or account limit.
  - **Monitoring and Iteration**: Build meaningful monitoring into your architecture and iterate based on real user traffic to optimize performance.
  - **Service Evolution**: Stay updated with AWS services and third-party tools to leverage new options and optimize workloads.


### 8.2.1. Scaling Considerations for Serverless Services

1. **Service Limits and Capabilities**: Understand the limits and capabilities of AWS services when integrating them to scale serverless architectures.
2. **Timeouts**: Consider service and function timeouts, as these can impact the ability to scale.
3. **Retry Behaviors**: Plan for retry behaviors to ensure reliability without overwhelming services.
4. **Throughput**: Assess the throughput requirements of your application, considering how it scales with increased load.
5. **Payload Size**: Be aware of payload size limitations across services like API Gateway and SQS.
6. **API Gateway Configuration**: Use API Gateway's configuration options (e.g., throttling, caching, and edge-optimized endpoints) to manage access patterns and scale.
7. **Lambda Authorizers**: Lambda authorizers impact overall function concurrency; consider using caching to reduce load.
8. **Error Handling**: Implement error handling in API Gateway to manage retries and prevent downstream overloads.
9. **Service Integration Trade-offs**: Weigh the complexity of direct integrations versus the potential need for intermediary services like SQS.
10. **End-to-End Load Testing**: Perform load testing that mimics production to identify bottlenecks and optimize scaling.
11. **AWS Service Updates**: Regularly review AWS service updates for potential improvements that could enhance scaling.
12. **SQS and Lambda Integration**: Configure batch size, concurrency, and visibility timeout in SQS-Lambda setups to balance performance and error handling.
13. **Lambda Concurrency Limits**: Manage function concurrency limits to protect against runaway costs and avoid overloading downstream services.
14. **Multi-Account Strategy**: Use AWS Organizations and Control Tower for multi-account setups to prevent resource contention between functions.
15. **Visibility Timeout in SQS**: Set the visibility timeout appropriately to avoid message duplication and ensure timely processing.
16. **Dead-Letter Queues**: Use dead-letter queues with a well-defined redrive policy to manage failed messages and maintain queue efficiency.


### 8.2.1. Testing for Peak Load

  - **Serverless Scalability:** Individual services in a serverless architecture can scale independently, allowing you to optimize specific components without affecting others.
  
  - **Importance of Load Testing:** Load testing is crucial to validate assumptions and trade-offs, ensuring your application performs well under peak conditions.

  - **Authentic Testing:** Use real data and access patterns during load testing to accurately simulate production conditions.

  - **Iterative Testing:** Each load test should identify potential bottlenecks or failure points, which you should address and then repeat the tests to refine the architecture.

  - **Focus on Business Drivers:** Make trade-offs that align with key business goals to ensure cost-effective decisions and optimal customer experience.

  - **Error Handling:** Design robust error handling mechanisms and validate them during load testing. Understand your "error budget" and ensure your system can manage failures effectively.

  - **Monitor Service Limits:** Be aware of AWS service limits to avoid throttling or additional costs. Request limit increases if necessary.

  - **Utilize Monitoring Tools:** Leverage built-in logging and metrics in AWS, such as Amazon CloudWatch, for effective monitoring during both testing and production.

  - **Realistic Environment:** Perform integration and load tests in an AWS environment identical to production, avoiding the use of mock services.

  - **DynamoDB Considerations:** Ensure DynamoDB is configured to handle the anticipated load, using on-demand mode or auto scaling as needed.

  - **No One-Size-Fits-All:** There is no universal best practice for load testing. Tailor your approach based on the specific workload and monitor under production-like conditions.


