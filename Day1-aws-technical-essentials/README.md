## 1. Day 1 - AWS Technical Essentials

### 1.1. Introduction to AWS

#### 1.1.1.1. What is AWS?

- **Cloud computing** is the on-demand delivery of IT resources with pay-as-you-go pricing.
- **Deployment models** include on-premises, cloud, and hybrid, each offering varying levels of control and flexibility.
- **AWS** provides cloud services, eliminating the need for companies to manage physical data centers.
- **On-premises** models require maintaining hardware, while **cloud computing** allows for quick replication of environments.
- **AWS** handles "undifferentiated heavy lifting," enabling businesses to focus on strategic tasks.
- **Advantages of cloud computing** include pay-as-you-go pricing, massive economies of scale, and the ability to scale resources up or down as needed.
- Cloud computing through AWS increases **speed and agility** by reducing setup times from weeks to minutes.
- **Global reach** is easily achieved with AWS, allowing applications to be deployed in multiple regions quickly.

#### 1.1.1.2. AWS Global Infrastructure

- **AWS Global Infrastructure** consists of Regions, Availability Zones (AZs), and Edge Locations that form the physical foundation for AWS services.
- **Regions** are geographic areas around the world where AWS hosts data centers. Each Region is independent and isolated from others, with unique Region codes (e.g., `us-east-1` for N. Virginia).
- **Availability Zones (AZs)** are clusters of data centers within a Region, designed for redundancy and low-latency connectivity. AZs are identified by appending a letter to the Region code (e.g., `us-east-1a`).
- **Choosing a Region** involves considering factors like latency, pricing, service availability, and data compliance to best meet the needs of your application.
- **Service Scope** varies by AWS service, with some services operating at the Region level (automatic redundancy) and others at the AZ level (where you manage redundancy).
- **High Availability & Resiliency** are achieved by replicating workloads across multiple AZs, ensuring that if one AZ fails, another can handle the traffic.
- **Edge Locations** are global sites where content is cached to reduce latency for end-users. Amazon CloudFront uses these locations to deliver content quickly and efficiently.

#### 1.1.1.3. Interacting With AWS

- **Every action in AWS** is an API call that is authenticated and authorized, whether through the AWS Management Console, AWS CLI, or AWS SDKs.
- **AWS Management Console** allows you to manage cloud resources via a web-based interface, making it easy to create and manage resources, especially for beginners.
- **Region Selector** in the AWS Management Console allows you to make requests to services in different AWS Regions by changing the Region setting.
- **AWS CLI** is a unified command-line tool to manage AWS services programmatically, enabling automation through scripts and handling multiple services from a single interface.
- **AWS SDKs** allow developers to integrate AWS services into their applications using popular programming languages like Python, Java, and more.
- **Example Usage**: The AWS CLI can list S3 buckets, and AWS SDKs can interact with services programmatically, such as using Boto3 in Python to manage EC2 instances.
#### 1.1.1.4. Security and the AWS Shared Responsibility Model

- **Shared Responsibility Model**: Security in the AWS Cloud is a shared responsibility between AWS and the customer, divided into "security of the cloud" (AWS's responsibility) and "security in the cloud" (customer's responsibility).

- **AWS Responsibility (Security of the Cloud)**: AWS is responsible for securing the infrastructure, including physical security, hardware, software, networking components, and the management of Regions, Availability Zones, and data centers.

- **AWS Service Categories**:
  - **Infrastructure Services**: AWS manages the underlying infrastructure and foundation services (e.g., Amazon EC2).
  - **Abstracted Services**: AWS manages more aspects, including the infrastructure layer, operating systems, platforms, and data protection (e.g., Amazon S3).

- **Customer Responsibility (Security in the Cloud)**: Customers are responsible for configuring services, securing their applications, and protecting their data. This includes choosing secure configurations, managing access controls, and ensuring data encryption and backups.

- **Customer Service Categories**:
  - **Infrastructure Services**: Customers manage the operating system, application platform, and data security.
  - **Abstracted Services**: Customers focus on securing their data, including encryption and access control.

- **Compliance and Control**: Customers must align AWS service usage with their IT environment's security standards, laws, and regulations, maintaining full control and responsibility over their data and content.

#### 1.1.1.5. Protecting the AWS Root User

- The AWS root user is the initial identity created with an AWS account, having full access to all AWS services and resources.
- The root user credentials include an email/password combination for AWS Management Console access and access keys for programmatic access via AWS CLI/API.
- **Best Practices for Root User:**
  - Use a strong password.
  - Enable Multi-Factor Authentication (MFA).
  - Do not share root user credentials or access keys.
  - Delete access keys associated with the root user unless absolutely necessary.
  - Use IAM users for regular administrative and everyday tasks.
- MFA enhances security by requiring two or more authentication methods, such as a password and a one-time passcode from a device.
- AWS supports various MFA devices, including virtual MFA apps (e.g., Google Authenticator), hardware TOTP tokens, and FIDO security keys.
#### 1.1.1.6. AWS Identity and Access Management

- **Authentication vs. Authorization**: Authentication confirms the user’s identity, while authorization grants permissions to access AWS resources.
- **IAM Overview**: IAM helps manage access to AWS accounts and resources, enabling granular control over who can do what in the AWS environment.
- **Key Features of IAM**: IAM is global, integrated with AWS services, supports MFA, identity federation, and is free to use.
- **IAM Users and Groups**: Users are individual identities in your AWS account, and groups allow you to manage permissions collectively, making it easier to scale and administer access.
- **IAM Policies**: Policies define permissions for users or groups in JSON format, specifying actions, resources, and conditions for access.
- **Best Practices**: Secure the root user, follow the principle of least privilege, use IAM roles when possible, consider an identity provider for large teams, and regularly review and remove unused credentials.

