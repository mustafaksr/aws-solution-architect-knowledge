# 3. Day 3 - AWS S3-EBS-Databases
## 3.1. Getting Started with Amazon Simple Storage Service (Amazon S3)

### 3.1.1. Storage Fundamentals

- **Amazon S3** is an object storage service that allows storing and retrieving any amount of data from anywhere on the web.
- **Block Storage** divides files into blocks, each assigned a unique identifier, allowing individual blocks to be modified separately. It's ideal for databases where specific pieces of data need to be accessed or modified without retrieving the entire file.
- **File Storage** uses a hierarchical structure (directories, subdirectories, files) to organize data, requiring knowledge of exact paths to locate and access files.
- **Object Storage** in Amazon S3 is a flat structure where data, called objects, are stored in buckets. It can visually mimic a hierarchy using key name prefixes and delimiters, although the storage remains flat.


#### 3.1.2. Amazon S3 Fundamentals

- **Amazon S3 Overview**: A highly scalable, secure, and performant object storage service designed for simplicity and robustness, providing the same infrastructure used by Amazon globally.

- **Object Storage Structure**: S3 uses a flat storage structure where objects (data) are stored in buckets. Hierarchies can be simulated using prefixes and delimiters to organize data logically, though physically, the structure remains flat.

- **Buckets**: Permanent containers that hold objects. Bucket names are globally unique, can’t be renamed, and must follow specific naming rules (e.g., DNS-compliant, 3-63 characters, lowercase letters, and no IP address format). By default, each AWS account can create up to 100 buckets, expandable to 1,000.

- **Object Metadata**: Objects in S3 include key (unique identifier), version ID, value (data content), metadata (system or user-defined), and access control information. Metadata can only be set at upload and cannot be modified post-upload without creating a new object version.

- **Object Tagging**: Tags are key-value pairs that help categorize and manage storage. Object tags can control access, lifecycle policies, and CloudWatch metrics, supporting up to 10 tags per object.

- **Cross-Region Replication (CRR) & Same-Region Replication (SRR)**: CRR replicates objects between buckets in different AWS regions for data redundancy and compliance. SRR replicates objects within the same region for use cases like log aggregation or maintaining copies for compliance.

- **S3 Static Website Hosting**: S3 can host static websites with content that doesn’t change frequently, unlike dynamic websites. The service offers options to configure domain settings, error handling, and redirects.

- **Bucket Lifecycle Management**: S3 allows for versioning and lifecycle policies to manage objects over time, balancing between storage cost and data retention needs.

- **Access Control**: S3 supports resource-based (e.g., bucket policies, ACLs) and user-based access controls, ensuring fine-grained control over who can access specific objects or buckets.

- **Region Considerations**: When creating a bucket, selecting a region close to your users minimizes latency and meets regulatory requirements. S3’s globally viewable service simplifies management across different regions.

- **Naming Constraints**: Bucket names are unique across S3, DNS-compliant, between 3-63 characters, starting with a lowercase letter or number, and cannot resemble an IP address. Bucket names are vital for correct functionality, especially in static website hosting.


#### 3.1.3. Interfacing with Amazon S3

- **AWS Management Console:** 
  - Provides a simple web interface to interact with Amazon S3.
  - Allows for viewing, uploading, downloading data, and managing permissions without code.
  - Supports file uploads up to 160GB; larger files require AWS CLI, SDK, or REST API.

- **AWS CLI (Command Line Interface):**
  - Enables command-line interaction with S3, offering automation and scriptable access to S3 resources.
  - Useful for handling large files and automating bulk operations.

- **AWS SDK (Software Development Kit):**
  - Allows programmatic interaction with S3 using popular programming languages.
  - Ideal for integrating S3 functionality into applications, providing flexibility and customization.

- **REST API:**
  - A direct HTTP interface to interact with S3, allowing standard HTTP requests to create, fetch, and delete buckets and objects.
  - Offers two addressing models: Path-style URLs (deprecated as of September 2020) and Virtual hosted-style URLs.

- **Path-style URLs:**
  - Format: `https://region-specific-endpoint/bucket/object`.
  - Deprecated for new buckets, but existing ones are still supported.

- **Virtual hosted-style URLs:**
  - Format: `https://bucketname.s3.amazonaws.com/object`.
  - More user-friendly and customizable; allows use of custom domain names.

- **DNS Request Handling:**
  - S3 uses DNS to route requests to appropriate facilities, ensuring high availability.
  - Temporary redirects may occur due to DNS propagation delays, especially right after bucket creation.

- **Temporary DNS Redirects:**
  - Occur when a request is routed to the wrong region; S3 responds with an HTTP 302 redirect to the correct endpoint.
  - Ensures that requests are eventually routed to the correct location.


#### 3.1.4. Amazon S3 Data Management



- **Data Consistency Model**
  - Amazon S3 now offers strong read-after-write consistency for all operations.
  - This ensures that after a write operation, any subsequent read request immediately returns the latest version of the object.
  - Consistency is provided for GET, PUT, LIST, HEAD requests, and metadata operations. Bucket operations remain eventually consistent.

- **AWS Management Console**
  - Provides a graphical interface for managing buckets and objects.
  - Allows for versioning, access logs, permissions, and encryption management.
  - Supports secure login with AWS credentials and multi-factor authentication.
  - Features personalization options and supports major web browsers and a mobile app.

- **File Upload Limits**
  - The AWS Management Console allows uploads of files up to **160 GB**.
  - Larger files require programmatic uploads via CLI or application code.

- **Versioning**
  - Keeps multiple versions of objects in a bucket, allowing for easy recovery from deletions or overwrites.
  - Objects receive unique version IDs, enabling retrieval of previous versions.

- **Command Line Interface (CLI)**
  - **High-Level Commands:** Simplify management tasks and are prefixed with `aws s3`.
    - Examples: Creating buckets, copying files, listing buckets and objects.
  - **Low-Level Commands:** Provide detailed control over S3 APIs and are prefixed with `aws s3api`.

- **PUT Operations**
  - Used to add objects to a bucket.
  - Overwrites existing objects if they already exist.
  - Supports multipart uploads for large files (over 5 GB), improving throughput and reliability.

- **Multipart Upload API**
  - Allows uploading large objects in parts.
  - Improves upload performance and fault tolerance.
  - Supports pausing, resuming, and managing uploads.

- **Object Lifecycle Management**
  - Use lifecycle rules to automate cleanup of incomplete multipart uploads and manage storage costs.
  - Recommended to enable lifecycle rules even if multipart uploads are not planned.

- **GET Operations**
  - Retrieve entire objects or specific byte ranges.
  - Useful for handling large files or poor network conditions.

- **Delete Operations**
  - **Non-Versioning Buckets:** Objects are permanently deleted.
  - **Versioning-Enabled Buckets:** Deletes create a delete marker or can remove specific versions. Deleted objects can be recovered by removing the delete marker.


#### 3.1.5. AWS Cloud Data Migration Services