<hr style="height: 5px; background-color: white; border: none;">

### 1.1.2. AWS Compute 

#### 1.1.2.1. Compute as a Service

- **Servers** are the fundamental building blocks for hosting applications, handling HTTP requests, and transforming them into responses.
- **Common HTTP servers** include Windows options like IIS and Linux options like Apache HTTP Server, Nginx, and Apache Tomcat.
- AWS offers various **compute services** for running applications, including virtual machines (VMs), container services, and serverless options.
- **Virtual machines (VMs)** emulate physical servers, allowing you to install HTTP servers and run applications. AWS provides VMs through Amazon Elastic Compute Cloud (Amazon EC2).
- **Amazon EC2** offers secure and resizable compute capacity, with AWS managing the underlying hardware, hypervisor, and guest operating systems.
- **Understanding EC2 and virtualization** is crucial before moving on to container services and serverless compute options.

#### 1.1.2.2. Getting Started with Amazon EC2

- **Provision and Manage Instances**: Amazon EC2 allows you to quickly provision and launch virtual servers (EC2 instances) and manage them via the AWS Management Console, AWS CLI, SDKs, or automation tools.
  
- **Pay-as-You-Go**: You pay by the hour or second for each instance type, making it cost-effective by only paying for the compute capacity you use.

- **Amazon Machine Image (AMI)**: EC2 instances are launched from AMIs, which include the operating system and pre-configured software. AMIs can be reused to launch identical instances.

- **Instance Types and Families**: EC2 offers various instance types optimized for different workloads, categorized into families such as General Purpose, Compute Optimized, Memory Optimized, Accelerated Computing, and Storage Optimized.

- **High Availability**: For higher availability, it's recommended to use multiple EC2 instances distributed across different Availability Zones to reduce the impact of any single instance failure.

- **Custom VPCs**: By default, EC2 instances are launched in a public Virtual Private Cloud (VPC). For better security and networking control, creating custom VPCs is advised as you gain more experience.

- **Flexible Configurations**: When creating an EC2 instance, you can specify hardware (CPU, memory, storage) and logical configurations (networking, firewall rules, authentication).

- **Instance Sizing**: EC2 allows you to choose the instance size based on your application's needs, enabling you to scale capacity easily as demand changes.

#### 1.1.2.3. EC2 instance lifecycle

- **Pending State:** The instance is being set up (e.g., AMI content is copied, networking components allocated), and billing has not yet started.
- **Running State:** The instance is fully operational and ready for use, with billing starting at this stage. Actions like reboot, terminate, stop, and stop-hibernate are available.
- **Stopping and Stopped States:** Stopping an instance halts it, allowing modifications and saving costs, though storage charges for EBS volumes continue. Stop-hibernate retains RAM contents to speed up startup.
- **Terminated State:** The instance is permanently deleted, losing its IP addresses and any data on instance stores. Billing stops as the instance enters the terminated state.
- **Difference Between Stop and Stop-Hibernate:** Stop clears RAM, while stop-hibernate saves RAM contents to disk, allowing faster startup.
- **Pricing Models:** 
  - **On-Demand Instances:** Pay per hour/second without long-term commitments; ideal for flexible, short-term, or unpredictable workloads.
  - **Spot Instances:** Bid for unused capacity at up to 90% off, suited for flexible or fault-tolerant workloads.
  - **Savings Plans:** Commit to a 1- or 3-year term for up to 72% savings, ideal for predictable, steady workloads.
  - **Reserved Instances:** Reserve capacity with up to 72% savings; choose between Standard, Convertible, or Scheduled options based on usage patterns.
  - **Dedicated Hosts:** Get a physical server dedicated to your use, benefiting from license cost reductions and compliance requirements.


#### 1.1.2.4. Container Services

- **Containers Overview**: Containers package code and dependencies into standardized units that run consistently across various environments. They simplify deployment by creating isolated, portable environments for applications.

- **Container vs. VM**: Containers share the host operating system and kernel, making them lighter and quicker to start compared to virtual machines, which include their own operating systems. This leads to faster scaling and more efficient resource use.

- **Container Orchestration**: AWS provides two main orchestration services for managing containers at scale:
  - **Amazon ECS (Elastic Container Service)**: A fully-managed container orchestration service that supports running containers on EC2 instances or using AWS Fargate for serverless execution. Containers are defined in a task definition, which includes details like CPU, memory, and networking.

  - **Amazon EKS (Elastic Kubernetes Service)**: A managed Kubernetes service for orchestrating containerized workloads. EKS handles the Kubernetes control plane and node management, offering high availability and fine-grained control over container orchestration.

- **Container Task Definition in ECS**: In Amazon ECS, task definitions specify container resources and configurations in a JSON format. This includes CPU, memory, and networking settings required to run the containers.

- **Differences between ECS and EKS**: ECS uses AWS native technology with containers running on EC2 instances, while EKS leverages Kubernetes for container orchestration, allowing for advanced management and scalability of containerized applications.

- **Historical Context**: Container technology evolved from UNIX kernel features in the 1970s, initially requiring manual configuration, and has since been streamlined by open-source advancements to address reliability issues across different computing environments.


#### 1.1.2.5. 

- **Reduction of Heavy Lifting**: Traditional EC2 requires you to manage both physical hardware and logical controls like operating systems and scaling, while container services like Amazon ECS and EKS still involve managing underlying EC2 instances.

- **Serverless Advantages**: Serverless computing eliminates the need to manage EC2 instances, allowing you to focus solely on application logic.

- **Key Features of Serverless**:
  - No need to provision or manage servers.
  - Automatic scaling based on usage.
  - Pay only for actual usage; no costs for idle resources.
  - Built-in availability and fault tolerance.

- **Serverless Services**: AWS provides serverless solutions at all application layers, including AWS Fargate and AWS Lambda, which will be explored in further lessons.

##### 1.1.2.5.1. AWS FARGATE

- **Serverless Containers**: AWS Fargate is a serverless compute engine for containers, abstracting the underlying EC2 instances to manage compute infrastructure.
- **Integration**: It integrates with Amazon ECS (Elastic Container Service) and Amazon EKS (Elastic Kubernetes Service), along with IAM (Identity and Access Management) and Amazon VPC (Virtual Private Cloud).
- **Infrastructure Management**: Fargate automatically scales and manages the infrastructure, allowing developers to focus on application development without managing EC2 instances or cluster capacity.
- **Workload Isolation**: It provides workload isolation and enhanced security by design.
- **Networking Control**: With Amazon VPC integration, Fargate enables you to launch containers within your network and control connectivity to your applications.
- **Support for ECS and EKS**: Fargate supports both Amazon ECS and Amazon EKS, offering flexibility in container orchestration choices.
- **Automatic Resource Allocation**: It allocates the appropriate amount of compute resources, optimizing performance and resource utilization.
- **No Instance Management**: There is no need to choose, manage, or scale EC2 instances as Fargate handles these aspects automatically.


##### 1.1.2.5.2. AWS Lambda

- **Serverless Computing**: AWS Lambda lets you run code without managing servers or containers, allowing for serverless deployments. This covers various applications like data processing, real-time streams, machine learning, IoT backends, and web applications.

- **Function Management**: Lambda functions can be created from scratch, using blueprints, or by deploying container images. You can also browse the AWS Serverless Application Repository for pre-built functions.

- **Triggers and Events**: Functions are triggered by events, which are JSON-formatted documents. You can set up Lambda functions to respond to API calls, stream data, or queue messages automatically.

- **Application Environment**: Lambda provides a secure, isolated runtime environment for your functions, managing the resources needed for execution.

- **Deployment Packages**: Code is deployed using either a .zip file containing the function code and dependencies or a container image that adheres to OCI specifications.

- **Runtime Options**: Lambda supports multiple built-in runtimes (Python, Node.js, Ruby, etc.) and allows for custom runtimes to fit specific needs.

- **Function Handler**: The handler method in your Lambda function processes events. It is invoked when your function is triggered and becomes available again once it finishes execution.

- **Billing**: You pay only for what you use, based on the number of requests and execution time, rounded to the nearest millisecond. This model is cost-effective, particularly for short-duration tasks.


##### 1.1.2.6. Choosing the Right Compute Service


- **AWS Lambda**: Ideal for infrequent, event-driven tasks such as automating database updates from files uploaded to Amazon S3. It charges only for the compute time used, making it cost-effective for tasks that run rarely.

- **Amazon EC2**: Suitable for applications requiring minimal refactoring during migration, especially if the application is already running on Linux servers and needs to be moved to AWS. EC2 supports varying demand and is flexible for traditional server-based applications.

- **AWS Container Services (ECS or EKS)**: Best for new applications designed with a microservices or service-oriented architecture. Containers enable rapid scaling, code portability, and reduce deployment risks by ensuring consistent behavior across environments.

- **Service Selection**: Each AWS compute service is designed for specific use cases. AWS Lambda is great for sporadic tasks, EC2 for traditional server workloads, and ECS/EKS for containerized, scalable applications. Choose the right service based on your specific requirements.

- **Cost and Efficiency**: Consider the cost implications and efficiency of each service. Lambda is cost-effective for low-frequency tasks, while EC2 might be less economical if always running but suitable for continuous workloads.

- **Scalability and Flexibility**: Containers (ECS/EKS) offer quick scaling and ease of management for microservices, whereas EC2 provides flexibility for various types of applications needing server-based solutions.

- **Minimize Refactoring**: When migrating existing applications, using EC2 can minimize the need for significant changes to your current setup, facilitating a smoother transition to AWS.

<hr style="height: 5px; background-color: white; border: none;">

### 1.1.3. AWS Networking

##### 1.1.3.1. Introduction to Networking

- **Networking Overview**: Networking connects computers globally to facilitate communication, similar to how AWS uses data centers, Availability Zones, and Regions for its global infrastructure.

- **Basic Networking Concept**: Analogous to sending a letter, networking requires an address for accurate message delivery. In digital terms, this involves routing messages using IP addresses.

- **IP Addresses**: Each computer has a unique IP address made up of bits (0s and 1s). For example, a 32-bit IP address can be represented in binary format, such as `11000000 10101000 00000001 00011110`.

- **IPv4 Notation**: IP addresses are usually written in decimal format as IPv4 addresses. For instance, `192.168.1.30` is a common way to represent a 32-bit IP address using four groups of eight bits separated by periods.