- **AWS DataSync**: Facilitates fast, secure, and efficient transfer of large volumes of data between on-premises storage and Amazon S3, handling tasks such as encryption, network optimization, and data integrity validation. Can transfer hundreds of terabytes and millions of files at speeds up to 10 times faster than open-source tools. [Learn more](https://aws.amazon.com/datasync/?whats-new-cards.sort-by=item.additionalFields.postDateTime&whats-new-cards.sort-order=desc)

- **AWS Transfer Family**: Provides fully managed support for file transfers to and from Amazon S3, integrating with existing authentication systems and DNS routing via Amazon Route 53. Enables seamless migration and continued use of data with AWS services. [Learn more](https://aws.amazon.com/aws-transfer-family/?whats-new-cards.sort-by=item.additionalFields.postDateTime&whats-new-cards.sort-order=desc)

- **Amazon S3 Transfer Acceleration**: Accelerates file transfers over long distances by leveraging Amazon CloudFront’s globally distributed edge locations, optimizing network paths for faster data transfers to Amazon S3. Ideal for regular large data transfers across continents. [Learn more](https://aws.amazon.com/s3/transfer-acceleration/)

- **Amazon Kinesis Data Firehose**: A fully managed service for streaming data into Amazon S3 and Amazon Redshift, providing near-real-time analytics and integration with existing business intelligence tools. [Learn more](https://aws.amazon.com/kinesis/data-firehose/?kinesis-blogs.sort-by=item.additionalFields.createdDate&kinesis-blogs.sort-order=desc)

- **Amazon Kinesis Data Streams**: Enables the capture and storage of terabytes of streaming data per hour from various sources like clickstreams, transactions, and logs. Supports integration with AWS services for further processing and analytics. [Learn more](https://aws.amazon.com/kinesis/data-streams/)

- **Amazon Partner Network**: Offers third-party connectors for additional support with data transfers. Partners can help move data to the cloud, often integrating with backup software to maintain consistency and control across various storage media. [Learn more](https://aws.amazon.com/partners/)

These services cover a range of needs from high-speed transfers, real-time data streaming, to integration with existing systems and tools.



**Offline Data Transfer Services**

- **AWS Snowcone**
  - Smallest member of the Snow Family, weighing 4.5 pounds.
  - Provides 8 terabytes of usable storage.
  - Designed for data migration needs up to dozens of terabytes.
  - Suitable for space-constrained environments.
  - Supports edge computing and data transfer.
  - Uses multiple layers of security and encryption.
  - [More Info](https://aws.amazon.com/snowcone/)

- **AWS Snowball**
  - Available in two models: Snowball Edge Storage Optimized and Snowball Edge Compute Optimized.
  - Storage Optimized: 40 vCPUs, block storage, and S3-compatible object storage.
  - Compute Optimized: 52 vCPUs, block and object storage, optional GPU.
  - Used for data collection, machine learning, and storage in remote or disconnected environments.
  - Can be rack-mounted and clustered.
  - [More Info](https://aws.amazon.com/snowball/)

- **AWS Snowmobile**
  - Exabyte-scale data transfer service.
  - Capable of transferring up to 100PB of data per Snowmobile.
  - 45-foot long container pulled by a semi-trailer truck.
  - Features high security with GPS tracking, video surveillance, and 256-bit encryption.
  - [More Info](https://aws.amazon.com/snowmobile/)

##### Hybrid Cloud Storage Services
- **AWS Direct Connect**
  - Provides a dedicated network connection from your on-premises data center to AWS.
  - Ensures higher throughput and secure data transfer without using the internet.
  - Supports multiple virtual interfaces via industry-standard VLANs.
  - [More Info](https://aws.amazon.com/directconnect/)

- **AWS Storage Gateway**
  - Can be deployed as a virtual appliance or a hardware appliance.
  - File Gateway mode allows connection to Amazon S3 using NFS or SMB protocols.
  - Supports local caching and data transfer over the internet or AWS Direct Connect.
  - [More Info](https://aws.amazon.com/storagegateway/?whats-new-cards.sort-by=item.additionalFields.postDateTime&whats-new-cards.sort-order=desc)

**Unmanaged Cloud Data Migration Tools**

- **rsync and 3rd Party Tools**
  - Open-source tools like rsync can be used to copy data directly into Amazon S3 buckets.
  
- **Amazon S3 and AWS CLI**
  - Allows writing commands and scripts to move data into Amazon S3 buckets directly.

These services and tools provide a range of options depending on data volume, transfer speed, and connectivity needs.

#### 3.1.6. Securing Data Access in AWS S3

- **Default Privacy**: By default, all Amazon S3 resources are private. Access is restricted to the resource owner or account administrator.

- **Principle of Least Privilege**: 
  - Start with the minimum necessary permissions.
  - Grant additional permissions only when required.
  - This approach is more secure than starting with open permissions and then tightening them later.

- **Security Mechanisms**:
  - **AWS Identity and Access Management (IAM)**: Manage user access to S3 resources.
  - **Bucket Policies**: Configure permissions for buckets and objects, often replacing legacy ACLs.
  - **Pre-Signed URLs**: Grant time-limited access to objects.
  - **Access Control Lists (ACLs)**: Legacy mechanism for object-level permissions.

- **Block Public Access**:
  - **Block All Public Access**: Prevents public access to buckets and objects.
  - **Block Public Access Granted Through New ACLs**: Prevents new ACLs from granting public access.
  - **Block Public Access Granted Through Any ACLs**: Ignores existing ACLs that grant public access.
  - **Block Public Access Granted Through New Public Bucket Policies**: Prevents new public bucket policies.
  - **Block Public and Cross-Account Access Granted Through Any Public Bucket Policies**: Restricts public and cross-account access.

- **Access Policies**:
  - **Bucket Policies**: Resource-based policies that grant access to specific users or accounts.
  - **IAM Policies**: User-based policies that manage access within your account.
  - Use bucket policies for cross-account permissions or when IAM policies are too complex.

- **Presigned URLs**:
  - Provide temporary access to objects without requiring AWS credentials.
  - Valid for a limited period, specified during URL creation.
  - Useful for sharing private objects or allowing temporary uploads.

- **Amazon S3 Object Ownership**:
  - **New Feature**: Allows the bucket owner to own all objects written to their bucket, regardless of the uploader.

- **Best Practices**:
  - Enable Block Public Access settings to avoid unintended data exposure.
  - Use IAM and bucket policies to manage permissions efficiently and securely.
  - Consider presigned URLs for temporary access needs.
  - Review and update ACLs and policies regularly to ensure proper access control.


#### 3.1.7. Encrypting Data in AWS

1. **Data Protection Overview**
   - Protects data in-transit (traveling to/from Amazon S3) and at-rest (stored on disks in Amazon S3 data centers).
   - Data in-transit can be protected using SSL/TLS or client-side encryption.
   - AWS API supports SSL/TLS connections by default for official SDKs and CLI tools.

2. **Data Protection Methods**
   - **In-Transit:** Use SSL/TLS for confidentiality and integrity.
   - **At-Rest:** Utilize server-side or client-side encryption.

3. **Server-Side Encryption (SSE)**
   - **Purpose:** Encrypts data before saving to disk and decrypts when downloading.
   - **Access:** No difference in access whether the data is encrypted or unencrypted.
   - **Presigned URLs:** Work the same for both encrypted and unencrypted objects.
   - **Object Listing:** Lists all objects regardless of their encryption status.

4. **Types of Server-Side Encryption**
   - **SSE-S3:** Encrypts each object with a unique key and uses AES-256 for encryption. The key is encrypted with a regularly rotated master key.
   - **SSE-KMS:** Allows management of encryption keys using AWS Key Management Service.
   - **SSE-C:** You manage the encryption keys and Amazon S3 uses them to encrypt/decrypt the data.

5. **Client-Side Encryption**
   - **Purpose:** Encrypts data before sending it to Amazon S3, ensuring data remains encrypted outside your environment.
   - **Key Management:** You retain possession of master encryption keys, which are never sent to AWS.
   - **Key Storage:** Essential to securely store master keys, as losing them means losing access to decrypted data.

6. **Client-Side Encryption Options**
   - **AWS KMS:** Use a customer master key (CMK) from AWS Key Management Service for encryption.
   - **Application-Managed Key:** Provide a master key stored within your application to encrypt data encryption keys generated randomly.


#### 3.1.8. Amazon S3 Service Integration

- **Data Storage Challenges**: Traditional on-premises data storage and management solutions struggle to keep pace with growing data volumes, leading to inefficient data consolidation and limited analytics capabilities.
- **Amazon S3 for Data Lakes**: Amazon S3 is an ideal foundation for data lakes due to its virtually unlimited scalability and high durability (99.999999999%). It supports centralized data storage, making it easier to perform comprehensive analytics and machine learning.
- **Decoupling Storage and Compute**: Unlike traditional solutions where storage and compute are tightly coupled, Amazon S3 allows for cost-effective storage of data in native formats while using Amazon EC2 for flexible compute resources, optimizing performance and costs.
- **Centralized Data Architecture**: Amazon S3 facilitates a multi-tenant environment where various users can access a common data repository with improved cost efficiency and data governance compared to traditional methods.
- **Integration with AWS Services**: S3 integrates with AWS analytics services like Amazon Athena, Redshift Spectrum, and AWS Glue, enabling seamless data querying, processing, and transformation without managing server infrastructure.
- **Standardized APIs**: Amazon S3 REST APIs are widely supported by third-party ISVs, including Apache Hadoop and other analytics tools, enabling users to leverage familiar tools for data analytics.
- **Data Cataloging**: Essential for managing data lakes, a data catalog tracks raw assets and transformations within S3 buckets. AWS services like Lambda, DynamoDB, and Elasticsearch Service can be used to create and manage the data catalog.
- **In-Place Data Querying**: Amazon Athena and Redshift Spectrum enable querying and analyzing data directly in S3 without moving it to separate platforms, making data analysis more accessible and cost-effective.
- **Amazon Athena**: Provides interactive SQL querying directly on data in S3, is serverless, and integrates with Amazon QuickSight for visualization and third-party BI tools.
- **Amazon Redshift Spectrum**: Allows running SQL queries on data in S3 using Redshift, optimizing for large datasets and complex queries, and supports a wide range of data formats.
- **Amazon FSx for Lustre Integration**: Amazon FSx for Lustre can link with S3 buckets, providing high-performance file system capabilities for compute-intensive workloads and enabling efficient data processing with sub-millisecond latencies.

## 3.2. EBS

### 3.2.1. What is Block Storage?

- **Primary Storage Types**: There are three main types of storage: block, file, and object. Each has unique features and implementations.
  
- **Block Storage Overview**: Block storage involves raw storage presented as disks or volumes, formatted into fixed-size segments called blocks. These blocks store data and are managed by an operating system or application.

- **Storage Devices**: Block storage can use various devices including HDDs, SSDs, and NVMe. It can also be deployed on SAN systems.

- **File Storage**: Built on top of block storage, file storage manages data as files in a hierarchical directory. Common protocols include SMB and NFS.

- **Object Storage**: Also built on block storage, object storage manages data as binary objects with metadata. It is known for its scalability and availability.

- **Block Storage Architecture**: Consists of block storage, a compute system, and an operating system. The OS or application formats and manages the block storage.

- **Block Size**: Block storage can be formatted with varying block sizes to suit different application needs. This flexibility is a key feature.

- **Metadata Management**: Metadata includes information about data creation, modification, access times, and permissions. It helps manage and track data.

- **Read-Write Activity**: Managed by the OS, it includes data access control, caching, and write operations. OS manages permissions and data integrity.

- **Locking Control**: Ensures data integrity during modifications by applying file-level or block-level locks to prevent conflicts.

- **Block Storage Volumes**: Can be a single device or multiple combined devices. Volumes are logical storage units created from physical drives.

- **Performance**: Block storage offers high performance with low latency, high IOPS, and throughput. SSDs provide fast operations, while HDDs are better for sequential read/write tasks.


### 3.2.2. Amazon EBS Overview

- **Amazon EBS Overview**:
  - Amazon EBS (Elastic Block Store) is a high-performance, block storage service used with Amazon EC2 instances.
  - EBS is ideal for data that requires high accessibility and long-term persistence.
  - Suited for file systems, databases, and applications needing granular updates and raw block-level storage.
  - Supports both random read/write (e.g., databases) and throughput-intensive (e.g., Hadoop) applications.
  - EBS volumes act like raw block devices, which can be mounted to EC2 instances and persist independently of instance life.
  - Provides six volume types to optimize price and performance, with options for low-latency and high-throughput needs.
  - Volumes can be resized, type-changed, and performance-tuned dynamically without affecting applications.
  - EBS volumes are replicated within an AWS Availability Zone and can scale to petabytes of data.
  - Snapshots of EBS volumes can be automatically managed and stored in Amazon S3 for backup and geographic data protection.
  - Pay-as-you-go model: costs are based on the storage and resources provisioned.
  - AWS block storage portfolio includes instance storage, Amazon EBS, and snapshot services.
  - **Instance Storage**: Temporary, directly associated with EC2 instances, non-persistent, terminated with instance.
  - **Snapshots**: Incremental, point-in-time copies of data on EBS volumes, used for restoration, expansion, and cross-AZ movement.




### 3.2.3. Amazon EBS Features and Benefits

1. **Persistent Storage**
   - EBS volumes are durable and persist independently of EC2 instances. Data remains even if an instance is terminated or stopped.
   - Volumes can be detached and reattached to different instances, allowing for flexible instance type changes and cost optimization.

2. **Built-in Encryption**
   - Seamless encryption of data at-rest (volumes, boot volumes, snapshots) with AWS managed or custom keys.
   - Encryption in-transit is provided as data moves between EC2 instances and EBS volumes, ensuring data security.

3. **High Availability and Durability**
   - Data is replicated across multiple servers in an Availability Zone to prevent data loss.
   - io2 volumes offer 99.999% durability, suitable for business-critical applications, with other volumes providing 99.8-99.9% durability.

4. **Multiple Volume Type Options**
   - **SSD-backed Storage**: General Purpose (gp3, gp2) for balanced price and performance; Provisioned IOPS (io2, io1) for high-performance applications.
   - **HDD-backed Storage**: Throughput Optimized (st1) for intensive workloads; Cold HDD (sc1) for infrequent access at lower cost.

5. **Elastic Volumes**
   - Allows dynamic adjustments to volume capacity, performance, and type without downtime.
   - Integrates with Amazon CloudWatch and AWS Lambda for automated scaling based on application needs.

6. **Multi-Attach**
   - Enables a single EBS volume to be attached to up to 16 Nitro-based EC2 instances in the same Availability Zone.
   - Facilitates higher availability for applications needing multiple writers, with each instance having full read/write permissions.

7. **Volume Monitoring**
   - Performance metrics such as bandwidth, throughput, and latency are available through AWS Management Console and CloudWatch.
   - Helps in ensuring adequate performance and managing costs effectively.

8. **Snapshots**
   - Point-in-time backups stored incrementally in Amazon S3. Only changed blocks since the last snapshot are saved, optimizing storage costs.
   - Snapshots support volume resizing, replication across Availability Zones, and sharing across AWS Regions.

9. **Backups with AWS Backup**
   - Centralized and automated data protection service for EBS volumes and other AWS resources.
   - Supports policy-based management and compliance with regulatory requirements, integrating with AWS Organizations for centralized backup management.


### 3.2.4. EBS Use Cases

- **Enterprise Applications**: 
  - Amazon EBS offers high availability, durability, and performance for critical applications like Oracle, SAP, Microsoft Exchange, and VMware on AWS.
  - Provides low latency, consistent IOPS, and scalability, making it ideal for mission-critical workloads.
  - High durability with an annual failure rate of 0.1-0.2%, significantly lower than on-premises systems.

- **Lift and Shift Migrations**: 
  - AWS supports seamless cloud migration with minimal changes using tools like AWS Application Migration Service and AWS Server Migration Service.
  - This method allows rapid deployment to the cloud, enabling further modernization post-migration.

- **Relational Databases**: 
  - EBS supports a variety of relational databases such as SAP HANA, Oracle, and MySQL with scalable performance.
  - Multiple migration options: refactor to Amazon Aurora, replatform on Amazon RDS, or lift and shift to EC2 and EBS for full control.

- **NoSQL Databases**: 
  - EBS provides low-latency, consistent performance for NoSQL databases like Cassandra, MongoDB, and CouchDB.
  - Options include using fully managed Amazon DynamoDB or self-managed databases on EC2 instances with EBS.

- **Big Data Analytics**: 
  - EBS supports dynamic scaling and persistent storage for big data solutions like Hadoop and Spark.
  - AWS offers managed services such as Amazon EMR and Amazon MSK, or you can host your own big data frameworks on EC2 and EBS.

- **File Systems and Media Workflows**: 
  - EBS supports scalable, high-performance storage for various file systems, including Amazon EFS and FSx for Lustre.
  - Suitable for media workflows, allowing integration with EC2 instances and EBS volumes for custom network file systems.

- **Business Continuity**: 
  - EBS facilitates robust backup strategies with AWS Backup and EBS Snapshots, ensuring high data durability and quick recovery across regions.
  - CloudEndure Disaster Recovery minimizes downtime and data loss with near-instant recovery capabilities.

- **Customer Success Stories**: 
  - **Slack**: Utilizes Amazon EC2 and EBS for rapid scaling, reducing capacity adjustment time from weeks to seconds.
  - **Zendesk**: Achieved over 60% cost savings by managing their logging solution with multiple EBS volume types.


### 3.2.5. Amazon EBS Volume Types

- **Amazon EBS Availability and Durability**: EBS volumes are highly available and reliable, with automatic replication within the same Availability Zone to prevent data loss from hardware failures.

- **AFR (Annual Failure Rate)**: EBS volumes have an AFR of 0.1-0.2%, making them 20 times more reliable than typical disk drives (2-4% AFR).

- **Snapshots**: Frequent snapshots increase data durability. Snapshots are incremental, capturing only changed data, and can be used to recreate volumes across Availability Zones and Regions.

- **Instance Stores**: Unlike EBS, instance stores are ephemeral, persisting only during the EC2 instance's lifetime. They are ideal for temporary data like caches, buffers, or replicated data across instances.

- **IOPS (Input/Output Operations Per Second)**: IOPS measures the speed of I/O operations. SSD volumes handle small/random I/O efficiently, while HDD volumes perform better with large/sequential I/O.

- **Throughput**: Throughput refers to the volume of data transferred. SSD volumes may hit throughput limits with large I/O, while HDD volumes perform better with sequential I/O.

- **Burst Balance**: Some EBS volumes allow performance bursts above baseline limits. Burst credits accumulate during low usage and are consumed during high-demand periods.

- **Latency**: Latency is the round-trip time for an I/O operation. SSD-backed volumes typically offer sub-1ms to single-digit ms latency, while HDD-backed volumes have higher latency, depending on workload.

- **Queue Length**: The number of pending I/O requests affects latency. Optimal queue length varies by workload and is crucial for maintaining desired performance.

- **Performance Metrics**: Amazon CloudWatch provides metrics to monitor EBS volume performance, including IOPS, throughput, latency, and queue length.


### 3.2.6. Amazon EBS Volume Types

- **Amazon EBS Volume Types**: EBS offers five volume types—General Purpose SSD (gp2, gp3), Provisioned IOPS SSD (io1, io2), Throughput Optimized HDD (st1), Cold HDD (sc1), and Magnetic.
- **General Purpose SSD (gp2)**: Provides a balance of price and performance with scalable IOPS based on volume size, ranging from 100 to 16,000 IOPS. It uses I/O credits for burst performance, ideal for a broad range of workloads.
- **General Purpose SSD (gp3)**: Offers consistent baseline performance of 3,000 IOPS and 125 MB/s throughput, with the ability to scale IOPS and throughput independently of volume size, supporting up to 16,000 IOPS and 1,000 MB/s.
- **Provisioned IOPS SSD (io1, io2)**: Designed for mission-critical workloads with high performance and low latency. io2 volumes provide higher durability (99.999%) and support up to 64,000 IOPS.
- **Throughput Optimized HDD (st1)**: Optimized for large, sequential I/O operations with scalable throughput based on volume size, ideal for workloads like data warehouses and log processing. It supports burst throughput up to 500 MB/s.
- **Cold HDD (sc1)**: Designed for infrequently accessed data with the lowest cost per GB. It offers baseline throughput and burst capabilities up to 250 MB/s, making it suitable for cold storage needs.
- **Magnetic Volumes**: Legacy volume type, still available but not recommended for new workloads. AWS suggests using gp3 SSD volumes for better performance and consistency.
- **Volume Sizing and Performance**: Volume size impacts baseline and burst performance. Larger volumes provide higher baseline IOPS/throughput and accumulate burst credits faster.
- **Multi-Attach and Availability Zones**: Some volumes can be attached to multiple instances simultaneously, but both the volume and instances must reside in the same Availability Zone.
- **Flat-Rate and Tiered Pricing**: gp2 and Magnetic volumes have flat-rate pricing, while gp3, io1, io2, st1, and sc1 volumes have tiered pricing based on performance provisioned.
- **Instance Compatibility**: Provisioned IOPS volumes (io1, io2) are compatible with all EC2 instances, with enhanced performance on instances built on the Nitro System.
- **Use Cases**: Choose the appropriate EBS volume type based on workload requirements, balancing cost, performance, and durability.


### 3.2.7. Choosing the Correct Amazon EBS Volume Type

- **Understand Workload Characteristics**:
  - Evaluate your workload's characteristics (IOPS-intensive, throughput-intensive, latency sensitivity) to select the appropriate EBS volume type.
  
- **Existing On-Premises Workloads**:
  - Gather detailed storage configuration information (number of volumes, storage media, volume sizes).
  - Analyze volume performance statistics (IOPS, throughput, utilization) to understand current performance requirements.
  - Assess current and future workload utilization to plan for growth and client access.

- **New AWS Cloud Native Workloads**:
  - Create test/dev environments to evaluate performance requirements of different EBS volume types.
  - Use similar workloads as benchmarks for your new workloads.
  - Plan based on expected demand, client numbers, and the nature of the underlying application or database.

- **Flexible EBS Volume Management**:
  - Utilize EBS Elastic Volumes to change volume type, increase size, and modify performance characteristics dynamically.
  - For `gp3` and `io2` volumes, adjust provisioned IOPS or throughput performance settings as needed.

- **Optimize for Price vs. Performance**:
  - Compare EBS volume types based on cost-effectiveness and performance characteristics.
  - Consider trade-offs between price and additional performance features that align with workload requirements.

- **AWS Compute Optimizer**:
  - Use AWS Compute Optimizer to monitor and optimize EBS volumes for cost and performance after they are operational.
  - The service provides recommendations based on the analysis of utilization metrics and resource configurations.

- **Utilize Compute Optimizer Features**:
  - Access graphs showing recent and projected utilization metrics to make informed decisions on resizing or moving resources.
  - Opt-in for Compute Optimizer to analyze your AWS resources, including EC2 instances, Auto Scaling groups, EBS volumes, and Lambda functions.
  - Review optimization findings via the Compute Optimizer dashboard to ensure your resources meet performance and capacity needs.



### 3.2.8. EBS Snapshots

- **Amazon EBS Snapshots**: Create backup copies of your EBS volumes, stored in Amazon S3 with eleven 9's of durability, ensuring Regional access and availability.

- **Incremental Snapshots**: Only store the blocks that have changed since the last snapshot, reducing storage costs and creation time. Each snapshot can fully restore your data to a new EBS volume.

- **Snapshot Deletion**: When a snapshot is deleted, only the unique data to that snapshot is removed; data required by other snapshots remains intact.

- **Cross-Region Copy & Sharing**: Snapshots can be copied across AWS Regions for disaster recovery or geographical expansion. Snapshots can also be shared across AWS accounts by modifying access permissions.

- **Encryption Support**: Snapshots of encrypted volumes are automatically encrypted, and volumes created from these snapshots inherit the encryption. You can also encrypt snapshots during the copy process or re-encrypt with a different key.

- **Amazon Data Lifecycle Manager (DLM)**: Automates the creation, retention, and deletion of EBS snapshots and EBS-backed AMIs using lifecycle policies, schedules, and resource tags.

- **Lifecycle Policies**: DLM supports snapshot lifecycle policies for automating EBS snapshot management and AMI lifecycle policies for managing EBS-backed AMIs. Policies can target volumes or instances and automate tasks based on defined schedules and retention rules.

- **Policy Schedules**: Policies can have up to four schedules to manage snapshot or AMI creation frequencies, including daily, weekly, monthly, and yearly backups, with custom tags and retention settings.

- **Multi-Volume Snapshots**: EBS Snapshots support crash-consistent backups across multiple EBS volumes attached to an EC2 instance, ensuring data-coordinated snapshots at a specific point in time.

- **Snapshot Events & Monitoring**: EBS Snapshot events (creation, copying, sharing) are tracked using CloudWatch, allowing for better monitoring and management.

- **Snapshot Quotas**: You can create up to 100 lifecycle policies per AWS Region, with each resource (e.g., EBS volume, AMI) supporting up to 45 tags.



### 3.2.9. Amazon EBS Pricing

- **Pay-As-You-Use**: Amazon EBS charges based on provisioned volume size, IOPS, and throughput. Pricing varies by volume type and Availability Zone.

- **Provisioned Volume Size**: Costs are calculated based on the volume size provisioned. For example, a 100 GB volume provisioned for 30 days would be charged based on the rate per GB-month.

- **Provisioned IOPS**: Charges apply for IOPS provisioned above the baseline. For example, gp3 volumes include 3,000 IOPS for free; additional IOPS are billed separately.

- **Provisioned Throughput**: Costs are calculated for throughput provisioned above the baseline. For gp3 volumes, 125 MB/s is included, with extra throughput billed separately.

- **Cost Calculation by Time Unit**: Rates can be calculated per day, hour, minute, or second using appropriate formulas, adjusting for usage periods shorter than a full month.

- **SSD-backed EBS Volumes**: Includes gp2, gp3, io1, and io2 types. Charges differ by type, with gp2 including I/O in the price, and gp3 offering customizable IOPS and throughput.

- **HDD-backed EBS Volumes**: Includes st1 and sc1 types. Charges are based solely on provisioned storage, with no separate IOPS or throughput charges.

- **Elastic Volumes**: Volume sizes can be increased within the same volume, but decreasing size requires copying data to a new, smaller EBS volume.

- **Region-Specific Pricing**: Prices vary by AWS Region, and all examples are based on the US East (N. Virginia) region as of March 2021.

- **Billing Increments**: Charges for provisioned storage, IOPS, and throughput are billed in per-second increments, with a minimum of 60 seconds.

- **Snapshot Pricing**: Snapshot costs are based on the actual storage space used, not the provisioned size.



### 3.2.10. Pricing exercise

You need to provide budgeting for a new application. For this application, you have determined that you need one General Purpose SSD gp3 volume and one Throughput Optimized HDD st1 volume. The application is intended for long-term use.

gp3 volume requirements include 3,000 IOPS of sustained performance, 75 GB of volume space, and daily snapshots. Your daily rate of change is 1 GB.

st1 volume requirements include 40 MB/s of sustained throughput, 500 GB of volume space, and hourly snapshots. The calculated volume size to meet the sustained performance requirements is 1 TB. Your hourly rate of change is 1 GB.

Pricing is compared based on a full month of use. You use the default Average duration for each instance as 730 hours per month.

What is the total cost estimate for the new application?


| **Scenario**                              | **Calculation**                                                                 | **Formula**                                                                                     | **Result**        |
|-------------------------------------------|---------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|-------------------|
| **New Application Budget Estimate**       | **Estimated gp3 Volume Costs**                                                  |                                                                                                 | **$10.50**        |
|                                           | Total Instance Hours                                                            | 1 instance x 730 instance hours                                                                  | 730.00 hours      |
|                                           | Instance Months                                                                 | 730.00 hours / 730 hours per month                                                               | 1.00 month        |
|                                           | EBS Storage Cost                                                                | 75 GB x 1.00 instance months x $0.08 USD                                                         | $6.00             |
|                                           | Billable gp3 IOPS                                                               | 3000 IOPS - 3000 GP3 IOPS free                                                                   | $0.00             |
|                                           | Billable MBps                                                                   | 125 MBps - 125 GP3 MBps free                                                                     | $0.00             |
|                                           | Initial Snapshot Cost                                                           | 75 GB x $0.0500000000 USD                                                                        | $3.75             |
|                                           | Incremental Snapshot Cost (per snapshot)                                        | (1 GB x $0.0500000000 USD x 50% discount) x 30 snapshots                                         | $0.75             |
|                                           | Total Snapshot Cost                                                             | $3.75 + $0.75                                                                                    | $4.50             |
|                                           | **Total gp3 Cost**                                                              | $6.00 + $4.50                                                                                    | **$10.50**        |
| **Estimated st1 Volume Costs**            |                                                                                 |                                                                                                 | **$115.50**       |
|                                           | Total Instance Hours                                                            | 1 instance x 730 instance hours                                                                  | 730.00 hours      |
|                                           | Instance Months                                                                 | 730.00 hours / 730 hours per month                                                               | 1.00 month        |
|                                           | EBS Storage Cost                                                                | 1024 GB x 1.00 instance months x $0.045 USD                                                      | $46.08            |
|                                           | Initial Snapshot Cost                                                           | 1024 GB x $0.0500000000 USD                                                                      | $51.20            |
|                                           | Incremental Snapshot Cost (per snapshot)                                        | (1 GB x $0.0500000000 USD x 50% discount) x 729 snapshots                                        | $18.23            |
|                                           | Total Snapshot Cost                                                             | $51.20 + $18.23                                                                                  | $69.42            |
|                                           | **Total st1 Cost**                                                              | $46.08 + $69.42                                                                                  | **$115.50**       |
| **Total New Application Estimate**        |                                                                                 |                                                                                                 | **$126.00**       |
|                                           |                                                                                 |                                                                                                 |                   |
| **gp2 vs. gp3 Volume Types**              | **Estimated gp2 Volume Costs**                                                  |                                                                                                 | **$50.85**        |
|                                           | Total Instance Hours                                                            | 1 instance x 730 instance hours                                                                  | 730.00 hours      |
|                                           | Instance Months                                                                 | 730.00 hours / 730 hours per month                                                               | 1.00 month        |
|                                           | EBS Storage Cost                                                                | 334 GB x 1.00 instance months x $0.10 USD                                                        | $33.40            |
|                                           | Initial Snapshot Cost                                                           | 334 GB x $0.0500000000 USD                                                                       | $16.70            |
|                                           | Incremental Snapshot Cost (per snapshot)                                        | (1 GB x $0.0500000000 USD x 50% discount) x 30 snapshots                                         | $0.75             |
|                                           | Total Snapshot Cost                                                             | $16.70 + $0.75                                                                                   | $17.45            |
|                                           | **Total gp2 Cost**                                                              | $33.40 + $17.45                                                                                  | **$50.85**        |
| **Estimated gp3 Volume Costs**            |                                                                                 |                                                                                                 | **$20.25**        |
|                                           | Total Instance Hours                                                            | 1 instance x 730 instance hours                                                                  | 730.00 hours      |
|                                           | Instance Months                                                                 | 730.00 hours / 730 hours per month                                                               | 1.00 month        |
|                                           | EBS Storage Cost                                                                | 150 GB x 1.00 instance months x $0.08 USD                                                        | $12.00            |
|                                           | Initial Snapshot Cost                                                           | 150 GB x $0.0500000000 USD                                                                       | $7.50             |
|                                           | Incremental Snapshot Cost (per snapshot)                                        | (1 GB x $0.0500000000 USD x 50% discount) x 30 snapshots                                         | $0.75             |
|                                           | Total Snapshot Cost                                                             | $7.50 + $0.75                                                                                    | $8.25             |
|                                           | **Total gp3 Cost**                                                              | $12.00 + $8.25                                                                                   | **$20.25**        |
| **Estimated Increase/Decrease**           | Estimated Decrease Moving to gp3                                                | $50.85 (gp2 cost) - $20.25 (gp3 cost)                                                            | **-$30.60**       |
|                                           |                                                                                 |                                                                                                 |                   |
| **io1 vs. gp3 Volume Types**              | **Estimated io1 Volume Costs**                                                  |                                                                                                 | **$92.00**        |
|                                           | Total Instance Hours                                                            | 1 instance x 730 instance hours                                                                  | 730.00 hours      |
|                                           | Instance Months                                                                 | 730.00 hours / 730 hours per month                                                               | 1.00 month        |
|                                           | EBS Storage Cost                                                                | 150 GB x 1.00 instance months x $0.125 USD                                                       | $18.75            |
|                                           | IOPS Cost                                                                       | 1000 IOPS x 1.00 instance months x $0.065 USD                                                    | $65.00            |
|                                           | Initial Snapshot Cost                                                           | 150 GB x $0.0500000000 USD                                                                       | $7.50             |
|                                           | Incremental Snapshot Cost (per snapshot)                                        | (1 GB x $0.0500000000 USD x 50% discount) x 30 snapshots                                         | $0.75             |
|                                           | Total Snapshot Cost                                                             | $7.50 + $0.75                                                                                    | $8.25             |
|                                           | **Total io1 Cost**                                                              | $83.75 + $8.25                                                                                   | **$92.00**        |
| **Estimated gp3 Volume Costs**            |                                                                                 |                                                                                                 | **$20.25**        |
|                                           | Total Instance Hours                                                            | 1 instance x 730 instance hours                                                                  | 730.00 hours      |
|                                           | Instance Months                                                                 | 730.00 hours / 730 hours per month                                                               | 1.00 month        |
|                                           | EBS Storage Cost                                                                | 150 GB x 1.00 instance months x $0.08 USD                                                        | $12.00            |
|                                           | Initial Snapshot Cost                                                           | 150 GB x $0.0500000000 USD                                                                       | $7.50             |
|                                           | Incremental Snapshot Cost (per snapshot)                                        | (1 GB x $0.0500000000 USD x 50% discount) x 30 snapshots                                         | $0.75             |
|                                           | Total Snapshot Cost                                                             | $7.50 + $0.75                                                                                    | $8.25             |
|                                           | **Total gp3 Cost**                                                              | $12.00 + $8.25                                                                                   | **$20.25**        |
| **Estimated Increase/Decrease**           | Estimated Decrease Moving to gp3                                                | $92.00 (io1 cost) - $20.25 (gp3 cost)                                                            | **-$71.75**       |








##### 3.2.12.1 Data Security


1. **Amazon EBS Integration**:
   - Amazon EBS integrates with AWS Identity and Access Management (IAM) and AWS Key Management Service (KMS) to secure data access.

2. **IAM for Amazon EBS**:
   - IAM manages permissions for users, groups, and roles, controlling access to Amazon EBS and Amazon EC2 resources.
   - By default, IAM identities do not have access to AWS resources. Permissions are granted through IAM policies.

3. **IAM Policies**:
   - Standalone IAM policies, managed by AWS, cater to common use cases, simplifying permissions management.
   - Custom IAM policies can be created to restrict access and management capabilities for EBS volumes.

4. **AWS Key Management Service (KMS)**:
   - KMS provides encryption for Amazon EBS, eliminating the need for a self-managed key infrastructure.
   - KMS uses customer-managed keys (CMK) or AWS-managed keys to encrypt volumes and snapshots.

5. **Amazon EBS Encryption**:
   - EBS encryption protects data at rest and in transit between EC2 instances and attached EBS storage.
   - Encryption is supported for both EBS boot and data volumes, with data secured using AES-256 algorithm.

6. **Data Security**:
   - Encrypted EBS volumes ensure that all data (at rest, in transit, snapshots) is protected.
   - The data key used for encryption is secured with a customer-managed key and is never stored in plaintext.

7. **Encryption Scope**:
   - Encrypted volumes automatically secure all associated snapshots and any new volumes created from those snapshots.

8. **Security Architecture**:
   - Encryption operations occur on the servers hosting EC2 instances, maintaining robust security for data interactions.



##### 3.2.12.2 AWS Backup

- **Centralized Data Protection**: AWS Backup allows you to centralize and automate data protection across various AWS services, simplifying backup management and meeting business continuity goals.

- **Integration with AWS Organizations**: You can deploy backup policies across multiple AWS accounts and resources within your organization using AWS Backup in conjunction with AWS Organizations.

- **Supported AWS Services**: AWS Backup supports a range of services including Amazon EC2 instances, Amazon EBS volumes, Amazon RDS databases (including Amazon Aurora), Amazon DynamoDB tables, Amazon EFS, Amazon FSx for Lustre and Windows File Server, and AWS Storage Gateway volumes.

- **Backup Storage**: AWS Backup stores backups in an AWS managed Amazon S3 bucket, ensuring secure and scalable backup storage.

- **Policy-Based Backup**: Create and manage backup policies (backup plans) to define and apply backup requirements tailored to business and regulatory needs.

- **Tag-Based Policies**: Apply backup plans to resources using tags, simplifying the implementation of backup strategies across various applications.

- **Automated Backup Scheduling**: Customize backup schedules to meet specific requirements or use predefined schedules. AWS Backup automates the backup process based on these schedules.

- **Retention Management**: Set automated backup retention policies to manage the lifespan of backups and reduce storage costs by retaining backups only as long as necessary.

- **Backup Monitoring**: Utilize the AWS Backup dashboard to monitor and audit backup and restore activities across services, ensuring that resources are protected.

- **Lifecycle Management**: Configure lifecycle policies to transition backups from warm storage to cold storage, balancing cost and compliance requirements.

- **Access Control**: Set resource-based access policies on Backup Vaults to manage and secure access to backups centrally.

- **Cross-Region Backup**: Copy backups to different AWS regions either manually or automatically, enhancing disaster recovery and compliance.

- **Cross-Account Backup**: Securely copy backups across AWS accounts within your organization, providing protection against disruptions in the source account and facilitating recovery.



#### 3.2.12.3 CloudEndure Disaster Recovery and AWS Application Migration Service

input

**CloudEndure Disaster Recovery:**
- **Minimizes Downtime and Data Loss**: Provides fast, reliable recovery for physical, virtual, and cloud-based servers into AWS.
- **Supports Various Environments**: Works with AWS public Regions, AWS GovCloud (US), and AWS Outposts.
- **Database and Application Protection**: Protects critical databases (Oracle, MySQL, SQL Server) and enterprise applications (e.g., SAP).
- **Continuous Replication**: Replicates machines (OS, system state, databases, applications, files) to a low-cost staging area in AWS.
- **Rapid Recovery**: Enables automatic launch of fully provisioned machines within minutes during a disaster.
- **Cost Efficiency**: Reduces disaster recovery infrastructure costs by using a low-cost staging area.
- **Architecture**: Involves source systems, staging EC2 instances and EBS volumes, production EC2 instances and EBS volumes, and failback processes.

**AWS Application Migration Service (AWS MGN):**

- **Automated Lift-and-Shift**: Simplifies and expedites the migration of applications to AWS Cloud with minimal compatibility issues and performance impact.
- **Continuous Replication**: Replicates source servers to AWS and automatically converts and launches them on AWS.
- **Quick Migration**: Facilitates fast migration without long cutover windows, enabling immediate benefits from AWS Cloud.
- **Post-Migration Flexibility**: Allows replatforming or refactoring of applications after migration to leverage AWS services.
- **Cost and Agility**: Provides cost savings, productivity, resilience, and agility by moving to the AWS Cloud without initial application modernization.




#### 3.2.12.4 Amazon CloudWatch

1. **CloudWatch Metrics Overview**:
   - CloudWatch metrics provide statistical data for analyzing and setting alarms on the operational behavior of EBS volumes.
   - Metrics are available in 1-minute intervals at no charge.

2. **Data Granularity**:
   - The `Period` request parameter determines the granularity of the data returned.
   - It's recommended to set the period equal to or greater than the data collection period (1 minute) for valid data.

3. **Data Access**:
   - Data can be accessed through the CloudWatch API or the Amazon EC2 console.
   - The API provides raw data, while the console displays graphs based on the data.

4. **Monitoring EBS Volumes**:
   - CloudWatch monitors EBS volume activity and stores metrics in the AWS Management Console for EC2.

5. **EBS Metrics**:
   - **VolumeReadBytes**: Bytes read in a specified period.
   - **VolumeWriteBytes**: Bytes written in a specified period.
   - **VolumeReadOps**: Total number of read operations.
   - **VolumeWriteOps**: Total number of write operations.
   - **VolumeTotalReadTime**: Total seconds spent on read operations.
   - **VolumeTotalWriteTime**: Total seconds spent on write operations.
   - **VolumeIdleTime**: Total seconds with no read or write operations.
   - **VolumeQueueLength**: Number of pending read and write requests.
   - **VolumeThroughputPercentage**: Percentage of IOPS delivered for Provisioned IOPS SSD volumes.
   - **VolumeConsumedReadWriteOps**: Total read and write operations consumed (for Provisioned IOPS SSD volumes).
   - **BurstBalance**: Percentage of I/O or throughput credits remaining (for gp2, st1, and sc1 volumes).

6. **Event Notifications**:
   - CloudWatch events for Amazon EBS include notifications for volume, snapshot, and encryption status changes.
   - Rules can be established to trigger actions such as AWS Lambda functions for snapshot management or disaster recovery.

7. **Volume Events**:
   - Events related to EBS volumes include: `createVolume`, `deleteVolume`, `attachVolume`, `reattachVolume`, and `modifyVolume`.

8. **Snapshot Events**:
   - Events related to EBS snapshots include: `createSnapshot`, `createSnapshots`, `copySnapshot`, and `shareSnapshot`.

9. **Multi-Attach Limitations**:
   - Some metrics (VolumeTotalReadTime, VolumeTotalWriteTime, VolumeIdleTime, VolumeThroughputPercentage) are not supported for volumes with Multi-Attach enabled.

10. **Provisioned IOPS SSD Volumes**:
    - Metrics like VolumeThroughputPercentage and VolumeConsumedReadWriteOps are specific to Provisioned IOPS SSD volumes.

11. **Credit-Based Volumes**:
    - BurstBalance metric is applicable to General Purpose SSD (gp2), Throughput Optimized HDD (st1), and Cold HDD (sc1) volumes.

12. **Documentation and Guides**:
    - For detailed information, refer to the Amazon CloudWatch metrics for Amazon EBS section in the Amazon Elastic Compute Cloud User Guide for Linux Instances.


## 3.2. AWS Database Offerings


### 3.2.1. Relational Databases

- **Relational Databases Overview**: Relational databases are ideal for structured data, relying on tables to store data in rows and columns, with relationships established through primary and foreign keys.
  
- **Tables and Relationships**: Data is organized in tables, where rows (records) represent instances of entities, and columns (fields) describe their attributes. Relationships between tables are created using primary and foreign keys.

- **Data Indexing**: Indexing is crucial for speeding up data retrieval in SQL queries, organizing data on disk based on key values, and enhancing query efficiency by reducing the need to scan entire tables.

- **OLTP vs. OLAP**: 
  - **OLTP (Online Transaction Processing)**: Focuses on quick, short transactions (e.g., bank ATMs), ideal for operations like Insert, Update, and Delete.
  - **OLAP (Online Analytical Processing)**: Handles complex queries on historical data for decision-making (e.g., business intelligence tools), suitable for analyzing large datasets.

- **AWS Relational Database Services**: AWS offers various relational database services to address scalability, performance, and storage durability challenges, allowing engineers to focus on features rather than maintenance.

- **Amazon RDS**: 
  - Supports disaster recovery and real-time data analytics by offloading heavy queries from the primary database to prevent latency.
  - Requires configuration of a Virtual Private Cloud (VPC) and security groups to ensure high availability and controlled access.

- **Amazon Aurora**: 
  - Designed for high availability with automatic failover across multiple Availability Zones.
  - Supports logging and analytics to monitor database health and user activities, enhancing operational efficiency.

- **VPC and Security Configurations**: 
  - Setting up a VPC and appropriate security groups is essential for both Amazon RDS and Aurora, ensuring isolated, secure environments for database instances.
  
- **Infrastructure Automation**: AWS services like RDS and Aurora automate routine administrative tasks, such as scaling and failover, reducing the overhead of managing on-premises databases.

- **Disaster Recovery**: Amazon RDS for Oracle is commonly used for mission-critical applications, requiring robust disaster recovery solutions to prevent data loss.

- **AWS Integration**: Both RDS and Aurora seamlessly integrate with other AWS services, providing scalable, secure, and cost-effective solutions for managing relational databases in the cloud.





### 3.2.2. Non-Relational Databases

- **Non-Relational Databases**: Often called NoSQL databases, they store semistructured and unstructured data. The term "NoSQL" should be understood as "not only SQL," meaning these databases can still be queried with SQL.
- **Database Comparison**:
  - **Relational Databases**: Use multiple tables with columns and rows, normalized data design, optimized for storage, use SQL for queries, and scale vertically.
  - **Non-Relational Databases**: Use collections of data in a single table with keys and values, denormalized data design (e.g., document, wide column, or key-value stores), optimized for compute, support multiple query languages, and scale horizontally.
- **Scalability and Consistency**: Non-relational databases are deployed on distributed commodity servers, offering massive scalability but with eventual consistency, which may not meet ACID compliance requirements.
- **Non-Relational Database Types**:
  - **Key-Value Databases**: Store data as key-value pairs, useful for simple retrievals.
  - **Document Databases**: Store data as documents, ideal for storing user profiles with varying attributes.
  - **In-Memory Databases**: Provide fast data retrieval, commonly used for caching.
  - **Graph Databases**: Store data as nodes and edges, suitable for complex relationships like social networks.
- **Graph Databases**: Excellent for querying hierarchical structures and making recommendations, but not ideal for transactional data and require learning new query languages.
- **AWS Solutions for Non-Relational Databases**:
  - **Amazon DynamoDB**: Ideal for applications requiring high scalability and performance, such as gaming websites with heavy loads or eCommerce apps needing real-time data processing.
  - **MongoDB Migration to AWS**: AWS offers managed services for migrating MongoDB databases to the cloud.
- **AWS Infrastructure for Non-Relational Databases**:
  - Use Amazon VPC for creating isolated network environments.
  - Configure IAM roles for secure access to DynamoDB from EC2 instances.
  - Utilize security groups to control access to resources.
- **Practical Use Cases**:
  - Deploy IoT architectures to handle data from thousands of sensors using DynamoDB.
  - Implement mobile backend architectures with real-time notifications using DynamoDB.



### 3.2.3. Database Migration


- **Migration Benefits**: Migrating databases to AWS offers fully managed, high-performance, and cost-effective database services, reducing the complexity, time, and cost associated with managing on-premises or cloud-based databases.

- **Common Use Cases**:
  - Migrating **MongoDB** to **Amazon DocumentDB**.
  - Migrating **Oracle** and **SQL Server** to **Amazon RDS** and **Amazon Aurora**.
  - Migrating **Cassandra** to **Amazon DynamoDB**.
  - Migrating **Terraform** to **Amazon Redshift**.

- **AWS Database Migration Service (AWS DMS)**:
  - **Efficient and Secure Migration**: Facilitates efficient and secure migration of databases to AWS with minimal downtime.
  - **Continuous Operation**: Source databases can remain fully operational during migration, minimizing application downtime.
  - **Replication Software**: AWS DMS runs replication software on an AWS Cloud instance to manage the migration.

- **Migration Strategies**:
  - **Homogeneous Migrations**: Migrating between the same database engines (e.g., Oracle to Oracle) may require using native database tools for schema and element migration.
  - **Heterogeneous Migrations**: Migrating between different database engines (e.g., Oracle to MySQL) involves using the **AWS Schema Conversion Tool (AWS SCT)** to translate the schema before using AWS DMS to migrate the data.

- **AWS DMS vs. AWS SCT**:
  - **AWS DMS**: Focuses on loading tables with data but does not handle foreign keys or constraints.
  - **AWS SCT**: Identifies issues in schema conversion, generates target schema scripts (including foreign keys and constraints), and converts code (like procedures and views) from the source to the target database.

- **AWS Migration Support**:
  - **AWS Professional Services**: Offers global expertise to assist with database migrations to AWS.
  - **AWS DMS Partners**: Partners help customers use AWS DMS to minimize downtime and securely migrate databases.
  - **AWS Migration Acceleration Program**: Provides consulting, training, and service credits to minimize risks and costs associated with migration.



### 3.2.4. AWS Server-Based Architecture

1. **Server-Based Database Deployment**: AWS provides two main approaches for server-based database deployment: 
   - **Amazon Relational Database Service (Amazon RDS)** 
   - **Amazon Elastic Compute Cloud (Amazon EC2)**

2. **Typical Architecture**:
   - **Amazon EC2**: Hosts website content and application functions.
   - **Amazon RDS**: Provides data storage in multiple Availability Zones for fault tolerance.

3. **Scaling Considerations**:
   - **Instance Monitoring**: AWS offers built-in monitoring for server-based databases to aid in scaling decisions.
   - **Vertical Scaling**: For Amazon RDS, you can scale up by selecting a larger instance size with over 18 options available for various database engines.

4. **Amazon RDS Benefits**:
   - **Managed Service**: AWS handles configuration, management, and maintenance tasks.
   - **Automatic Backups & Encryption**: Provides backups and encryption both at rest and in transit.
   - **Scaling**: Allows easy scaling of compute and storage resources with minimal downtime.
   - **Read Replicas & Synchronous Replication**: Enhances performance, availability, and durability.

5. **Amazon EC2 Benefits**:
   - **Full Control**: Provides complete control over database deployment and configuration.
   - **Maintenance Supervision**: Allows you to manage maintenance windows, ports, and instances.
   - **Encryption**: Supports data encryption on Amazon EBS volumes.

6. **AWS Shared Responsibility Model**:
   - **Customer Responsibilities**: Includes securing data, operating systems, networks, and compliance requirements.
   - **AWS Responsibilities**: Manages server infrastructure, including networking and storage.

7. **Amazon EC2 Management**:
   - **Database Administration**: Includes installation, patching, and updates.
   - **Capacity Planning & High Availability**: Customer-managed.

8. **Amazon RDS Management**:
   - **Database Maintenance**: AWS performs maintenance tasks.
   - **Optimization Focus**: Allows more focus on application optimization rather than database management.

9. **Migration Ease**:
   - **EC2 Instances**: Allows seamless migration of on-premises databases to the cloud with similar configurations.

10. **Performance Considerations**:
    - **Load Management**: For high load scenarios, identifying and addressing resource constraints is crucial.

11. **Security and Compliance**:
    - **Shared Responsibility**: Ensures both AWS and customers uphold security and compliance standards.

12. **Flexibility vs. Control**:
    - **Amazon RDS**: Offers less control but simplifies management.
    - **Amazon EC2**: Provides full control but requires more administrative effort.




### 3.2.5 AWS Serverless Architecture Summary

1. **Serverless Database Services**: AWS offers distributed, fault-tolerant, highly available storage systems that scale automatically with demand.

2. **Typical Serverless Architecture**: A typical serverless web application on AWS includes:
   - **Amazon S3**: For storing website content.
   - **AWS Lambda**: For executing application code.
   - **Amazon Cognito**: For user authentication.
   - **Amazon DynamoDB**: For storing application data.

3. **Automatic Scaling**: AWS serverless architectures scale automatically in response to changes in application traffic, reducing the need for manual intervention.

4. **Amazon DynamoDB**:
   - **Fully Managed**: No server administration required.
   - **Supports Models**: Both document and key-value store models.
   - **ACID Transactions**: Ensures data consistency and durability.
   - **Automatic Scaling**: Adjusts capacity as needed without manual effort.
   - **Security**: Data is encrypted by default; integrates with AWS IAM.
   - **Global Access**: Replicate tables across multiple AWS Regions.
   - **DynamoDB Accelerator (DAX)**: Provides in-memory caching without altering application logic.

5. **Amazon Aurora Serverless**:
   - **On-Demand Scaling**: Automatically adjusts capacity based on application needs.
   - **Fault-Tolerant Storage**: Uses distributed, self-healing storage with six-way replication.
   - **Pay-As-You-Go**: Charges based on database resources consumed, with no cost when idle.
   - **Managed Service**: No need for hardware provisioning, patching, or backups.
   - **Use Cases**: Suitable for variable and unpredictable workloads, new applications, development and test databases, and multitenant applications.

6. **Cost Efficiency**:
   - Migrating to DynamoDB from Apache Cassandra resulted in a 70% cost saving.
   - Moving to Amazon Aurora Serverless from Amazon RDS for MySQL led to a 40% reduction in database costs.

7. **Event-Driven Scaling**: Serverless architectures use event-driven scaling to handle varying loads efficiently.

8. **No Manual Intervention**: Both DynamoDB and Aurora Serverless minimize the need for manual scaling and maintenance, improving operational efficiency.

9. **Flexibility**: Aurora Serverless supports applications with variable or unpredictable workloads, providing automatic scaling without affecting client connections.

10. **Development Efficiency**: Aurora Serverless is ideal for development and test environments due to its cost-effectiveness and automatic management.

11. **Multitenancy**: Aurora Serverless is beneficial for web applications with multiple customers, as it handles individual database capacities automatically.

12. **Security and Compliance**: Both DynamoDB and Aurora Serverless offer robust security features, including encryption and integration with AWS IAM for access management.


### 3.2.6 AWS Purpose-Built Databases Overview

1. **General Concept of Purpose-Built Databases**
   - Purpose-built databases are optimized for specific use cases, offering better performance, scalability, and cost-efficiency compared to general-purpose databases.

2. **Amazon RDS for Read-Heavy OLTP Applications**
   - **Use Case**: Handling read-heavy online transaction processing (OLTP) workloads.
   - **Key Feature**: Read replicas allow for elastic scaling of read traffic beyond single-instance limits.
   - **Benefits**: Increases aggregate read throughput and improves read-heavy workload performance.

3. **Amazon ElastiCache for Media Streaming**
   - **Use Case**: Supporting live media streaming and high-performance content delivery.
   - **Key Feature**: In-memory data store for fast metadata storage, authentication tokens, and content indexing.
   - **Benefits**: Provides sub-millisecond response times and scales to millions of users.

4. **Amazon DynamoDB for Gaming Applications**
   - **Use Case**: Managing game state, player data, session history, and leaderboards.
   - **Key Feature**: Automatically scales to handle millions of concurrent users with low latency.
   - **Benefits**: Ensures high performance and scalability for gaming applications.

5. **Amazon Neptune for Knowledge Graphs**
   - **Use Case**: Building and querying knowledge graphs with highly connected datasets.
   - **Key Feature**: Supports graph queries using SPARQL and stores data in graph models.
   - **Benefits**: Enables advanced data navigation and complex model querying.

6. **Amazon DocumentDB for Profile Management**
   - **Use Case**: Managing user profiles, preferences, and authentication in scalable applications.
   - **Key Feature**: Document data model allows for flexible and high-performance profile management.
   - **Benefits**: Scales to process millions of requests per second with millisecond latency.

7. **Time Series and Ledger Databases**
   - **Note**: Currently in preview mode on AWS.
   - **Use Cases**: Designed for time series data and ledger-type applications, useful for planning future needs.

8. **Choosing the Right Database**
   - **Strategy**: Select a database optimized for your specific problem or use case to achieve optimal performance and cost-efficiency.
   - **Outcome**: Avoid one-size-fits-all solutions by leveraging databases tailored to your application's needs.


## 3.3. Amazon Neptune

- **Amazon Neptune Overview:**
  - Amazon Neptune is optimized for managing highly connected data and performing graph queries.
  - It benefits from using a graph database for design, development, and performance in graph workloads.

- **Key Components:**
  - **Database Instances:**
    - **Primary Instance:** Supports read and write operations, performs data modifications. Only one primary instance is allowed.
    - **Replicas:** Up to 15 replicas, used for read-only operations, connect to the same storage volume as the primary instance.
  - **Cluster Volume:** Stores Neptune data with high availability across multiple Availability Zones within a single region.

- **Connecting to Neptune:**
  - **Endpoints:**
    - **Cluster Endpoint:** Connects to the current primary database instance.
    - **Reader Endpoint:** Connects to one of the Neptune replicas.
    - **Instance Endpoint:** Connects to a specific database instance.

- **Data Security:**
  - **IAM Integration:** Controls management access to Neptune.
  - **Encryption:**
    - Data in transit is protected via HTTPS.
    - Data at rest is encrypted with AES-256.
    - Encryption keys are managed through AWS Key Management Service (AWS KMS).

- **Integration with Other AWS Services:**
  - **Amazon Kinesis and AWS Lambda:** For streaming data and batch loading into Neptune.
  - **Amazon Comprehend and Amazon S3:** For extracting and storing data, then loading it into Neptune using AWS Lambda.

- **Real-World Use Cases:**
  - **Marketing Technology:** Uses Neptune for property graph models to manage relationships between users, devices, and cookies, enabling advanced identity resolution.
  - **Work Management Platform:** Uses Neptune for access control and improved graph query performance, freeing up resources for feature development.

- **Architecture Examples:**
  - **Real-Time Streaming:** Captures and processes data as it is collected.
  - **RSS Keyword Capture:** Utilizes Amazon Comprehend to extract information and store it in Neptune.


## 3.4. Redshift

1. **Data Warehouse Service**: Amazon Redshift is a fully managed, petabyte-scale data warehouse service in the cloud.

2. **Cluster Composition**: A Redshift data warehouse consists of a cluster, which includes a leader node and one or more compute nodes.

3. **Leader Node**: The leader node manages the distribution of jobs to the compute nodes and aggregates results from them.

4. **Compute Nodes**: Each compute node has dedicated CPU, memory, and disk storage. Jobs are divided into slices, processed within these slices, and then aggregated by the leader node.

5. **Connecting to Redshift**: Connections are made through an endpoint URL using SQL. You can connect using JDBC or ODBC drivers compatible with PostgreSQL.

6. **Security**:
   - **Access Control**: Managed via AWS Identity and Access Management (IAM) for user authentication and permissions.
   - **Network Isolation**: Redshift clusters run within an Amazon Virtual Private Cloud (Amazon VPC) for isolation.
   - **Data Encryption**: Data in transit is encrypted using SSL, and data at rest is encrypted with AES-256, managed by AWS Key Management Service (AWS KMS).

7. **Integration with AWS Services**:
   - **Data Movement**: AWS Glue can combine data from Amazon RDS and Amazon S3, transforming and loading it into Redshift.
   - **Event-Driven Analysis**: Amazon Kinesis Data Firehose and AWS Lambda can load data into an Amazon S3 data lake, which Redshift can query using Amazon Redshift Spectrum. Visualization can be done using Amazon QuickSight.

8. **Customer Use Cases**:
   - **Foursquare Labs**: Uses Redshift for flexible, rapid query execution and business intelligence visualization.
   - **Yelp**: Stores advertising information in Redshift for quick access and analysis, reducing query times from hours to seconds.

9. **Rich Data Platform Architecture**: Redshift is used as a repository for analytical data, combined with data from multiple sources for quality and efficiency.

10. **Event-Driven Data Analysis Architecture**: Redshift supports rapid data analysis and reporting in response to the increasing speed of data generation.

11. **Developer Resources**: Amazon Redshift offers a variety of resources, including documentation and tutorials, to help users get started with building data warehouses.

12. **Learn More**: Visit the [Amazon Redshift website](https://aws.amazon.com/redshift/) for additional information and resources.




## 3.3. DocumentDB

- **Amazon DocumentDB Overview**: A fully managed, fast, and reliable database service compatible with MongoDB, designed to handle mission-critical workloads with performance, scalability, and availability.

- **Compatibility**: Supports MongoDB workloads, allowing the use of existing MongoDB application code, drivers, and tools.

- **Data Storage**: Utilizes a document-based model where data is stored as JSON-like documents within collections. This enables flexible and nested data structures.

- **High Performance**: Offers high throughput and low latency for document queries, suitable for applications requiring quick responses and high scalability.

- **Automatic Scaling**: Automatically scales storage from 10GB to 64TB and adjusts capacity based on demand, ensuring cost-efficiency by charging only for used resources.

- **Security**: Includes built-in security features such as authentication via AWS IAM, secure connections using TLS, and data encryption with AES-256. Encryption is applied cluster-wide, including backups and snapshots.

- **Backup and Restore**: Provides continuous, incremental backups with point-in-time restore capabilities. Backup storage up to 100% of cluster storage is included at no extra cost; additional storage is billed per GB-month.

- **Cost Structure**: On-demand pricing with no long-term commitments. Charges are based on instance-hours, IOPS, and data transfer out of the database. Data transferred into the database is free.

- **Integration**: Can be integrated with other AWS services, such as AWS Elastic Beanstalk for web applications and Amazon API Gateway for connecting with microservices.

- **Use Cases**: Ideal for applications that manage content like user-generated content, high-performance mobile and web apps, and scenarios requiring real-time data access and analytics.

- **Customer Examples**: Used by companies like Hudl for performance analytics and The Washington Post for publishing and machine learning platforms, demonstrating its versatility and reliability in various industry applications.

- **Access and Management**: Managed via the AWS Management Console or AWS CLI, and operates within an Amazon VPC for secure network isolation.