- **CIDR Notation**: Classless Inter-Domain Routing (CIDR) notation is used to specify ranges of IP addresses. For example, `192.168.1.0/24` indicates that the first 24 bits are fixed, leaving 8 bits flexible, allowing for 256 possible IP addresses.

- **CIDR Range Impact**: The number after the `/` in CIDR notation determines the size of the IP range. A higher number means fewer IP addresses. For instance, `/28` provides 16 IP addresses, while `/16` provides 65,536 IP addresses.

- **AWS Network Size**: When configuring networks in AWS, you select the size using CIDR notation. The smallest IP range in AWS is `/28` and the largest is `/16`.

##### 1.1.3.2. Amazon VPC

- **Amazon VPC Creation**: A Virtual Private Cloud (VPC) is an isolated network within the AWS Cloud. When creating a VPC, you select a name, region (spanning all Availability Zones within the region), and an IP range in CIDR notation, which defines the network size.

- **Subnets**: After creating a VPC, you create subnets (smaller networks within the VPC) for better organization and management. Subnets can be public (accessible from the internet) or private (not accessible from the internet). Each subnet is associated with a specific Availability Zone and must be within the VPC’s CIDR block.

- **High Availability**: To ensure high availability and fault tolerance, create subnets in at least two different Availability Zones. This setup provides redundancy if one zone fails.

- **Reserved IPs**: AWS reserves five IP addresses in each subnet for its own use (e.g., routing, DNS). For example, in a subnet with a /24 range, 251 IP addresses are available for use.

- **Internet Gateway**: To enable internet access for a VPC, an internet gateway is required. It connects the VPC to the internet and is highly available and scalable.

- **Virtual Private Gateway**: This gateway connects your VPC to another private network, allowing for encrypted VPN connections between the VPC and your on-premises network.

- **AWS Direct Connect**: Provides a secure, dedicated physical connection between your on-premises data center and your VPC, using a standard Ethernet fiber-optic cable for direct communication with AWS services or your VPC.

##### 1.1.3.3. Amazon VPC Routing

- **Default Main Route Table**: AWS automatically creates a default route table called the main route table for each VPC, which allows traffic to flow between all subnets in the VPC by default.
  
- **Immutability of Main Route Table**: You cannot delete the main route table or set a gateway route table as the main route table. However, you can replace it with a custom subnet route table.
  
- **Route Management**: The main route table can be modified by adding, removing, or changing routes. You can also explicitly associate subnets with the main route table.

- **Custom Route Tables**: For more control, you can create custom route tables to define specific routing rules for different subnets, especially for accessing resources outside the VPC.

- **Subnet Association**: Subnets that do not have an explicit route table association will use the main route table by default. Associating a subnet with a custom route table overrides the default.

- **Local Route Inclusion**: Custom route tables automatically include a local route for communication between resources within the VPC.

- **VPC Protection**: By using custom route tables for new subnets, you can maintain the default state of the main route table and better control routing policies for specific subnets.

##### 1.1.3.4. Amazon VPC Security

- **Network Access Control Lists (Network ACLs)**:
  - Act as a virtual firewall for subnets, allowing or denying specific inbound or outbound traffic.
  - Default ACLs allow all traffic in and out, which is useful for initial setups but might need adjustments for additional security.
  - Custom ACLs can restrict traffic, such as allowing only HTTPS (port 443) and RDP traffic while specifying outbound port ranges for ephemeral ports.

- **Security Groups**:
  - Function as a virtual firewall for EC2 instances, with default settings blocking all inbound traffic but allowing all outbound traffic.
  - Stateful nature means they remember connection initiation, allowing responses without modifying inbound rules.
  - To accept traffic from the internet, specific inbound rules need to be set up, such as allowing HTTP (port 80) and HTTPS (port 443) traffic.
  - Can be used to organize resources into groups and control network communication between these groups, similar to VLANs but without network-level isolation.

- **Design Patterns**:
  - Common practice involves using security groups to segregate traffic between different tiers (e.g., web, application, database) and control access based on defined rules.
  - Allows isolation and controlled communication between resource tiers, providing a more flexible alternative to traditional network isolation methods.

<hr style="height: 5px; background-color: white; border: none;">

### 1.1.4. AWS Storage

##### 1.1.4.1. Storage Types

- **File Storage**
  - Stores data as files in a hierarchical structure with folders and subfolders.
  - Each file has metadata (name, size, creation date) and a path for retrieval.
  - Ideal for centralized access and sharing among multiple hosts.
  - Common use cases include web serving, analytics, media and entertainment, and home directories.

- **Block Storage**
  - Stores data in fixed-size blocks with unique addresses, allowing efficient access and modification.
  - Changes affect only the relevant block, making it fast and bandwidth-efficient.
  - Best suited for low-latency operations in transactional databases, containerized applications, and virtual machines.

- **Object Storage**
  - Stores data as objects in a flat structure (buckets), each with a unique identifier and metadata.
  - Objects must be updated in whole when modified, which can be less efficient for small changes.
  - Well-suited for data archiving, backup and recovery, and storing rich media due to its scalability and cost-effectiveness.


##### 1.1.4.2. Amazon Elastic File System (Amazon EFS)

### Amazon Elastic File System (Amazon EFS)
- **Automatic Scaling**: EFS automatically grows and shrinks as files are added or removed, eliminating the need for manual capacity management.
- **No Provisioning Needed**: Users don't need to provision or manage storage capacity and performance; EFS handles it automatically.
- **High Connectivity**: Supports connecting tens, hundreds, or even thousands of compute instances simultaneously with consistent performance.
- **Flexible Storage Classes**: Offers multiple storage classes, including EFS Standard, EFS Standard-IA (Multi-AZ resilience), EFS One Zone, and EFS One Zone-IA (single availability zone) for cost savings.
- **Pay-as-You-Go**: Charges are based on the amount of storage used, with no minimum fees or setup costs.
- **Easy Setup**: Provides a simple web interface for quick creation and configuration of file systems.

### Amazon FSx
- **Managed Services**: Fully managed file systems offering reliability, security, and scalability.
- **Variety of File Systems**: Includes Lustre, NetApp ONTAP, OpenZFS, and Windows File Server, catering to different needs and performance profiles.
- **FSx for NetApp ONTAP**: Combines NetApp’s features with AWS scalability, suitable for existing ONTAP deployments and accessible from multiple operating systems.
- **FSx for OpenZFS**: Provides high performance and data management features (like snapshots and cloning) for Linux-based environments, with minimal administrative overhead.
- **FSx for Windows File Server**: Delivers a native Windows file system with SMB protocol support, simplifying file server management for Windows applications.
- **FSx for Lustre**: Optimized for high-performance storage with high throughput and IOPS, integrating with Amazon S3 for scalable data processing.

##### 1.1.4.3. Block Storage with Amazon EC2 Instance Store and Amazon EBS

- **Amazon EC2 Instance Store**:
  - Provides temporary block-level storage directly attached to the host computer.
  - Data is ephemeral and tied to the instance lifecycle; deleting the instance deletes the data.
  - Ideal for high-performance, temporary storage needs, such as caching or scratch data.

- **Amazon EBS (Elastic Block Store)**:
  - Offers persistent block-level storage that can be attached to an EC2 instance.
  - EBS volumes are detachable and can be reattached to different instances within the same Availability Zone.
  - Provides persistent storage that survives instance termination.

- **EBS Volume Types**:
  - **SSD Volumes**: Include General Purpose (gp3, gp2) and Provisioned IOPS (io2 Block Express, io2, io1) for transactional workloads and high performance.
  - **HDD Volumes**: Include Throughput Optimized (st1) and Cold HDD (sc1) for large streaming workloads.

- **EBS Benefits**:
  - **High Availability**: Automatically replicated within its Availability Zone.
  - **Data Persistence**: Data remains intact even if the instance is stopped or terminated.
  - **Data Encryption**: Supports encryption for all volumes when activated by the user.
  - **Flexibility**: Allows modifications to volume size, type, and IOPS capacity without stopping the instance.
  - **Backups**: Enables the creation of incremental backups (snapshots) of volumes.

- **Snapshots**:
  - Incremental backups that save only the changed blocks of data.
  - Stored in Amazon S3 for redundancy and can be used to create new volumes.



##### 1.1.4.4. Object Storage with Amazon S3

- **Amazon S3 Overview**: Amazon Simple Storage Service (Amazon S3) is an object storage service that allows you to store and retrieve data from anywhere on the web. Unlike Amazon EBS, S3 is a standalone storage solution not tied to compute resources.

- **Object Storage Concepts**: S3 stores data as objects, which include a file and its metadata, in a flat structure within containers called buckets. Each object is uniquely identified by a combination of bucket name, key, and version ID.

- **Bucket Naming**: Bucket names must be unique globally across AWS accounts and regions. They can only include lowercase letters, numbers, dots, and hyphens, and must follow specific formatting rules.

- **Object Keys**: Objects in S3 are identified by unique key names within buckets. Although S3 does not inherently support a hierarchical structure, key name prefixes and delimiters can simulate a folder-like organization.

- **Use Cases**: Amazon S3 is versatile, supporting backup and storage, media hosting, software delivery, data lakes, static websites, and static content storage. Its scalability and storage class options make it suitable for a wide range of applications.

- **Security**: S3 resources are private by default. Access can be controlled using IAM policies, bucket policies, and encryption. S3 supports server-side encryption with S3-managed keys to protect data at rest.

- **Storage Classes**: S3 offers multiple storage classes to accommodate different access patterns and cost requirements, including Standard, Intelligent-Tiering, Standard-IA, One Zone-IA, Glacier (Instant Retrieval, Flexible Retrieval, Deep Archive), and S3 on Outposts.

- **Versioning**: Enabling versioning on S3 buckets allows multiple versions of an object to be stored, helping recover from accidental deletions or overwrites. Buckets can be unversioned, versioning-enabled, or versioning-suspended.

- **Lifecycle Management**: S3 lifecycle policies automate the transition of objects between storage classes and manage expiration. This helps optimize storage costs by automating actions like transitioning infrequently accessed data to cheaper storage classes or deleting old data.

| Name                | Period         | Description                                                                                     |
|---------------------|-----------------|-------------------------------------------------------------------------------------------------|
| **Standard**        | Always           | Ideal for frequently accessed data. Provides high durability, availability, and performance.   |
| **Intelligent-Tiering** | Ongoing         | Optimizes cost by automatically moving data between two access tiers (frequent and infrequent). |
| **Standard-IA**     | Long-term       | For data that is less frequently accessed but requires rapid access when needed.              |
| **One Zone-IA**     | Long-term       | For infrequently accessed data that can be recreated if the availability zone is destroyed.   |
| **Glacier (Instant Retrieval)** | Rarely       | Low-cost storage for long-term archival data with retrieval times within minutes.             |
| **Glacier (Flexible Retrieval)** | Rarely       | Low-cost storage for long-term archival data with retrieval times from minutes to hours.      |
| **Glacier (Deep Archive)** | Rarely       | Most cost-effective storage for data that is rarely accessed, with retrieval times of 12 hours. |
| **S3 on Outposts**  | Ongoing         | Provides local storage on-premises with S3 features, suitable for data residency and latency needs. |


<hr style="height: 5px; background-color: white; border: none;">

#### 1.1.5. Databases on AWS

##### 1.1.5.0 Introduction to Databases on AWS
- **Evolution of Database Choices**: Initially, database choices were limited, often defaulting to relational databases without fully understanding use cases. Relational databases have been predominant since the 1970s.

- **Relational Databases**: These databases organize data into tables with rows and columns, creating relationships between tables through shared attributes. They use a fixed schema, making changes difficult once operational.

- **Relational Database Management Systems (RDBMS)**: Examples include MySQL, PostgreSQL, Oracle, Microsoft SQL Server, and Amazon Aurora. SQL is used for querying and managing data, allowing complex queries to understand relationships and patterns.

- **Benefits of Relational Databases**:
  - **Complex SQL Queries**: Enables joining multiple tables to understand data relationships.
  - **Reduced Redundancy**: Centralizes data storage to avoid duplication.
  - **Familiarity**: Long history makes them well-known to technical professionals.
  - **Accuracy**: Ensures data integrity through ACID principles.

- **Use Cases**:
  - **Fixed Schema Applications**: Applications with a static schema that don’t frequently change.
  - **Persistent Storage Applications**: Systems requiring consistent storage and adherence to ACID principles, such as ERP, CRM, and financial applications.

- **Managed vs. Unmanaged Databases**:
  - **Unmanaged Databases**: Hosted on EC2, where AWS handles infrastructure but the user manages the database.
  - **Managed Databases**: AWS handles setup, high availability, scalability, patching, and backups, while the user focuses on database tuning and security.

##### 1.1.5.1. Amazon RDS

- **Managed Database Service**: Amazon RDS simplifies relational database management by handling tasks like provisioning, patching, scaling, and backups, allowing you to focus on application development rather than database maintenance.
  
- **Supported Database Engines**: RDS supports multiple database engines including:
  - Commercial: Oracle, SQL Server
  - Open Source: MySQL, PostgreSQL, MariaDB
  - AWS Cloud Native: Aurora

- **Database Instances**: RDS instances are built on EC2 instances managed via the RDS console. Each instance type impacts processing power and memory. A single DB instance can host multiple databases.

- **Storage Types**: RDS uses Amazon EBS for general storage, with options like General Purpose SSD (gp2, gp3), Provisioned IOPS SSD (io1), and Magnetic (standard). Aurora uses cluster volumes with SSDs and data is replicated across three Availability Zones.

- **Network Configuration**: RDS instances are deployed within a Virtual Private Cloud (VPC) and can be restricted using network ACLs and security groups to control access. This setup enhances security by isolating databases from direct internet access.

- **Backup and Recovery**: Automated backups are enabled by default, retaining backups for up to 35 days and supporting point-in-time recovery. Manual snapshots can be used for longer retention periods and granular recovery.

- **High Availability**: Multi-AZ deployments create a redundant database copy in a different Availability Zone, ensuring failover and high availability. In case of failure, RDS automatically promotes the standby instance to primary.

- **Security**: Access management is controlled using network ACLs, security groups, and IAM policies to restrict traffic and permissions. This ensures secure interaction with your RDS resources.


##### 1.1.5.2. Purpose-built databases

- **Shift from Relational Databases**: Relational databases, while versatile, are not always the best fit for every application. Purpose-built databases address specific needs more effectively.
- **Amazon DynamoDB**: A fully managed NoSQL database offering fast and consistent performance, ideal for high-scale and serverless applications. It features flexible billing and tight integration with infrastructure as code (IaC).
- **Amazon ElastiCache**: Provides a managed in-memory caching solution with support for Redis and Memcached. It handles instance failovers, backups, and software upgrades.
- **Amazon MemoryDB for Redis**: A durable, in-memory database with ultra-fast performance and Multi-AZ durability, suitable for microservices and high-performance applications.
- **Amazon DocumentDB**: A managed document database compatible with MongoDB, useful for content management, profile management, and web/mobile applications.
- **Amazon Keyspaces**: A managed service compatible with Apache Cassandra, designed for high-volume applications with straightforward access patterns using Cassandra Query Language (CQL).
- **Amazon Neptune**: A managed graph database suited for highly connected data, often used in recommendation engines, fraud detection, and knowledge graphs.
- **Amazon Timestream**: A serverless time series database optimized for IoT and operational applications, capable of handling trillions of events per day efficiently.
- **Amazon QLDB**: A ledger database that provides a complete, cryptographically verifiable history of changes to application data, improving data integrity and lineage tracking.

##### 1.1.5.3. AWS DynamoDB

- **Fully Managed NoSQL Database**: DynamoDB is a managed service offering fast and predictable performance with seamless scalability, handling administrative tasks like hardware provisioning, setup, replication, and scaling.
  
- **Core Components**: It uses tables, items, and attributes. Tables store items, which consist of attributes. Primary keys identify items uniquely, and secondary indexes enhance querying flexibility.

- **Scalability and Performance**: Tables can scale throughput capacity up or down without downtime. Data is stored on SSDs, replicated across multiple Availability Zones for high availability and durability.

- **Use Cases**: Ideal for applications needing high scalability, including internet-scale apps, media metadata stores, gaming platforms, and retail experiences. Supports high concurrency and large-scale operations.

- **Security Features**: Data is encrypted at rest using AWS KMS, and access is managed through IAM roles and policies. DynamoDB operations are monitored via CloudTrail for security and compliance.

- **Operational Overhead**: Handles operations and scaling, making it suitable for mission-critical applications that require high availability and low maintenance.

- **High Availability**: Ensures data is available across regions with built-in replication, offering resilience against failures and minimizing downtime.

- **Monitoring and Management**: Use AWS Management Console to monitor performance metrics and resource usage, and CloudTrail for detailed logs of DynamoDB operations.

##### 1.1.5.4. Choosing the Right Database Service

- **AWS Database Portfolio**: AWS offers various database services tailored for different needs, including relational, key-value, in-memory, document, wide-column, graph, time series, and ledger databases.
- **Database Types and Use Cases**:
  - **Relational Databases** (Amazon RDS, Aurora, Amazon Redshift): Suitable for traditional applications, ERP systems, CRM systems, and ecommerce.
  - **Key-Value Databases** (DynamoDB): Ideal for high-traffic web applications, ecommerce systems, and gaming applications.
  - **In-Memory Databases** (Amazon ElastiCache for Memcached, Amazon ElastiCache for Redis): Best for caching, session management, gaming leaderboards, and geospatial applications.
  - **Document Databases** (Amazon DocumentDB): Used for content management, catalogs, and user profiles.
  - **Wide Column Databases** (Amazon Keyspaces): Designed for high-scale industrial applications such as equipment maintenance, fleet management, and route optimization.
  - **Graph Databases** (Neptune): Suitable for fraud detection, social networking, and recommendation engines.
  - **Time Series Databases** (Timestream): Ideal for IoT applications, DevOps, and industrial telemetry.
  - **Ledger Databases** (Amazon QLDB): Used for systems of record, supply chain management, registrations, and banking transactions.
- **Modern Application Architecture**: Modern applications often use multiple databases, each purpose-built for specific tasks, rather than a single database. This approach supports a more flexible, scalable, and efficient system.

- **AWS Database Portfolio**:

| AWS Service(s)                                             | Database Type  | Use Cases                                                         |
|------------------------------------------------------------|-----------------|-------------------------------------------------------------------|
| Amazon RDS, Aurora, Amazon Redshift                       | Relational      | Traditional apps, ERP, CRM, ecommerce                             |
| DynamoDB                                                   | Key-value       | High-traffic web apps, ecommerce systems, gaming apps             |
| Amazon ElastiCache for Memcached, Amazon ElastiCache for Redis | In-memory       | Caching, session management, gaming leaderboards, geospatial apps |
| Amazon DocumentDB                                         | Document        | Content management, catalogs, user profiles                      |
| Amazon Keyspaces                                          | Wide column     | High-scale industrial apps, equipment maintenance, fleet management, route optimization |
| Neptune                                                    | Graph           | Fraud detection, social networking, recommendation engines        |
| Timestream                                                 | Time series     | IoT applications, DevOps, industrial telemetry                    |
| Amazon QLDB                                                | Ledger          | Systems of record, supply chain, registrations, banking transactions|


##### 1.1.6. Monitoring, Load Balancing, and Scaling 


##### 1.1.6.1.

- **Purpose of Monitoring**: Collects and analyzes data about the operational health and usage of AWS resources to address questions about performance, availability, capacity, and alerts.
- **Metrics and Statistics**: Metrics are data points collected from AWS resources, such as CPU utilization or network performance. Analyzing these metrics helps in understanding resource health and performance trends.
- **Types of Metrics**:
  - **Amazon S3**: Object size, number of objects, HTTP requests.
  - **Amazon RDS**: Database connections, CPU utilization, disk space consumption.
  - **Amazon EC2**: CPU utilization, network utilization, disk performance, status checks.
- **Monitoring Benefits**:
  - **Respond Proactively**: Identify and address issues before they affect end users by monitoring metrics like error rates and request latency.
  - **Improve Performance and Reliability**: Detect bottlenecks and inefficiencies to enhance the performance and reliability of resources.
  - **Recognize Security Threats**: Establish baselines to identify anomalies and potential security threats, triggering alerts or investigations.
  - **Make Data-Driven Decisions**: Use metrics to evaluate new features or changes, guiding business decisions based on usage and performance data.
  - **Create Cost-Effective Solutions**: Optimize resource allocation by identifying underused resources and adjusting them to reduce costs.


##### 1.1.6.2. Amazon CloudWatch

- **Monitoring and Observability**: Amazon CloudWatch is a service that collects and analyzes resource data to provide insights into application performance and operational health.
- **Key Features**:
  - **Anomaly Detection**: Identifies unusual behavior in your AWS environments.
  - **Alarms**: Set up alerts based on predefined thresholds to notify you of issues or take automated actions.
  - **Visualization**: Use CloudWatch dashboards to view and analyze metrics and logs with customizable widgets.
  - **Logs Management**: Centralizes log data from various AWS services and applications for easier monitoring and troubleshooting.
- **Metrics and Dimensions**: Metrics represent time-ordered data points, and dimensions are used to filter and categorize these metrics.
- **Custom Metrics**: Allows you to publish and monitor application-specific metrics with high-resolution options for more granular visibility.
- **CloudWatch Logs**: Provides a centralized place to store and analyze log data, enabling you to query and filter logs and create metrics from log data.
- **Alarms and Actions**: Configure alarms based on metric thresholds to trigger notifications or automated responses, such as scaling or rebooting instances.
- **Integration and Security**: Works with AWS Identity and Access Management (IAM) for access control and integrates with other AWS services for automated and scalable monitoring solutions.


##### 1.1.6.3. Solution Optimization

- **Availability Metrics**: Availability is expressed as a percentage of uptime, with more nines indicating higher availability. For example:
  - 99% availability means 3.65 days of downtime per year.
  - 99.999% availability means just 5.26 minutes of downtime per year.

- **Increasing Availability**: Achieving higher availability generally requires adding redundancy, such as more servers and data centers, which increases costs. 

- **Single Point of Failure**: A single EC2 instance can be a single point of failure, even if other components like Amazon S3 and DynamoDB are highly available.

- **Redundancy**: To mitigate single points of failure, deploy additional instances in different Availability Zones. This helps protect against physical server, rack, or data center failures.

- **Replication Challenges**: With multiple instances, you need to automate the replication of configuration files, software patches, and applications to ensure consistency.

- **Customer Redirection**: Use DNS or load balancers to manage client connections to multiple servers. Load balancers are preferable as they handle health checks and load distribution without DNS propagation delays.

- **High Availability Types**:
  - **Active-Passive**: Only one instance is active at a time, which simplifies stateful applications but limits scalability.
  - **Active-Active**: Both instances are active, allowing for better scalability but requires handling session data across servers, which is more complex for stateful applications.


##### 1.1.6.4. Selecting between ELB types



### Traffic Routing with Elastic Load Balancing

- **Load Balancing Concept**: Distributes incoming application traffic across multiple EC2 instances to ensure even load distribution and high availability.
- **ELB Types**:
  - **Application Load Balancer (ALB)**: Operates at Layer 7, ideal for HTTP/HTTPS traffic, and supports advanced features like user authentication and TLS offloading.
  - **Network Load Balancer (NLB)**: Operates at Layer 4, suitable for TCP/UDP traffic, and provides low latency with features like source IP preservation and static IP support.
  - **Gateway Load Balancer (GLB)**: Functions at Layer 3 and Layer 4, designed for deploying and managing third-party virtual appliances, offering high availability and monitoring.
- **Health Checks**: ELB uses TCP or HTTP/HTTPS health checks to monitor the health of backend EC2 instances, ensuring traffic is routed only to healthy instances.
- **Connection Draining**: Ensures existing connections are completed before terminating instances, avoiding disruptions during scaling operations.
- **Scalability and High Availability**: ELB automatically scales with incoming traffic and is highly available when targets are spread across multiple Availability Zones.
- **ELB Components**: Consists of rules, listeners, and target groups, which help in defining how traffic should be routed to backend instances.

- **Selecting Between ELB Types:**

| Feature                       | ALB                 | NLB                 | GLB                          |
|-------------------------------|---------------------|---------------------|------------------------------|
| **Load Balancer Type**        | Layer 7             | Layer 4             | Layer 3 gateway and Layer 4  |
| **Target Type**               | IP, instance, Lambda| IP, instance, ALB   | IP, instance                 |
| **Protocol Listeners**        | HTTP, HTTPS         | TCP, UDP, TLS       | IP                           |
| **Static IP and Elastic IP Address** | Yes          | Yes                 | No                           |
| **Preserve Source IP Address** | Yes                 | Yes                 | Yes                          |
| **Fixed Response**            | Yes                 | No                  | No                           |
| **User Authentication**       | Yes                 | No                  | No                           |


##### 1.1.6.5. Amazon EC2 Auto Scaling

- **Capacity Issues**: Auto Scaling addresses capacity issues by adding or removing servers to handle varying traffic loads, improving system availability and performance.

- **Scaling Types**: 
  - **Vertical Scaling**: Increasing the power of a single server (not covered here).
  - **Horizontal Scaling**: Adding or removing multiple instances to handle load, especially in stateless, active-active systems.

- **Traditional vs. Auto Scaling**:
  - **Traditional Scaling**: Involves provisioning enough servers for peak traffic, often leading to wasted resources during low traffic.
  - **Auto Scaling**: Adjusts the number of EC2 instances based on real-time demand, optimizing cost and performance.

- **Auto Scaling Features**:
  - **Automatic Scaling**: Adjusts capacity based on demand.
  - **Scheduled Scaling**: Scales based on pre-defined schedules.
  - **Fleet Management**: Replaces unhealthy instances automatically.
  - **Predictive Scaling**: Uses ML to forecast and optimize instance numbers.
  - **Purchase Options**: Supports multiple instance types and pricing models.

- **Integration with ELB**: Elastic Load Balancer (ELB) works with Auto Scaling to ensure new instances are healthy before routing traffic to them.

- **Components**:
  - **Launch Templates/Configurations**: Define instance parameters for scaling. Templates support versioning, while configurations do not.
  - **Auto Scaling Groups**: Specify where instances are deployed and their types (On-Demand or Spot Instances).
  - **Scaling Policies**: Manage when to scale based on metrics and alarms from CloudWatch. Types include Simple, Step, and Target Tracking Scaling Policies.

