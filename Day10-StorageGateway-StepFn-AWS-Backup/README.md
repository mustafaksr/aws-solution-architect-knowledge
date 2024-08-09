# 10. Day 10 - AWS Storage Gateway Deep Dive: Volume Gateway, AWS Storage Gateway Deep Dive: Amazon S3 File Gateway, Introduction to Step Functions, AWS Backup Primer 

## 10.1 AWS Storage Gateway Deep Dive: Volume Gateway

### 10.1.1. Hybrid Cloud and AWS Storage Gateway Overview

  - **Hybrid Cloud Benefits**: Understand the advantages of using hybrid cloud storage, such as scalability, cost-efficiency, and flexibility in managing data across on-premises and cloud environments.
  - **AWS Storage Gateway Overview**: Learn about AWS Storage Gateway as a service that enables on-premises applications to access cloud storage, bridging the gap between on-premises data centers and the AWS cloud.
  - **Storage Gateway Architecture**: Gain insights into the architecture of AWS Storage Gateway, including its deployment options, which can be implemented as a virtual machine, hardware appliance, or cloud-based instance.
  - **Types of AWS Storage Gateway**: Differentiate between the three main types of Storage Gateway:
    - **File Gateway**: For file-based storage access using SMB or NFS protocols.
    - **Volume Gateway**: Provides block storage for applications using iSCSI.
    - **Tape Gateway**: For tape-based backup workflows, integrating with S3 and Glacier.
  - **Volume Gateway Functionality**: Learn how Volume Gateway specifically provides cloud-backed iSCSI block storage volumes for on-premises applications, enabling data replication to AWS.
  - **Deployment Flexibility**: Understand how Volume Gateway can be deployed in cache mode (storing data locally with backups to AWS) or stored mode (keeping the primary data in AWS with a local cache).
  - **Pricing Models**: Compare the pricing models of different AWS Storage Gateway types, and locate current pricing information for Volume Gateway to make cost-effective decisions.
  - **Practical Application**: By the end of the section, be equipped to list the benefits, describe the architecture, differentiate gateway types, and understand the cost implications of using AWS Storage Gateway in hybrid cloud environments.

### 10.1.2. Cloud Computing and Hybrid Cloud Benefits

  - **Low-Latency Access**: Deliver low-latency data access to on-premises applications while leveraging AWS's cloud capabilities.
  - **Broad Cloud Services**: AWS offers a wide range of cloud computing services including compute, storage, database, analytics, IoT, and more.
  - **Workload Flexibility**: Some workloads require local data access or specific compliance needs that make hybrid cloud a practical solution.
  - **Hybrid Cloud Use Cases**:
  - Existing on-premises applications needing cloud scalability and resources.
  - Fast, local data access combined with cloud compute and analytics.
  - Legacy security and compliance processes needing integrated cloud management.
  - Multiple physical locations requiring reliable connectivity and simplified maintenance.
  - **Incremental Digital Transformation**: Hybrid cloud allows gradual integration of AWS services to accelerate digital transformation.
  - **Increased Productivity**: Improves IT and developer productivity with supportive infrastructure, services, and tools.
  - **Differentiated Services**: Use AWS services to enhance and deliver responsive operations quickly.
  - **Hybrid Cloud Storage**:
  - Use on-premises data while storing it durably in AWS.
  - Benefit from unlimited storage, compliance certifications, and multilayered security.
  - **Comprehensive Hybrid Services**: AWS provides services to build hybrid architectures, including compute, networking, storage, and security.
  - **AWS Storage Gateway**: Enables hybrid cloud storage solutions, allowing on-premises data centers to utilize AWS storage and services like durable low-cost storage, security, and analytics.


### 10.1.3. Hybrid Cloud Storage with AWS Storage Gateway

  - **AWS Storage Gateway Overview**: Facilitates hybrid cloud storage, integrating on-premises environments with AWS services like Amazon S3, Amazon EBS, and AWS Backup.
  - **Data Integration**: On-premises applications can connect to AWS Cloud storage, enabling data backup, archiving, and tiering for compliance and business needs.
  - **Standard Protocol Support**: Uses protocols like NFS, SMB, iSCSI, and iSCSI VTL for seamless connection to AWS storage services, converting data to Amazon S3 or other AWS storage formats.
  - **Low-Latency Access**: Provides low-latency access to data through local caching and full-volume copies, ensuring efficient data processing and retrieval.
  - **Optimized Data Transfers**: Uses techniques like multi-part management, automatic buffering, delta transfers, and data compression to reduce transfer costs and improve efficiency.
  - **Security and Compliance**: Supports data encryption at rest and in transit, integrates with IAM for access control, and complies with security certifications. AWS KMS is used for managing encryption keys.
  - **High Availability on VMware**: Integrated with VMware vSphere HA, ensuring automatic recovery from service interruptions within 60 seconds in both on-premises and VMware Cloud on AWS environments.
  - **Types of Storage Gateways**:
    - **S3 File Gateway**: Provides file access to Amazon S3, ideal for backups, archives, and data lakes.
    - **FSx File Gateway**: Enables access to Amazon FSx for on-premises file shares, optimizing performance with local caching.
    - **Tape Gateway**: Replaces physical tape infrastructure with a virtual tape library, utilizing Amazon S3 for storage.
    - **Volume Gateway**: Offers block storage volumes with snapshots and AWS Backup integration, running in cached or stored modes.
  - **Deployment Options**: Available as VM appliances, hardware appliances, or EC2 instances, deployable on-premises or in AWS Cloud, with connection options via public internet or Direct Connect.
  - **Use Cases**: Ideal for moving backups to the cloud, shifting on-premises storage to cloud-backed shares, and ensuring low-latency access for on-premises applications to cloud data.


### 10.1.4. Store and Access Data with Volume Gateway

  - **Volume Gateway Overview**: A hybrid cloud block storage solution using the iSCSI protocol with local caching, designed for on-premises applications.
  - **Operating Modes**:
    - **Cached Mode**: Stores primary data in Amazon S3, with frequently accessed data cached locally.
    - **Stored Mode**: All data is stored locally, with snapshots backed up to Amazon S3 for disaster recovery.
  - **Use Cases**:
    - **Hybrid Cloud File Services**: Integrates with Windows/Linux file servers for scalable storage and cloud recovery.
    - **Backup and Disaster Recovery**: Uses EBS snapshots and cached volume clones for backup and DR strategies.
    - **Application Data Migration**: Facilitates migration of on-premises data to Amazon EBS for use with EC2 applications.
  - **Key Features**:
    - **iSCSI Connectivity**: Industry-standard protocol for communication between clients and storage devices.
    - **Local Cache**: Reduces latency by storing frequently accessed data on-premises.
    - **Incremental Snapshots**: Captures only changed blocks, minimizing storage costs.
    - **Centralized Backup Management**: AWS Backup integration for managing and monitoring backups across multiple gateways.
  - **Snapshot Management**: Snapshots are stored as Amazon EBS snapshots in Amazon S3, with restore options for both on-premises and cloud environments.
  - **Deployment Options**: Volume Gateway can be deployed on VMware ESXi, KVM, Hyper-V, Amazon EC2, or physical appliances.
  - **Backup Scheduling**: AWS Backup and Storage Gateway provide tools for automating backup scheduling, retention policies, and monitoring.
  - **Cost Optimization**: Volume Gateway reduces on-premises storage needs, offering cost-effective cloud storage solutions with scalability.

### 10.1.5. Pricing Model


  - **Pay-as-you-go**: You are charged only for what you use, based on storage, data transfer, and requests.
  - **Three billing elements**:
    - **Storage**: Charges depend on the type of storage (e.g., Amazon S3, EBS) and its configuration.
    - **Requests**: Fees are incurred for data operations through the gateway, including data ingest into AWS.
    - **Data transfer**: Costs are associated with transferring data out of AWS to your on-premises gateway appliance.
  - **Volume storage pricing**:
    - **$0.023 per GB-month** for volume storage.
    - **Snapshot storage** is billed as Amazon EBS snapshots.
  - **Request pricing**:
    - **$0.01 per GB** of data written to AWS, capped at **$125.00 per gateway per month**. The first 100 GB per account is free.
    - **EBS snapshot and volume deletes** are free of charge.
  - **Data transfer into Storage Gateway**:
  - Free from the gateway appliance (**$0.00 per GB**).
  - **Data transfer out from Storage Gateway**:
  - To on-premises gateway appliance:
      - **$0.09 per GB** for the first 9.999 TB/month.
      - **$0.085 per GB** for the next 40 TB/month.
      - **$0.07 per GB** for the next 100 TB/month.
      - **$0.05 per GB** for over 150 TB/month.
    - **$0.02 per GB** to a gateway appliance in Amazon EC2.
  - **Hardware appliance costs**:
    - **5 TB cache**: **$12,360**.
    - **12 TB cache**: **$18,499**.
  - **Pricing is region-specific** and subject to change, with the provided example based on the US West (Oregon) Region as of 04/20/2022.
  

### 10.1.6. Planning and Designing a Volume Gateway Deployment

  - **Volume Gateway Deployment**: Deploy as an on-premises appliance or Amazon EC2 instance, providing iSCSI mount targets, caching data locally, and securely transferring data to AWS.
  - **Volume Gateway Modes**:
    - **Cached Volume**:
    - Uses Amazon S3 as primary storage.
    - Caches frequently accessed data locally.
    - Supports up to 32 volumes (1 GiB to 32 TiB each) for a total of 1,024 TiB.
    - Ideal for custom file shares, application data migration, and scenarios requiring low-latency access to subsets of large datasets.
    - **Stored Volume**:
    - Stores primary data locally with asynchronous backups to Amazon S3.
    - Supports up to 32 volumes (1 GiB to 16 TiB each) for a total of 512 TiB.
    - Suitable for block storage backups, cloud-based disaster recovery, and migrations needing full, low-latency data access.
  - **Deployment Options**:
    - **On Premises**:
    - Deploy via VM (VMware ESXi, Microsoft Hyper-V, Linux KVM) or physical hardware appliance.
    - **On AWS**:
    - Deploy using an AMI in Amazon EC2, suitable for proof of concept, disaster recovery, or data mirroring.
  - **Gateway Appliance Sizing**:
  - Consider total volume capacity and workload requirements.
  - Allocate local disks for cache storage (minimum 150 GiB) and upload buffer storage.
  - Deploy additional appliances to increase throughput as needed.
  - **Network Connectivity**:
  - Gateway connects to AWS via public endpoints, VPC endpoints, or FIPS-compliant endpoints for secure data movement.
  - Requires specific network ports (e.g., TCP 443 for AWS communication, TCP 3260 for iSCSI).
  - **Volume Creation and Management**:
  - Create volumes via AWS Management Console or programmatically via API/SDK.
  - Mount volumes as iSCSI devices to on-premises servers.
  - **Snapshot Management**:
  - Take incremental, compressed backups as Amazon EBS snapshots.
  - Snapshots can be restored to on-premises volumes or used to create new Amazon EBS volumes in EC2.
  - **Regional Considerations**:
  - Ensure gateway and Storage Gateway services are supported in your desired AWS Regions.
  - Choose a Region before deployment and use cross-Region copy for backup in other AWS Regions.


### 10.1.7. Demonstration: Deployment of the Volume Gateway

  - **AWS Storage Gateway**: Demonstrates setting up a hybrid storage solution using Volume Gateway in cached mode on an Amazon EC2 instance.
  - **Step 1: Set up Gateway**
  - Deploy the gateway appliance on-premises or on AWS.
  - Launch and configure a cloud-based software appliance on Amazon EC2.
  - Select "Create gateway" in the Storage Gateway console to start the setup wizard.
  - Name the gateway (e.g., `volumecache1`), choose the time zone, and set up the gateway type as Volume Gateway in cached mode.
  - **Platform Options**:
  - Select Amazon EC2 as the host platform and launch an instance.
  - Use at least an `m5.xlarge` instance type, select the appropriate VPC, and configure network settings.
  - Add two Amazon EBS volumes (150 GiB each) for the local cache store and upload buffer.
  - Configure security groups to allow HTTP and iSCSI access.
  - Review and launch the EC2 instance, then copy its IP address for further configuration.
  - **Step 2: Connect to AWS**
  - Connect the gateway appliance to the Storage Gateway service using service endpoints, connection options, and the EC2 instance's IP address.
  - **Step 3: Review and Activate**
  - Review and confirm the gateway settings.
  - Activate the gateway to complete the setup.
  - **Step 4: Configure Gateway**
  - Configure cache storage and upload buffer (minimum of 150 GiB each).
  - Optionally configure CloudWatch log groups, alarms, and tags.
  - Successful gateway creation is confirmed, displaying status and gateway type in the Storage Gateway console.
  - **Volume Gateway Deployment Continuation**:
  - Create a new volume associated with the gateway, specify its capacity, and identify an iSCSI target.
  - Mount the volume on a client using iSCSI configuration.
  - Configure CHAP authentication for security, recommended to protect against man-in-the-middle attacks.


### 10.1.8. Reads, Writes, and Updates

  - **Volume Gateway Data Transfers**: Routes block storage data through on-premises appliances to/from SAN or virtual volumes, encrypted via SSL/HTTPS.
  - **Data Security**: Data is compressed, encrypted in transit and at rest, using S3-SSE keys or optionally AWS KMS managed keys.
  - **Cached Volume - Reads**: 
  - Data is served locally if present in the cache, eliminating latency.
  - If not cached, data is retrieved from Amazon S3, decompressed, stored locally, and served to the application.
  - Acts as a read-through cache: data not in cache is retrieved, cached, and served to the application.
  - **Stored Volume - Reads**:
  - All data is stored locally on the SAN or virtual appliance, ensuring zero latency for reads.
  - Ideal for workloads sensitive to latency requiring immediate data access.
  - **Cached Volume - Writes**:
  - Data is first written to a local cache, then compressed and encrypted before moving to the upload buffer.
  - Write-back cache ensures low latency and quick local acknowledgment before data is transferred to AWS.
  - **Stored Volume - Writes**:
  - Data is written directly to the local disk and acknowledged immediately.
  - During snapshots, data is compressed, encrypted, and moved to AWS via the upload buffer.
  - **iSCSI Protocol**:
  - IP-based protocol providing block-level storage access, using port 3260 for data transfer.
  - iSCSI initiators (clients) send requests to iSCSI targets (servers), which manage storage on remote servers.
  - **iSCSI Initiator**:
  - Client component that sends storage requests; supported only as software in Storage Gateway.
  - **iSCSI Target**:
  - Server component responding to initiator requests; each volume is exposed as a target.
  - Each iSCSI target should only connect to one iSCSI initiator.
  - **Volume Management**: Covers connecting volumes to iSCSI initiators, configuring settings, and managing CHAP authentication.


### 10.1.9. Working with Volumes

  - **Volume Gateway Capacity**: Each Volume Gateway can support up to 32 volumes, which are accessible for I/O operations through Storage Gateway.

  - **Adding Volumes**: After activating the Volume Gateway, you can add volumes associated with it. Cached volumes and snapshots are stored in Amazon S3, but cannot be accessed directly via the S3 console or API.

  - **Volume Recovery Point**: A volume recovery point is a consistent point in time for a volume, from which you can create a snapshot or clone a volume for data recovery.

  - **Volume Cloning**: Cloning a volume from a recovery point is faster and more cost-effective than creating an Amazon EBS snapshot, offering rapid recovery to a gateway on premises.

  - **EBS Snapshots**: Snapshots capture a point-in-time copy of a volume. Initially, snapshots are in a "Pending" status until all data is uploaded, after which they become "Available."

  - **Snapshot Efficiency**: For cached volumes, only data that has changed since the last snapshot is stored. Deleting a snapshot removes only data not required by other snapshots.

  - **Creating Volumes from Snapshots**: You can create a new volume from an existing EBS snapshot, which can then be mounted as an iSCSI device to an application server.

  - **Expanding Volume Size**: Automatic resizing is not supported. To expand a volume, either create a new, larger volume from a snapshot or clone the cached volume to a larger size.

  - **Volume Management**: The lesson covered creating, managing, and restoring volumes, and provided a foundation for more advanced gateway and volume management tasks.


### 10.1.10. Managing AWS Storage Gateway Volumes


#### Volume Status
1. **AVAILABLE**: The volume is ready for use. This is the normal operating status.
2. **BOOTSTRAPPING**: The gateway is synchronizing data with AWS. Usually, no action is needed as it transitions to AVAILABLE.
3. **CREATING**: The volume is being created and is not yet available for use.
4. **DELETING**: The volume is in the process of being deleted. This status is transitional.
5. **IRRECOVERABLE**: The volume has encountered an unrecoverable error. Refer to troubleshooting guides for actions.
6. **PASS THROUGH**: Local data is not yet synced with AWS. Data remains in cache until syncing starts.
7. **RESTORING**: The volume is being restored from a snapshot. Applies only to stored volumes.
8. **RESTORING PASS THROUGH**: Restoration from a snapshot encountered an upload buffer issue. Applies to stored volumes.
9. **UPLOAD BUFFER NOT CONFIGURED**: The volume cannot be created or used due to missing upload buffer configuration.

##### Volume Status Table
| Status                  | Meaning                                                                                   |
|-------------------------|-------------------------------------------------------------------------------------------|
| AVAILABLE               | The volume is available for use.                                                          |
| BOOTSTRAPPING           | Synchronizing data with AWS; transitions to AVAILABLE.                                    |
| CREATING                | The volume is being created.                                                               |
| DELETING                | The volume is being deleted.                                                               |
| IRRECOVERABLE           | Volume has an error from which it cannot recover.                                          |
| PASS THROUGH            | Local data out of sync with AWS; data in cache until Bootstrapping status.                 |
| RESTORING               | Restoring the volume from a snapshot.                                                      |
| RESTORING PASS THROUGH  | Encountered issues while restoring from snapshot.                                          |
| UPLOAD BUFFER NOT CONFIGURED | Volume cannot be used due to missing upload buffer.                                      |

#### Attachment Status
1. **ATTACHED**: The volume is connected to a gateway.
2. **DETACHED**: The volume is not connected to any gateway.
3. **DETACHING**: The volume is being detached from a gateway.

##### Attachment Status Table
| Status      | Meaning                                    |
|-------------|--------------------------------------------|
| ATTACHED    | Volume is attached to a gateway.           |
| DETACHED    | Volume is not attached to a gateway.       |
| DETACHING   | Volume is in the process of being detached.|

#### Volume Actions
  - **Creating Snapshots**: Capture a point-in-time copy of a volume. 
  - **Editing Snapshot Schedules**: Modify the frequency and timing of automated snapshots. 
  - **Configuring CHAP Authentication**: Secure iSCSI connections.
  - **Connecting to Client (iSCSI Initiator)**: Enable volume access by clients.
  - **Adding Tags**: Attach optional metadata to volumes.

##### Working with Snapshots
1. **Creating One-Time Snapshots**: Take an immediate backup by selecting "Create EBS snapshot" in the Actions menu.
2. **Editing Snapshot Schedule**: Adjust frequency and timing for automatic snapshots. For stored volumes, a default schedule is required but editable.

#### Managing Bandwidth
1. **Rate Limits**: Control network bandwidth used by the gateway with minimum rates of 100 Kib/s for downloads and 50 Kib/s for uploads.
2. **Bandwidth Rate Limit Schedule**: Apply limits based on a defined schedule.

#### Key Takeaways
- Regularly monitor volume and attachment status for operational integrity.
- Manage snapshots to ensure data protection and recovery.
- Adjust bandwidth settings to control network usage and optimize performance.




### 10.1.11. Optimizing Cost and Performance




1. **Volume and Snapshot Management:**
     - **Billing:** You are billed only for the amount of data stored, not the volume size. 
     - **Deleting Volumes:** Deleting a volume doesn’t automatically delete associated snapshots.
     - **Deleting Snapshots:** Regularly delete snapshots older than 30 days to reduce costs. Only data exclusively referenced by a snapshot is deleted.
     - **Impact:** Deleting snapshots doesn’t affect volumes or future snapshots; deleting a volume doesn’t affect its snapshots.

2. **AWS Backup Plan Configuration:**
     - **Automate Backups:** Use AWS Backup for centralized backup management and automation. Set up backup plans with customizable schedules and retention rules.
     - **Integration:** AWS Backup integrates within the Storage Gateway console for managing backup policies.

3. **Performance Recommendations:**
     - **iSCSI Settings Optimization:**
       - **MaxReceiveDataSegmentLength:** Set to 256 KiB.
       - **FirstBurstLength:** Set to 256 KiB.
       - **MaxBurstLength:** Set to 1 MiB.
     - **Separate Physical Disks:**
       - **Avoid Sharing:** Don’t use the same physical disk for upload buffer and cache storage. For VMware ESXi, choose separate data stores for VM files and virtual disks.
     - **Volume Configuration:**
       - **High Throughput:** For high-throughput applications, use separate gateways to avoid throughput reduction. Measure throughput using ReadBytes and WriteBytes metrics.

#### Summary Table

| **Topic**                | **Best Practice**                                                                 | **Details**                                                               |
|--------------------------|-----------------------------------------------------------------------------------|---------------------------------------------------------------------------|
| Volume & Snapshot Management | Delete old snapshots and volumes to optimize storage costs.                     | Only delete data exclusively referenced by snapshots.                     |
| AWS Backup Plan          | Automate backup policies with AWS Backup for centralized management.             | Set backup schedules, retention, and expiration rules.                    |
| iSCSI Settings           | Optimize iSCSI settings for better I/O performance.                               | Use 256 KiB for MaxReceiveDataSegmentLength and FirstBurstLength, 1 MiB for MaxBurstLength. |
| Physical Disk Management | Use separate physical disks for upload buffer and cache storage.                 | Avoid using the same disk for different types of storage.                 |
| Volume Configuration     | Use separate gateways for high-throughput applications to avoid throughput issues. | Monitor volume throughput with ReadBytes and WriteBytes metrics.         |

This summary should help you understand and apply best practices for optimizing both cost and performance with AWS Storage Gateway.



### 10.1.12. Shared Responsibility Model


1. **Shared Responsibility**: Security and compliance responsibilities are divided between AWS and the customer.
2. **AWS’s Responsibility**: AWS is responsible for security **of** the cloud, which includes:
   - Infrastructure security (hardware, software, networking, and facilities).
   - Protecting the cloud's underlying infrastructure.
   - Maintaining physical security of data centers.
3. **Customer’s Responsibility**: Customers are responsible for security **in** the cloud, including:
   - Managing and securing data hosted on AWS services.
   - Configuring and managing access controls and permissions.
   - Implementing proper security measures for applications and data.
4. **Storage Gateway Compliance**: Follows the same shared responsibility model:
   - AWS secures the infrastructure running the Storage Gateway service.
   - Customers ensure the security of their content and configurations within the Storage Gateway.
5. **Cloud Security Priority**: AWS prioritizes cloud security to ensure the safety and integrity of its services.
6. **IAM and Permissions**: Learn about AWS Identity and Access Management (IAM) to manage user permissions and access control.
7. **Customer Engagement**: Customers must actively engage in securing their applications, data, and compliance measures.
8. **Infrastructure vs. Data Security**: Distinguish between securing the AWS infrastructure and securing the data you store and manage on AWS.

#### Shared Responsibility Model Overview

| Responsibility | AWS                                        | Customer                          |
|----------------|--------------------------------------------|-----------------------------------|
| **Infrastructure Security** | Yes                                        | No                                |
| **Data Security**           | No                                         | Yes                               |
| **Physical Security**       | Yes                                        | No                                |
| **Access Control**          | No                                         | Yes                               |
| **Compliance**              | Yes                                        | Yes                               |





| Responsibility         | **IaaS (Infrastructure as a Service)**                  | **PaaS (Platform as a Service)**                      | **SaaS (Software as a Service)**                       |
|------------------------|----------------------------------------------------------|-------------------------------------------------------|--------------------------------------------------------|
| **Infrastructure Security** | AWS (e.g., physical servers, networking, virtualization) | AWS (e.g., underlying infrastructure, runtime environment) | AWS (e.g., infrastructure, platform environment)      |
| **Data Security**         | Customer (e.g., data stored on VMs, databases)          | Customer (e.g., data within applications, databases) | Customer (e.g., data within the application)          |
| **Application Security**  | Customer (e.g., applications running on VMs)            | Customer (e.g., applications developed and deployed) | AWS (e.g., application security, patching)            |
| **Access Control**        | Customer (e.g., IAM policies, network security groups)  | Customer (e.g., application-level access controls)   | AWS (e.g., user authentication, application permissions) |
| **Compliance**            | Shared (e.g., AWS maintains infrastructure compliance)  | Shared (e.g., AWS ensures platform compliance)       | Shared (e.g., AWS and customer ensure compliance)     |
| **Patch Management**      | Customer (e.g., patching VMs, applications)            | AWS (e.g., platform updates and patches)             | AWS (e.g., application updates and patches)           |
| **Physical Security**     | AWS (e.g., data center security)                        | AWS (e.g., data center security)                      | AWS (e.g., data center security)                      |



### 10.1.13. Granting Permissions in AWS Storage Gateway



1. **Credentials Required**: 
   - Access to AWS Storage Gateway requires credentials for authentication.
   - Credentials must have permissions for accessing resources like gateways, file shares, volumes, or tapes.

2. **Primary and Sub-Resources**:
   - The main resource is the gateway.
   - Sub-resources such as volumes or iSCSI targets are associated with a gateway and do not exist independently.

3. **Resource Connectivity**:
   - The gateway needs to connect with other AWS resources like Amazon S3 buckets or Amazon EBS snapshots.
   - The gateway appliance authenticates to AWS and manages volume data transfer.

4. **IAM Overview**:
   - AWS Identity and Access Management (IAM) controls access to AWS resources.
   - IAM manages authentication (who can sign in) and authorization (what permissions they have).

5. **IAM Identities**:
     - **AWS Account Root User**: Unrestricted access; recommended only for initial IAM user creation.
     - **IAM User**: Can sign into AWS with a name and password; can have up to two access keys.
     - **IAM Group**: Simplifies permission management by grouping users.
     - **IAM Role**: Provides temporary credentials for a session and can be assumed by different entities.

6. **IAM Policies**:
   - Policies define permissions for actions and are checked during authorization.
   - Policies can be attached to users, groups, or roles.
   - Types include identity-based policies (within a specific account) and resource-based policies (cross-account access).

7. **Principle of Least Privilege**:
   - Always grant only the permissions necessary to perform a task.

8. **Sample IAM Policy**:
   - Allows `List*` and `Describe*` actions on resources but does not permit state-changing actions (e.g., `DeleteGateway`, `ActivateGateway`).

9. **Resource Ownership**:
   - The resource owner is the AWS account that created the resource, which authenticates the request.

10. **Role Assumption**:
    - A gateway assumes a role with an IAM policy that grants specific actions.

11. **Action Permissions**:
      - **ActivateGateway**: `storagegateway:ActivateGateway` - Required for Gateway.
      - **AddCache**: `storagegateway:AddCache` - Required for Gateway.
      - **AddUploadBuffer**: `storagegateway:AddUploadBuffer` - Required for Gateway.
      - **CreateSnapshot**: `storagegateway:CreateSnapshot` - Required for Gateway and Volume.

12. **Policy Management**:
    - Attach policies to IAM identities or resources to define what actions are allowed.

13. **API Operations**:
    - Specific API operations require corresponding IAM permissions, such as activating or managing a gateway.

14. **Reference Guide**:
    - For a complete list of Storage Gateway API operations and required permissions, consult the Storage Gateway API Reference Guide.

#### Specific Places

| API Operation     | Required Permissions     | Resources                  |
|-------------------|---------------------------|----------------------------|
| ActivateGateway   | `storagegateway:ActivateGateway` | Gateway                    |
| AddCache          | `storagegateway:AddCache` | Gateway                    |
| AddUploadBuffer   | `storagegateway:AddUploadBuffer` | Gateway                    |
| CreateSnapshot    | `storagegateway:CreateSnapshot` | Gateway, Volume            |



### 10.1.14. Protecting Your Data



AWS offers a comprehensive set of services and tools to ensure your data is protected. Key aspects include:

1. **Volume Gateway Protection**:
   - Data encryption in transit and at rest.
   - CHAP authentication for secure access.
   - Federal Information Processing Standards (FIPS) support.
   - Multiple protocol options and secure storage in Amazon S3.

2. **Data Encryption**:
   - Data in transit between gateway appliances and AWS storage is encrypted with SSL/TLS.
   - Data stored in Amazon S3 is encrypted server-side with either:
     - Amazon S3 server-side encryption (S3-SSE) (default)
     - AWS Key Management Service (AWS KMS)
   - EBS snapshots are encrypted at rest using AES-256.

3. **CHAP Authentication**:
   - Provides protection against man-in-the-middle and playback attacks.
   - Mutual CHAP is used, where both initiator and target authenticate each other.
   - CHAP configuration is optional but recommended for secure data exchange.

4. **Access to Volume Data**:
   - Volume Gateway uses an Amazon S3 service bucket, not a customer bucket.
   - The content of the service bucket is not accessible from the Amazon S3 console or APIs.

5. **Data Protection Best Practices**:
   - Use multi-factor authentication (MFA) with each account.
   - Communicate with AWS resources using SSL/TLS, with TLS 1.2 or later recommended.
   - Set up API and user activity logging with AWS CloudTrail.
   - Utilize AWS encryption solutions and default security controls.
   - For FIPS 140-2 validated cryptographic modules, use a FIPS endpoint.


| **Topic**                  | **Details**                                                                 |
|----------------------------|-----------------------------------------------------------------------------|
| **Volume Gateway Protection** | Data encryption, CHAP authentication, FIPS support, multiple protocol options, secure Amazon S3 storage. |
| **Data Encryption**        | SSL/TLS for data in transit, S3-SSE or AWS KMS for data at rest, AES-256 for EBS snapshots. |
| **CHAP Authentication**    | Protection against attacks, mutual CHAP recommended for secure data exchange. |
| **Access to Volume Data**  | Uses Amazon S3 service bucket, not accessible from S3 console or APIs. |
| **Data Protection Best Practices** | MFA, SSL/TLS, AWS CloudTrail logging, AWS encryption solutions, FIPS endpoints. |




### 10.1.15. AWS Monitoring and Alerting



1. **Integration with AWS Services**: 
     - **Storage Gateway** integrates with Amazon CloudWatch and AWS CloudTrail for monitoring and tracking.

2. **Systematic Monitoring**:
   - Essential for efficient resource use and understanding performance.

3. **Health and Performance Data**:
   - Captures logs and metrics to monitor gateway health and user activity.

4. **CloudWatch Monitoring**:
   - Consolidated view of metrics and alarms through the Storage Gateway management console.
   - Reports on data throughput, latency, and operations.

5. **Storage Gateway Metrics**:
     - **AvailabilityNotifications**: Number of availability-related notifications.
     - **CacheHitPercent**: Percentage of reads served from cache.
     - **CachePercentDirty**: Percentage of dirty cache.
     - **CachePercentUsed**: Cache storage usage.
     - **CloudBytesUploaded**: Bytes uploaded to AWS.
     - **CloudBytesDownloaded**: Bytes downloaded from AWS.
     - **HealthNotifications**: Number of health notifications.
     - **IoWaitPercent**: Time waiting on local disk responses.
     - **ReadBytes**: Bytes read from on-premises applications.
     - **WriteBytes**: Bytes written to on-premises applications.

6. **Metrics Analysis**:
   - Analyze **CloudBytesDownloaded** and **CloudBytesUploaded** for throughput.
   - Use **CacheHitPercent** for cache performance.
   - Monitor **CachePercentDirty** to evaluate latency impact.
     - **ReadBytes** and **WriteBytes** for throughput measurement.

7. **CloudWatch Log Group**:
   - Configure to monitor errors and set up notifications.

8. **CloudWatch Alarms**:
   - Set alarms for specific thresholds such as IO wait time, cache cleanliness, and notification counts.
   - Example alarms:
       - **High IO Wait**: `IoWaitPercent >= 20` for 3 datapoints in 15 minutes.
       - **Cache Percent Dirty**: `CachePercentDirty > 80` for 4 datapoints in 20 minutes.
       - **Availability Notifications**: `AvailabilityNotifications >= 1` for 1 datapoint in 5 minutes.
       - **Health Notifications**: `HealthNotifications >= 1` for 1 datapoint in 5 minutes.

9. **CloudTrail Logging**:
   - Logs API calls, capturing details such as user identity, event name, and timestamp.
   - Continuous delivery of events can be stored in Amazon S3.

10. **Storage Gateway Console**:
    - Provides health status and automatic connection reestablishment.

#### Metrics Table

| **Metric**                | **Description**                                                                 |
|---------------------------|---------------------------------------------------------------------------------|
| AvailabilityNotifications | Number of availability-related notifications sent by the volume.                |
| CacheHitPercent           | Percent of application read operations served from cache.                       |
| CachePercentDirty         | Volume's contribution to dirty cache percentage.                                |
| CachePercentUsed          | Volume's contribution to overall cache storage usage.                            |
| CloudBytesUploaded        | Total bytes uploaded to AWS during the reporting period.                        |
| CloudBytesDownloaded      | Total bytes downloaded from AWS during the reporting period.                    |
| HealthNotifications       | Number of health notifications sent by the volume.                              |
| IoWaitPercent             | Percent of time the gateway waits on local disk responses.                      |
| ReadBytes                 | Total bytes read from on-premises applications.                                 |
| WriteBytes                | Total bytes written to on-premises applications.                                |






##  10.2. AWS Storage Gateway Deep Dive: Amazon S3 File Gateway



###  10.2.1. AWS Cloud Computing and Hybrid Cloud Benefits



1. **Low-Latency Data Access**: Deliver low-latency data access to on-premises applications while leveraging AWS's cloud agility, economics, and security.
2. **Broad Set of Services**: AWS provides a wide range of cloud computing services, including compute, storage, database, analytics, networking, and more.
3. **Workload Diversity**: Cloud resources support various workloads from running enterprise applications to managing new applications.
4. **Hybrid Cloud Use Cases**:
     - **Existing On-Premises Applications**: Use cloud resources to scale applications that must remain on-premises or interact with local databases/files.
     - **Local Data Access**: Combine local data access with cloud compute and analytics engines.
     - **Security and Compliance**: Maintain existing security and compliance processes while utilizing cloud management and monitoring tools.
     - **Physical Locations Management**: Simplify maintenance and ensure reliable connectivity across multiple physical locations.
5. **Incremental Digital Transformation**: Accelerate digital transformation by gradually incorporating AWS infrastructure and services.
6. **Enhanced IT and Developer Productivity**: Improve productivity by providing infrastructure, services, and tools that support workflows and goals.
7. **Differentiated Services**: Create and deliver interactive and responsive operations faster using AWS services.
8. **Hybrid Cloud Storage**:
     - **Data Storage Types**: Use AWS Cloud for various storage types such as files, volumes, and tapes.
     - **Benefits**: Enjoy unlimited storage, compliance certifications, multilayered security, and AWS service possibilities.
9. **AWS Hybrid Cloud Services**:
     - **Service Range**: Includes compute, networking, storage, security, identity, data integration, management, monitoring, and operations.
     - **Storage Gateway**: Create hybrid cloud solutions integrating on-premises data centers with AWS cloud storage for durable, low-cost storage and advanced services.




| Benefit                         | Description                                                                                              |
|---------------------------------|----------------------------------------------------------------------------------------------------------|
| **Low-Latency Data Access**      | Fast data access to on-premises apps with cloud agility, security, and economics.                        |
| **Broad Set of Services**        | Includes compute, storage, database, analytics, networking, and more.                                     |
| **Workload Diversity**           | Supports various workloads, from existing enterprise apps to new application management.                  |
| **Existing On-Premises Applications** | Use cloud resources to scale and interact with on-premises applications.                                  |
| **Local Data Access**            | Combine local data access with cloud compute and analytics engines.                                        |
| **Security and Compliance**      | Maintain existing security/compliance while utilizing cloud management tools.                             |
| **Physical Locations Management** | Simplify management and ensure reliable connectivity across locations.                                    |
| **Incremental Digital Transformation** | Gradually incorporate AWS infrastructure for digital transformation.                                      |
| **Enhanced IT and Developer Productivity** | Improve productivity with supportive infrastructure, services, and tools.                                |
| **Differentiated Services**      | Faster creation and delivery of interactive and responsive operations using AWS services.                 |
| **Hybrid Cloud Storage**         | Utilize AWS for diverse storage types with benefits like unlimited storage and security.                  |
| **AWS Hybrid Cloud Services**    | Broad range of services including Storage Gateway for hybrid solutions integrating on-premises with AWS. |


###  10.2.1. AWS Storage Gateway Overview


AWS Storage Gateway integrates on-premises environments with AWS Cloud storage, offering various solutions to manage and process data across hybrid cloud setups.

#### Key Features and Benefits

1. **Storage Integration**: Connects to various AWS storage services such as Amazon S3, Amazon S3 Glacier, Amazon FSx, and Amazon EBS.
2. **Management and Monitoring**: Utilizes AWS services like IAM, KMS, CloudTrail, CloudWatch, and EventBridge for comprehensive management and monitoring.
3. **Low-Latency Access**: Provides local caching for low-latency data access with a Least Recently Used (LRU) algorithm.
4. **Optimized Data Transfers**: Uses multipart management, automatic buffering, delta transfers, and data compression to reduce costs and transfer volumes.
5. **Security and Compliance**: Ensures data encryption in transit and at rest, integrates with IAM for access control, and uses KMS for encryption key management.

#### Storage Gateway Types

| **Type**                | **Description**                                                                                                                                                  |
|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Amazon S3 File Gateway** | Provides native file access to Amazon S3 for backups, archives, and data lakes. Supports NFS and SMB protocols.                                         |
| **Amazon FSx File Gateway** | Optimizes access to Amazon FSx for Windows File Server, replacing on-premises NAS with cloud storage. Supports SMB protocol for file shares.          |
| **Tape Gateway**          | Replaces physical tape infrastructure with virtual tapes backed by Amazon S3, S3 Glacier Flexible Retrieval, or S3 Glacier Deep Archive for long-term retention. |
| **Volume Gateway**        | Provides block storage volumes via iSCSI with options for cached or stored modes. Integrates with AWS Backup and offers point-in-time snapshots.          |

#### Key Features

  - **Storage Protocols**: Uses NFS, SMB, iSCSI, and iSCSI VTL to connect local applications to AWS Cloud storage.
  - **Data Access**: Maintains a local cache for frequently accessed data, ensuring low-latency access.
  - **Data Transfer Optimization**: Implements multi-part management and compression to optimize data transfers.
  - **Deployment Options**: Available as a VM image for on-premises or EC2 instance in the AWS Cloud. Can be deployed as a hardware appliance or virtual appliance.

#### Deployment Considerations

  - **On-Premises**: Deploy as a VM appliance or hardware appliance.
  - **AWS Cloud**: Deploy as an EC2 instance.
  - **Network Connectivity**: Use public internet or AWS Direct Connect for secure connectivity.

#### Use Cases

  - **Backup and Archiving**: Migrate backups to the cloud with Tape Gateway or S3 File Gateway.
  - **File Access and Storage**: Utilize FSx File Gateway for Windows file shares or S3 File Gateway for cloud-native file storage.
  - **Block Storage**: Implement Volume Gateway for iSCSI block storage with local caching.

For further details, explore the [AWS Storage Gateway documentation](https://aws.amazon.com/storagegateway).


###  10.2.1. Amazon S3 File Gatewa



1. **S3 File Gateway Overview**
     - **Purpose**: Provides a file interface to store and retrieve files as objects in Amazon S3.
     - **Integration**: Part of AWS Storage Gateway, linking on-premises data to cloud storage.

2. **Primary Use Cases**
     - **Backing Up Data**:
     - Backup on-premises files, databases (e.g., SQL Server, Oracle), and logs.
     - Optimize storage with lifecycle policies and integrate with AWS services like ML and analytics.
     - **Archiving Long-Term Data**:
     - Efficiently archive large amounts of data to AWS, reducing costs and complexity of on-premises storage.
     - **Building Data Lakes**:
     - Centralize data into Amazon S3 for data lakes, processing with cloud-based tools, and reducing latency with a managed gateway cache.

3. **Features**
     - **Protocols**: Supports NFS (Linux) and SMB (Windows) protocols.
     - **Durability**: Files are stored durably in Amazon S3 with lifecycle management capabilities.
     - **Local Cache**: Provides a local cache for recent data access.
     - **Access Control**: Windows ACL support and bandwidth optimization for efficient data handling.

4. **Benefits**
     - **Cost Optimization**: Reduce on-premises storage costs and scale cloud storage easily.
     - **Data Protection**: Utilize Amazon S3 features like versioning, Object Lock, and Replication for data protection.
     - **Integration**: Compatible with various applications (e.g., SAP, SQL Server) and supports data restoration on-premises or in the cloud.

5. **How It Works**
     - **Gateway Appliance**: The S3 File Gateway appliance connects to S3 and provides file shares via NFS or SMB.
     - **File Mapping**: Files are stored in S3 with a one-to-one mapping, where file paths are part of the S3 object key.

6. **File Management**
     - **Native S3 Objects**: Files can be managed with S3 features like versioning and lifecycle policies.
     - **Audit Logs**: Publishes SMB file share user operations to CloudWatch.

7. **Cache Refresh**
     - **Automatic Updates**: Configurable cache refresh intervals between 5 minutes and 30 days.
     - **Manual Refresh**: Can be triggered using the RefreshCache API for immediate updates.

8. **Automation and Notifications**
     - **Cache Management**: Automates cache updates and metadata inventory.
     - **CloudWatch Integration**: Uses CloudWatch Events for notifications and triggers cloud workflows post-upload.



| **Feature**                    | **Description**                                                   |
|--------------------------------|-------------------------------------------------------------------|
| **Protocols**                  | NFS (Linux), SMB (Windows)                                        |
| **Data Durability**            | Stored in Amazon S3 with lifecycle management                     |
| **Local Cache**                | Local cache for recent data access                                |
| **Access Control**             | Windows ACL support, bandwidth optimization                       |
| **Backup Use Cases**           | Backup on-premises data, databases, and logs                      |
| **Archiving Use Cases**        | Archive long-term data to AWS, reducing on-premises storage costs |
| **Data Lakes Use Cases**       | Centralize data in Amazon S3 for processing and analytics          |
| **Cache Refresh**              | Automatic or manual refresh for up-to-date data                   |
| **Automation**                 | Manage cache and inventory, integrate with CloudWatch and Lambda  |



###  10.2.2. AWS Storage Gateway Pricing Model

1. **Pay-As-You-Go**: Charges are based on usage, including data transferred, storage used, and requests made.
2. **Storage Costs**:
   - Billed according to the type of storage used (e.g., Amazon S3, Amazon EBS).
   - Configuration impacts cost.
3. **Request Costs**:
   - Fees for data operations performed through the gateway, including data ingestion.
4. **Data Transfer Costs**:
   - Charges for data transferred out of the Storage Gateway service to your on-premises appliance.
5. **Hardware Appliance Costs**:
   - If using a hardware appliance, additional costs for the appliance itself.
   - Available through resellers or directly from CDW in the US and Canada.


| **Component**                       | **Pricing (USD)**                                             |
|-------------------------------------|---------------------------------------------------------------|
| **Storage**                         | Billed as Amazon S3 storage rates                             |
| **Data Written to AWS Storage**     | $0.01 per GB, up to $125.00 per gateway per month. First 100 GB per account is free |
| **File Storage in Amazon S3**       | Billed as Amazon S3 requests                                  |
| **Data Transfer into Storage Gateway** | $0.00 per GB                                                |
| **Data Transfer Out to On-Premises Gateway Appliance** |                  |
|  - Up to 9.999 TB per month          | $0.09 per GB                                                 |
|  - Next 40 TB per month              | $0.085 per GB                                                |
|  - Next 100 TB per month             | $0.07 per GB                                                 |
|  - Greater than 150 TB per month     | $0.05 per GB                                                 |
| **Data Transfer Out to Amazon EC2**  | $0.02 per GB                                                 |
| **Hardware Appliance**              | Available through resellers or directly from CDW (US and Canada) |

  - **Note**: Pricing is subject to change; for the latest information, refer to the [AWS Storage Gateway pricing page](https://aws.amazon.com/storagegateway/pricing/).


###  10.2.3. Planning and Designing an Amazon S3 File Gateway Deployment

1. **Deployment Overview**:
   - Storage Gateway provides a four-step approach for deploying hybrid storage solutions.
   - The solution can be implemented as on-premises hardware or a virtual appliance.

2. **Creating the S3 File Gateway**:
   - Host the gateway appliance and securely connect it to the Storage Gateway service.

3. **Deploying the Gateway Appliance**:
     - **On-Premises**:
     - Deploy using virtual appliances (VMware ESXi, Microsoft Hyper-V, KVM) or physical hardware appliances.
     - **On AWS**:
     - Deploy as an Amazon Machine Image (AMI) in Amazon EC2.

4. **Connectivity**:
     - **Public Endpoint**: Connects over the internet.
     - **VPC Endpoint**: Uses private connection via AWS Direct Connect or AWS VPN.
     - **FIPS 140-2 Compliant Endpoint**: For regulated workloads in AWS GovCloud (US).

5. **Gateway Identification**:
   - Use either a public or private IP address, or generate an activation key for secure connection.

6. **Configuring Local Disks**:
   - Allocate local disks as cache; recommend at least 20% of existing file store size.
   - Maximum supported cache size for VM is 64 TiB.
   - Use high-performance disks (SSDs or NVMe) for better throughput.

7. **Adding File Shares**:
   - Create file shares accessible via SMB for Windows and NFS for Linux.
   - Each file share is linked to a unique S3 bucket or prefix.

8. **Region and Storage Classes**:
   - Ensure Storage Gateway and hardware appliance support the desired AWS Region.
   - Choose from various S3 storage classes: S3 Standard, S3 Intelligent-Tiering, S3 Standard-IA, S3 One Zone-IA.
   - Default is S3 Standard; use lifecycle policies to transition objects to other storage classes.

9. **Working with Objects**:
   - Applications can access data stored in AWS for global workflows.
   - Refresh cache as needed for up-to-date results and adjust S3 bucket settings accordingly.

10. **Monitoring and Adjustments**:
    - Monitor S3 buckets and adjust versioning, lifecycle rules, and other settings as necessary.

11. **Deployment Demo**:
    - A demo of the deployment process will show how to connect and configure the S3 File Gateway.

#### Deployment Options

| Deployment Type | Description                                      |
|-----------------|--------------------------------------------------|
| On-Premises     | Virtual or physical appliance options            |
| On AWS          | Amazon EC2 instance using AMI                    |

#### Connectivity Options

| Endpoint Type               | Description                                   |
|-----------------------------|-----------------------------------------------|
| Public Endpoint             | Connects over the internet                    |
| VPC Endpoint                | Private connection via Direct Connect or VPN  |
| FIPS 140-2 Compliant Endpoint | For regulated workloads in AWS GovCloud (US)  |



###  10.2.4. Deployment of the Amazon S3 File Gateway


This demonstration covers the deployment of an Amazon S3 File Gateway using the AWS Storage Gateway service. The S3 File Gateway provides a hybrid storage solution by connecting on-premises applications with Amazon S3 cloud storage.

#### Steps to Deploy Amazon S3 File Gateway

1. **Access the AWS Storage Gateway Console**
   - Log in to the AWS Management Console.
   - Navigate to the Storage Gateway service.

2. **Set Up Gateway**
   - Select "Create gateway" from the Storage Gateway console.
   - Follow the wizard through four main setup steps:
       - **Gateway Settings:**
       - Provide a name for your gateway (e.g., `S3Demo`).
       - Choose the time zone for deployment.
       - **Gateway Options:**
       - Select the gateway type as `S3 File Gateway`.
       - **Platform Options:**
       - Choose `Amazon EC2` as the host platform.
       - Click "Launch instance" to deploy the EC2 instance.
       - Select at least `m5.xlarge` instance type.
       - Add necessary storage volumes (minimum of 150 GiB for local cache).
       - Configure security groups to allow access via SMB or NFS as needed.
       - **Gateway Appliance Confirmation:**
       - Confirm that the EC2 instance is running and obtain its IP address.

3. **Connect to AWS**
   - In the setup wizard, connect your gateway appliance to the Storage Gateway service using the EC2 instance's IP address and endpoint settings.

4. **Review and Activate**
   - Review the gateway settings.
   - Make any necessary edits and proceed to activation.

5. **Configure Gateway**
   - Configure the local cache store (at least 150 GiB recommended).
   - Set up CloudWatch log groups for monitoring.
   - Configure CloudWatch alarms to get notified of metric changes.
   - Optionally, add tags for categorization.

6. **Post-Deployment Tasks**
     - **Create a File Share:**
     - Define how data will be shared between on-premises applications and S3.
     - **Associate an S3 Bucket:**
     - Link your file share to an existing S3 bucket.
     - **Configure Storage Class:**
     - Set the storage class for new objects in S3.
     - **Join Active Directory:**
     - Optionally integrate with Active Directory for authentication.
     - **Mount and Use File Share:**
     - Mount the file share on your on-premises systems and start using it.

#### Key Points to Remember

| Step                | Description                                       | Key Details                                     |
|---------------------|---------------------------------------------------|-------------------------------------------------|
| **Gateway Settings**| Name the gateway and set time zone               | Example: `S3Demo`                               |
| **Platform Options**| Deploy on EC2, select instance type and storage   | Minimum 150 GiB EBS volume                      |
| **Security Groups** | Configure firewall rules for access               | SMB/NFS port settings                           |
| **CloudWatch**      | Set up monitoring and alarms                      | Log groups, alarms for performance tracking     |
| **File Share Setup**| Create and configure file shares                  | Associate with S3 bucket                        |



###  10.2.5. S3 File Gateway: Reads, Writes, and Updates

 

#### Reads
  - **Protocols**: Uses NFS or SMB protocols for read requests.
  - **Local Cache**: First checks the local cache for data. If not found, retrieves from S3.
  - **Data Transfer**: Fetches data from S3 using byte-range gets for better bandwidth utilization.
  - **Optimizations**:
  - Data is cached locally and pre-fetched based on access patterns.
  - For sequential reads (e.g., video files), the gateway pre-fetches data to reduce buffering and latency.

#### Writes
  - **Protocols**: Data is written to the local cache using NFS or SMB.
  - **Asynchronous Uploads**: Data is asynchronously compressed and uploaded to S3.
  - **Multipart Uploads**: Supports multipart parallel uploads for efficient data transfer, allowing pauses and resumptions.
  - **Data Compression**: Data is compressed before being uploaded to S3.

#### Write Updates
  - **Incremental Updates**: Only changed data (e.g., append D to file ABC) is uploaded to S3.
  - **New Versions**: The new data creates a new version of the object in S3.
  - **Optimizations**: Uses multipart uploads and copy put to minimize data transfer overhead.

#### Additional Information
  - **Encryption**: All data transfers between the gateway and AWS are encrypted with SSL and HTTPS.
  - **Object Encryption**: Objects are encrypted with SSE-S3 or optionally SSE-KMS.
  - **Local Cache Benefits**: Enhances performance with low-latency access and reduces outgoing data charges.

#### Key Points
| Aspect             | Description                                        |
|--------------------|----------------------------------------------------|
| **Protocols**      | NFS, SMB                                           |
| **Cache Usage**    | Local cache for low-latency access                 |
| **Data Transfer**  | Byte-range gets, SSL, HTTPS                        |
| **Write Mechanism**| Asynchronous, multipart parallel uploads           |
| **Update Mechanism**| Incremental updates, versioning                    |
| **Encryption**     | SSL for transfers, SSE-S3 or SSE-KMS for objects   |
| **Performance**    | Pre-fetching and read-ahead optimizations           |


###  10.2.6. Summary of Working with S3 Objects

1. **S3 File Gateway**:
   - Simplifies storing files as durable objects in Amazon S3 cloud storage.
   - Allows integration with on-premises systems for cloud storage.

2. **Amazon S3 Overview**:
     - **Object Storage**: Stores data as objects within buckets.
     - **Object Size**: Supports objects up to 5 TB.
     - **Metadata**: Includes file data and descriptive metadata.

3. **Buckets and Versioning**:
     - **Version-Enabled Buckets**: Create new object versions with each change.
     - **Delete Marker**: Marks objects as deleted but keeps all versions.

4. **Storage Classes**:
   - Multiple classes available to optimize data access, resilience, and cost.
   - Transition and expiration rules can be configured based on bucket settings, object tags, or sizes.

5. **Lifecycle Management**:
     - **Lifecycle Rules**: Automate the transition and expiration of objects.
     - **Costs**: Ingest or transition fees might apply based on the storage class.

6. **Replication Options**:
     - **Same-Region Replication (SRR)**: Replicates objects within the same AWS region.
     - **Cross-Region Replication (CRR)**: Replicates objects to different AWS regions.

7. **File Operations with S3 File Gateway**:
     - **File Modification**: Affects corresponding S3 objects by creating new versions.
     - **Metadata Upload**: Updates object metadata, creating additional versions if versioning is enabled.

8. **Common File Operations**:
     - **File Renaming**: Replaces existing objects and creates new ones.
     - **Deletion**: Marks objects deleted or creates new objects depending on versioning.

#### Key Considerations

| **Aspect**                    | **Description**                                                   |
|-------------------------------|-------------------------------------------------------------------|
| **Versioning**                | Enables recovery of previous object versions; manage deletions.  |
| **Storage Classes**           | Choose based on access patterns, resilience, and cost efficiency. |
| **Lifecycle Rules**           | Automate object management; may incur fees for transitions.      |
| **Replication**               | SRR and CRR for redundancy and disaster recovery.                 |
| **File Operations Impact**    | Modifications and deletions affect object versions and metadata.  |



###  10.2.7. Managing the Gateway 



1. **Adding a File Share**
   - When creating and activating the S3 File Gateway, it starts without file shares.
   - You can add up to 10 file shares per gateway.
   - Each file share must be connected to an S3 bucket and use an IAM role with a trust policy.

2. **IAM Role and Permissions**
   - The IAM role should have permissions to access the S3 bucket.
   - Trust policies define which services or users can assume the IAM role.

3. **File Share Status**
     - **AVAILABLE**: File share is properly configured and in use.
     - **CREATING**: File share is being created and not ready yet.
     - **UPDATING**: Configuration of the file share is being updated.
     - **DELETING**: File share is being deleted, but data upload to AWS continues until complete.
     - **FORCE_DELETING**: File share is being deleted forcibly, and uploads are stopped immediately.
     - **UNAVAILABLE**: File share is in an unhealthy state due to various issues like role policy errors or endpoint connectivity.

4. **File Share Actions**
   - You can change some settings of a file share after creation, such as:
     - Storage class for the S3 bucket
     - File share name
     - Export options (read-write or read-only)
     - Cache refresh settings

5. **Cache Refresh**
   - Use the Storage Gateway console or API to refresh cached objects.
   - Cache can be refreshed automatically at specified intervals.
   - Refresh operations can incur Amazon S3 request pricing.

6. **File Upload Notification**
   - Configure notifications for completed file uploads using Amazon EventBridge.
   - Notifications are different from Amazon S3 event notifications, which may not indicate full upload completion.

7. **Multi-Writer Best Practices**
     - **Single Writer Configuration**: Restrict S3 bucket writes to one file share using bucket policies.
     - **Unique Object Prefixes**: Assign unique prefixes for each file share to avoid simultaneous writes to the same objects.
   


| Task                     | Description                                                                                     |
|--------------------------|-------------------------------------------------------------------------------------------------|
| Adding a File Share      | Add up to 10 file shares per gateway, connect to an S3 bucket with IAM role permissions.        |
| IAM Role and Permissions | Ensure correct IAM role with trust policies for S3 bucket access.                                |
| File Share Status        | Monitor statuses: AVAILABLE, CREATING, UPDATING, DELETING, FORCE_DELETING, UNAVAILABLE.         |
| File Share Actions       | Edit settings such as storage class, file share name, and cache refresh options.                 |
| Cache Refresh            | Refresh cache using console or API; automatic refresh is available.                              |
| File Upload Notification | Use Amazon EventBridge for notifications of completed uploads.                                   |
| Multi-Writer Best Practices | Use bucket policies and unique prefixes to manage multiple file shares.                       |



##  10.3. Introduction to Step Functions



###  10.3.1. What is AWS Step Functions?

1. **Serverless Orchestration**: AWS Step Functions orchestrates workflows for modern applications without needing to manage servers.
2. **Workflow Management**: Breaks down a workflow into multiple steps, managing flow logic and tracking inputs and outputs.
3. **State Management**: Maintains the application state, tracking which workflow step the application is in.
4. **Event Logging**: Stores a log of data passed between application components, allowing applications to resume where they left off after interruptions.
5. **State Machines and Tasks**:
     - **State Machine**: Represents the workflow.
     - **Task**: A state that represents a single unit of work performed by another AWS service.
6. **State Definition**: Each step in a workflow is a state, referred to by a unique name within the state machine.
7. **State Functions**:
   - Perform work.
   - Make decisions based on input.
   - Pass output to other states.
   - Stop activity with failure or success.
   - Pass input to output or inject fixed data.
   - Provide delays.
   - Begin parallel branches.
   - Dynamically iterate steps.
8. **Types of States**: AWS Step Functions supports eight different types of states, each with specific functions and behaviors.

#### Types of States
| **State Type** | **Description** |
|----------------|-----------------|
| Task           | Represents a unit of work performed by another service. |
| Choice         | Makes decisions based on input, directing the flow to different branches. |
| Fail           | Stops execution with a failure status. |
| Succeed        | Stops execution with a success status. |
| Pass           | Passes its input to its output or injects fixed data. |
| Wait           | Adds a delay for a specified amount of time or until a specific time or date. |
| Parallel       | Begins parallel branches of activity. |
| Map            | Dynamically iterates over a list of items, applying a set of steps to each item. |


###  10.3.2. Why Use AWS Step Functions?

1. **Workflow Management**: 
   - AWS Step Functions allows you to manage and define application workflows separately from business logic. This separation simplifies updates and maintenance.
   
2. **Automatic Scaling**:
   - The service scales automatically to handle varying workloads, ensuring consistent performance even with increased request frequency.

3. **Serverless Architecture**:
   - As a serverless service, Step Functions offers benefits like automatic scaling, high availability, pay-per-use billing, and strong security and compliance measures.

4. **Built-in Service Primitives**:
   - Provides ready-made steps (states) for workflows that handle data passing, exception handling, timeouts, decisions, parallel executions, and more.

5. **AWS Service Integrations**:
   - Integrates with various AWS services, including:
       - **Compute Services**: AWS Lambda, Amazon ECS, Amazon EKS, AWS Fargate
       - **Database Services**: Amazon DynamoDB
       - **Messaging Services**: Amazon SNS, Amazon SQS
       - **Data Processing & Analytics**: Amazon Athena, AWS Batch, AWS Glue, Amazon EMR, AWS Glue DataBrew
       - **Machine Learning**: Amazon SageMaker
       - **APIs**: Amazon API Gateway
       - **SDK Integrations**: Over 200 AWS services

6. **Error Handling**:
   - Automatically manages errors with built-in try/catch and retry mechanisms, supporting task recovery and exception handling.

7. **Run History & Diagnostics**:
   - Provides real-time diagnostics, integrates with Amazon CloudWatch and AWS CloudTrail, and logs detailed execution histories, including state, failed steps, inputs, and outputs.

8. **Visual Monitoring**:
   - Offers a visual interface to monitor application launches, quickly identify errors, and troubleshoot issues through highlighted error indicators.

9. **High Volume Orchestration**:
   - Supports high event rates (over 100,000 per second) through Express Workflows, ideal for short-duration, high-volume workflows.

10. **Component Reuse**:
    - Enables reuse of components and services, facilitating easier workflow abstraction and integration with various AWS services.

11. **Separation of Logic**:
    - Keeps application logic separate from implementation, allowing flexible changes to steps without affecting business logic.

12. **Distributed Applications**:
    - Helps coordinate Lambda functions and microservices to build and rewire distributed applications efficiently.

13. **Modularity and Maintenance**:
    - Enhances modularity and simplifies maintenance by separating workflow management from business logic.

14. **Service Flexibility**:
    - Allows integration of different AWS services and microservices into workflows, supporting diverse application needs.

#### AWS Step Functions Features Table

| Feature                   | Description                                                                                   |
|---------------------------|-----------------------------------------------------------------------------------------------|
| **Automatic Scaling**     | Scales automatically based on workload changes.                                               |
| **Serverless Architecture** | Offers scaling, high availability, pay-per-use, and security/compliance benefits.              |
| **Built-in Service Primitives** | Provides steps for data handling, exception management, decisions, and parallel execution.    |
| **AWS Service Integrations** | Integrates with compute, database, messaging, data processing, machine learning, and API services. |
| **Error Handling**        | Built-in mechanisms for error recovery and task retries.                                       |
| **Run History & Diagnostics** | Real-time execution logs and diagnostics with CloudWatch and CloudTrail integration.           |
| **Visual Monitoring**     | Visual interface for monitoring and troubleshooting application launches and errors.           |
| **High Volume Orchestration** | Supports high event rates with Express Workflows for short-duration workflows.                |
| **Component Reuse**       | Facilitates the reuse of components and services, making workflows easier to manage.          |
| **Separation of Logic**   | Keeps workflow management separate from business logic, enhancing flexibility and maintenance. |
| **Distributed Applications** | Coordinates various services to build and manage distributed applications efficiently.         |
| **Modularity and Maintenance** | Enhances modularity and simplifies maintenance by decoupling workflow from logic.             |


###  10.3.3. Summary of Amazon States Language (Lesson 6 of 14)

1. **Definition**: Amazon States Language is a JSON-based language used in AWS Step Functions to define workflows and state machines.

2. **State Types**:
     - **Task States**: Perform work or invoke a Lambda function.
     - **Choice States**: Determine transitions based on conditions.
     - **Fail States**: Stop execution with an error.

3. **Workflow Visualization**: AWS Step Functions console provides a graphical view of state machines to visualize application logic.

4. **Transitions**:
     - **StartAt**: Defines the initial state of the workflow (case sensitive).
     - **Next**: Determines the next state to transition to.
     - **Terminal States**: Include Success or Fail states; the workflow ends here.

5. **Incoming Transitions**: States can have multiple incoming transitions, repeating until reaching a terminal state or encountering a runtime error.

6. **Common State Fields**:
   - `InputPath`
   - `ResultPath`
   - `OutputPath`
   - `Parameters`
   - `ResultSelector`

7. **JSON Path Expressions**: Used to manipulate and filter data in Step Functions.

8. **Intrinsic Functions**: Allow basic operations without Task states. Examples include:
     - **States.Format**: Formats strings with placeholders.
     - **States.StringToJson**: Converts strings to JSON objects.
     - **States.JsonToString**: Converts JSON objects to strings.
     - **States.Array**: Creates arrays.

9. **Example of Intrinsic Function (States.Format)**:
     - **Payload Template**: `"greeting.$": "States.Format('Welcome to {} {}\\'s playlist.', $.firstName, $.lastName)"`
     - **Input**: `{"firstName": "John", "lastName": "Doe"}`
     - **Output**: `{"greeting": "Welcome to John Doe's playlist."}`


| Concept            | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| **State Types**    | Task, Choice, Fail                                                            |
| **Transitions**    | `StartAt`, `Next`, Terminal States                                            |
| **Common Fields**  | `InputPath`, `ResultPath`, `OutputPath`, `Parameters`, `ResultSelector`       |
| **Intrinsic Functions** | `States.Format`, `States.StringToJson`, `States.JsonToString`, `States.Array` |
| **Example Function** | `States.Format` example with input and output details                          |


###  10.3.4. AWS Step Functions Workflow Studio 

AWS Step Functions Workflow Studio provides a low-code, visual design environment for creating and managing serverless workflows using AWS Step Functions. Below is a summary of key points:

1. **Visual Workflow Designer**: Workflow Studio offers a low-code, drag-and-drop interface to design workflows visually.
2. **Serverless Workflows**: Allows you to orchestrate AWS services to create serverless workflows.
3. **Access via Console**: The Workflow Studio is accessible through the AWS Step Functions console.
4. **Workflow Components**: Users can select various components to construct workflows, including state machines and tasks.
5. **Orchestration of Services**: Easily integrate and orchestrate AWS services such as Lambda, SNS, and SQS.
6. **Sample Workflow**: Provides a detailed view of sample workflows to help users understand different stages and their functions.
7. **Component Management**: Manage workflow components, such as state machines, directly from the Workflow Studio.
8. **Low-Code Approach**: Simplifies workflow creation with minimal coding, making it accessible to users with varying technical skills.
9. **Error Handling**: Built-in features to manage errors and retries within workflows.
10. **Monitoring**: Workflow Studio integrates with AWS CloudWatch for monitoring and logging workflow executions.
11. **Version Control**: Allows versioning of workflows for better management and tracking of changes.
12. **Integration with Other Services**: Seamless integration with other AWS services and third-party APIs.
13. **User-Friendly Interface**: The interface is designed for ease of use, with drag-and-drop capabilities and intuitive controls.
14. **Resource Management**: Manage resources and dependencies directly from the Workflow Studio.
15. **Testing and Validation**: Features for testing and validating workflows before deployment.
16. **Documentation and Help**: Provides documentation and help resources to guide users through the workflow design process.


| Component             | Description                                            |
|-----------------------|--------------------------------------------------------|
| Visual Workflow Designer | Low-code, drag-and-drop interface for creating workflows |
| Serverless Workflows   | Orchestration of AWS services to build serverless applications |
| AWS Step Functions Console | Access point for Workflow Studio and workflow management |
| Sample Workflow        | Example workflows to illustrate various stages and components |
| Component Management   | Tools for managing state machines and tasks within workflows |
| Error Handling         | Built-in features for managing errors and retries |
| Monitoring             | Integration with AWS CloudWatch for workflow monitoring |
| Version Control        | Capability to version workflows for tracking changes |
| Integration            | Seamless integration with AWS services and APIs |
| User Interface         | Intuitive design for ease of use and accessibility |
| Resource Management    | Tools for managing resources and dependencies |
| Testing and Validation | Features for testing workflows before deployment |
| Documentation          | Guides and resources to assist in workflow design |



###  10.3.5. AWS Step Functions Security Summary

1. **Credentials and Authentication**
   - Access to AWS Step Functions requires authentication credentials.
   - Credentials are managed using AWS Identity and Access Management (IAM).

2. **Permissions Required**
   - You need permissions to create or access Step Functions resources.
   - Permissions might include invoking AWS Lambda functions or Amazon Simple Queue Service (SQS) targets.

3. **Accessing Step Functions**
   - IAM users or roles can be granted access through policies.
   - Three predefined policies available:
     - `AWSStepFunctionsConsoleFullAccess`
     - `AWSStepFunctionsFullAccess`
     - `AWSStepFunctionsReadOnlyAccess`

4. **Custom Policies**
   - You can create custom IAM roles/policies based on specific needs and permission levels.

5. **Granular Permissions**
   - Granular-level permissions can be tailored for non-admin users.

6. **IAM Role for Step Functions**
   - AWS Step Functions requires an IAM role to invoke code and access resources.
   - Create a role via IAM console, select "Step Functions" as the service, and name the role.

7. **Default Permissions**
   - The `lambda:InvokeFunction` permission is included by default when creating a Step Functions role.

8. **Additional Permissions**
   - More services can be added to the role by attaching additional policies.

9. **Example Role**
   - Example role might include access to services such as:
     - Amazon API Gateway
     - AWS Batch
     - AWS Lambda

10. **Role Management**
    - Use the IAM console to manage and attach policies to Step Functions roles.



| **Topic**                      | **Details**                                              |
|--------------------------------|----------------------------------------------------------|
| **IAM Console**                | Create and manage IAM roles and policies.               |
| **Policies**                   | `AWSStepFunctionsConsoleFullAccess`, `AWSStepFunctionsFullAccess`, `AWSStepFunctionsReadOnlyAccess` |
| **Role Creation**              | Choose "Step Functions" under AWS service when creating a role. |
| **Default Permission**         | `lambda:InvokeFunction`                                 |
| **Example Services**           | Amazon API Gateway, AWS Batch, AWS Lambda                |



###  10.3.6. Standard and Express Workflows

When creating a state machine in AWS Step Functions, you can choose between **Standard** and **Express** Workflows. Both are defined using Amazon States Language, but they differ in terms of use cases, performance, and pricing.


  - **Standard Workflows**:
    - **Ideal for**: Long-running, durable, and auditable workflows.
    - **Maximum Duration**: Up to 1 year.
    - **Workflow Run Start Rate**: Over 2,000 per second.
    - **Start Transition Rate**: Over 4,000 per second per account.
    - **Pricing**: Priced per state transition.
    - **Workflow Run History**: Can be listed and described via APIs and visually debugged. Logs are available in CloudWatch.
    - **Workflow Run Semantics**: Exactly-once.
    - **Service Integrations**: Supports all integrations and patterns.
    - **Step Functions Activities**: Supported.

  - **Express Workflows**:
    - **Ideal for**: High-volume, event-processing workloads such as IoT data ingestion and mobile application backends.
    - **Maximum Duration**: 5 minutes.
    - **Workflow Run Start Rate**: Over 100,000 per second.
    - **Start Transition Rate**: Nearly unlimited.
    - **Pricing**: Priced by the number of runs, duration, and memory consumption.
    - **Workflow Run History**: Can be inspected in CloudWatch Logs.
    - **Workflow Run Semantics**:
      - **Asynchronous**: At-least-once.
      - **Synchronous**: At-most-once.
    - **Service Integrations**: Supports all integrations but not Job-run (.sync) or Callback (.waitForTaskToken) patterns.
    - **Step Functions Activities**: Not supported.

#### Asynchronous vs Synchronous Express Workflows

| Feature                        | Asynchronous Express Workflows                        | Synchronous Express Workflows                        |
|--------------------------------|--------------------------------------------------------|------------------------------------------------------|
| **Workflow Completion**        | Returns confirmation of start, does not wait for completion | Starts, waits for completion, then returns result    |
| **Use Cases**                  | Suitable for messaging services, data processing      | Suitable for orchestrating microservices             |
| **Invocation**                 | Can be triggered by nested workflows or StartExecution API | Can be invoked from API Gateway, Lambda, or StartSyncExecution API |

#### Standard vs Express Workflows
| Feature                      | Standard Workflows                                      | Express Workflows                                    |
|------------------------------|---------------------------------------------------------|------------------------------------------------------|
| **Maximum Duration**         | 1 year                                                   | 5 minutes                                            |
| **Workflow Run Start Rate**  | Over 2,000 per second                                   | Over 100,000 per second                             |
| **Start Transition Rate**    | Over 4,000 per second per account                      | Nearly unlimited                                    |
| **Pricing**                  | Priced per state transition (completed step)            | Priced by the number of runs, duration, and memory consumption |
| **Workflow Run History**     | Listed and described with Step Functions APIs, debugged through the console, and inspected in CloudWatch Logs | Inspected in CloudWatch Logs                          |
| **Workflow Run Semantics**   | Exactly-once workflow run                               | Asynchronous: At-least-once; Synchronous: At-most-once |
| **Service Integrations**     | Supports all service integrations and patterns          | Supports all service integrations; does not support Job-run (.sync) or Callback (.waitForTaskToken) patterns |
| **Step Functions Activities**| Supports Step Functions activities                       | Does not support Step Functions activities           |


###  10.3.7. AWS Step Functions Use Cases

#### Data Processing
  - **Report Generation:** Consolidate data from multiple databases to produce reports.
  - **Data Validation & Normalization:** Validate, process, and normalize data for consistency and usability.
  - **Data Refinement:** Refine and reduce large datasets into useful formats.
  - **Multi-Step Analytics:** Coordinate complex analytics and machine learning workflows.
  - **Automated ML Workflows:** Automate machine learning workflows using AWS Step Functions Data Science SDK.

#### IT Automation
  - **CI/CD Tools:** Build tools for continuous integration and continuous deployment.
  - **Data Synchronization:** Synchronize data between source and destination Amazon S3 buckets.
  - **Event-Driven Applications:** Create applications that automatically respond to infrastructure changes.
  - **Repetitive Process Automation:** Automate repetitive processes within workflows.

#### E-commerce
  - **Order Fulfillment:** Implement workflows for managing order fulfillment processes.
  - **Inventory Tracking:** Track inventory levels and manage stock through automated workflows.
  - **Business Process Optimization:** Use visual workflows for collaboration to optimize and shorten processing times.

#### Web Applications
  - **Lambda Integration:** Combine Lambda functions to build web-based applications with human approval.
  - **User Registration & Authentication:** Implement robust user registration processes and sign-on authentication.

#### Use Case Table

| Use Case         | Description                                                                                     |
|------------------|-------------------------------------------------------------------------------------------------|
| **Data Processing** | Report generation, data validation, data refinement, multi-step analytics, automated ML workflows. |
| **IT Automation**   | CI/CD tools, data synchronization, event-driven applications, repetitive process automation.    |
| **E-commerce**      | Order fulfillment, inventory tracking, business process optimization.                          |
| **Web Applications** | Lambda integration, user registration, and authentication processes.                          |



##  10.4.  AWS Backup Primer



###  10.4.1. Protecting Data in the Cloud


1. **Backup Strategies**
   - Determine backup needs based on applications, workloads, departments, and business objectives.
   - Evaluate what data is critical for business operations and additional data that needs backup.

2. **Backup Purposes**
   - Identify the purpose of backups: disaster recovery, compliance, daily operations, ransomware recovery, etc.
   - Consider how backups will be used: user recovery, development/testing, long-term retention, regulatory compliance.

3. **Backup Options**
     - **Service-native Backups and Snapshots**
     - Integrated with specific AWS services (e.g., Amazon RDS, DynamoDB, Amazon EBS).
     - Managed through service-specific APIs, CLI, or AWS Management Console.
     - Suitable for single or few AWS services, may not scale well for many services.

     - **Centralized Policy-based Backups**
     - AWS Backup allows centralized, automated backup management across AWS services and on-premises solutions.
     - Provides a unified console for backup policies, monitoring, and reporting.
     - Useful for environments with many services and auditing requirements.

     - **AWS Elastic Disaster Recovery**
     - Focuses on minimizing downtime and data loss with affordable storage and point-in-time recovery.
     - Ideal for disaster recovery planning, not specifically for centralized backup management.

4. **Understanding Usage**
     - **Service Level Agreements (SLAs)**
     - Define Recovery Point Objectives (RPO) and Recovery Time Objectives (RTO).
     - RPO determines acceptable data loss duration; RTO specifies acceptable downtime.

5. **Audit and Compliance**
   - Some businesses must maintain backups with immutability and meet regulatory standards for periodic audits.

6. **Backup Granularity**
     - **File-level Recovery:** Configuration files for applications.
     - **Application-level Recovery:** Specific application versions.
     - **Application Data-level Recovery:** Specific databases (e.g., MySQL).
     - **EC2 Volume-level Recovery:** EBS volumes.
     - **EC2 Instance-level Recovery:** Instances with specific configurations.
     - **Managed Service Recovery:** Specific tables in services like DynamoDB.

7. **Backup Planning**
   - Map dependencies within your backup strategy.
   - Consider recovery requirements and data dependencies between components.

| Backup Option                     | Description                                                                                  | Use Case                                          |
|----------------------------------|----------------------------------------------------------------------------------------------|---------------------------------------------------|
| **Service-native Backups**        | Integrated with AWS services; managed through specific APIs/CLI/Console.                     | Single or few services, less administrative overhead. |
| **Centralized Policy-based Backups** | AWS Backup for centralized, automated management and policy-based backups.                   | Many services, requires auditing and reporting.  |
| **AWS Elastic Disaster Recovery** | Minimizes downtime with point-in-time recovery; not specifically for centralized backups.    | Disaster recovery, minimal data loss.            |


###  10.4.1. AWS Backup Supported Services


General Overview:
1. **Centralized Management**: AWS Backup centralizes and automates backup and restore operations across 12 AWS services.
2. **Services Integration**: The lesson covers how AWS Backup integrates with various services, what is backed up, and what is not.

Compute Services:
3. **Amazon EC2**:
     - **Backed Up**: Root EBS volume, associated EBS volumes, launch configurations, AMI.
     - **Stored**: Backup data stored as EBS volume-backed AMI in S3.
     - **Not Backed Up**: Elastic Inference accelerator configuration, user data from instance launch.

Storage Services:
4. **Amazon EBS**:
     - **Backed Up**: Data via point-in-time snapshots; initial snapshot is full, subsequent snapshots are incremental.
     - **Restore**: Snapshots can be restored to new volumes and copied to other Regions.

5. **Amazon EFS**:
     - **Backed Up**: All data in EFS file systems, incremental backups.
     - **Benefits**: Cost optimization via tiering and tagging.

6. **Amazon S3**:
     - **Backed Up**: Point-in-time and periodic backups; requires S3 Versioning.
     - **Note**: Set lifecycle expiration rules to avoid increased storage costs.

7. **Amazon FSx for Windows File Server**:
     - **Backed Up**: Incremental backups with VSS; stored in S3.
     - **Restore**: Contains all information needed to create a new file system.

8. **Amazon FSx for Lustre**:
     - **Backed Up**: Automatic and user-initiated backups; can restore to point-in-time snapshots.

Database Services:
9. **Amazon RDS**:
     - **Backed Up**: Storage volume snapshot of the DB instance.
     - **Restore**: Scheduled, on-demand, continuous PITR snapshots.

10. **Aurora**:
      - **Managed**: Backup policies, monitoring, and cross-Region snapshot copying.

11. **Neptune**:
      - **Backed Up**: Continuous and incremental backups, specified retention periods.

12. **DynamoDB**:
      - **Features**: Cross-Region and cross-account copy, encrypted backups, tag inheritance.

13. **Amazon DocumentDB**:
      - **Managed**: Independent, immutable snapshots across Regions or accounts.

Hybrid Cloud:
14. **VMware**:
      - **Managed**: Centralized backup for VMware environments on-premises and in VMware Cloud on AWS.
      - **Benefits**: Compliance controls, flexible restore options.

15. **AWS Storage Gateway**:
      - **Supported**: Backup and restore of cached and stored volumes.

Pricing:
16. **Storage Costs**:
      - **Pricing Model**: Based on storage used; initial full backup and incremental backups for changes.
      - **Charges**: Billed per service (e.g., EC2, RDS, S3) based on average storage used.

Supported Services Table:

| Service                 | Backed Up                           | Not Backed Up                                      |
|-------------------------|-------------------------------------|-----------------------------------------------------|
| **Amazon EC2**          | EBS volumes, AMI, launch configurations | Elastic Inference configuration, user launch data |
| **Amazon EBS**          | Point-in-time snapshots              | -                                                   |
| **Amazon EFS**          | All data, incremental backups        | -                                                   |
| **Amazon S3**           | Point-in-time and periodic backups   | Requires S3 Versioning and lifecycle expiration rules |
| **Amazon FSx for Windows File Server** | Incremental backups, VSS         | -                                                   |
| **Amazon FSx for Lustre** | Automatic and user-initiated backups | -                                                   |
| **Amazon RDS**          | DB instance snapshots                | -                                                   |
| **Aurora**              | Aurora cluster snapshots            | -                                                   |
| **Neptune**             | Continuous and incremental backups   | -                                                   |
| **DynamoDB**            | Cross-Region, cross-account copies   | -                                                   |
| **Amazon DocumentDB**   | Immutable snapshots                 | -                                                   |
| **VMware**              | On-premises and VMware Cloud backups | -                                                   |
| **AWS Storage Gateway** | Cached and stored volumes           | -                                                   |




###  10.4.2. AWS Backup Use Case for AnyCompany-Health

1. **Company Overview**:
   - AnyCompany-Health is a large enterprise focused on regulatory compliance for healthcare.
   - Utilizes AWS services including Amazon EFS, Amazon EC2, Amazon EBS, Amazon RDS, Amazon FSx, Amazon Aurora, Amazon DynamoDB, and AWS Storage Gateway.
   - Operates a cloud-centered architecture fully utilizing cloud services.

2. **Current Challenges**:
   - Manual or script-based backup processes leading to high administrative overhead.
   - Multiple AWS accounts creating complex management and monitoring needs.
   - Managing numerous IAM roles and permissions for backup resources.
   - Compliance with healthcare regulations like HIPAA and FedRAMP.

3. **Automated Backup Management**:
     - **Issue**: Manual backups and custom scripts are difficult to maintain.
     - **Solution**: AWS Backup offers automated backup schedules, retention, and lifecycle management, reducing manual procedures.

4. **Centralized Cross-Account Management**:
     - **Issue**: Multiple AWS accounts increase management complexity.
     - **Solution**: AWS Backup integrates with AWS Organizations, allowing centralized management of backups from a single account.

5. **Unified IAM Policy Control**:
     - **Issue**: Numerous IAM roles and permissions complicate security management.
     - **Solution**: AWS Backup provides unified IAM policy control, simplifying permissions and role management.

6. **Regulatory Compliance**:
     - **Issue**: Must comply with HIPAA and FedRAMP standards.
     - **Solution**: AWS Backup Audit Manager helps audit and ensure compliance with backup policies.

7. **Future Plans**:
   - Expand AWS Backup usage as confidence grows.
   - Explore best practices including distinct keys for backup vaults, cross-account backup copies, vault lock feature, and distinct IAM access policies.

8. **Learning Points**:
   - AWS Backup automates and simplifies backup processes.
   - Integration with AWS Organizations centralizes backup management.
   - Unified IAM policies enhance security and reduce complexity.
   - Compliance auditing tools ensure regulatory adherence.

#### Current AWS Services in Use
| Service                    | Backup/Retention Requirements           | Compliance Needs                    |
|----------------------------|----------------------------------------|------------------------------------|
| Amazon FSx for Lustre      | Custom scripts/manual backup           | High availability, disaster recovery|
| Amazon FSx for Windows     | Custom scripts/manual backup           | High availability, disaster recovery|
| Amazon EBS                 | Manual backups                         | Compliance with data protection standards |
| Amazon RDS                 | Custom scripts/manual backup           | High availability, compliance      |
| Amazon EC2                 | Manual backups                         | Compliance with data protection standards |
| Amazon EFS                 | Manual backups                         | High availability, disaster recovery|
| Amazon Aurora              | Manual backups                         | Compliance with data protection standards |
| Amazon DynamoDB            | Manual backups                         | High availability, compliance      |
| AWS Storage Gateway        | Manual backups                         | High availability, disaster recovery|


###  10.4.3. AWS Backup Key Concepts

Retention Period:
  - **Definition**: Specifies how long AWS Backup will retain your backups.
  - **Automatic Deletion**: Backups are deleted automatically at the end of the retention period to reduce storage costs.
  - **Snapshot Retention**: Can be set from 1 day to 100 years, or indefinitely.
  - **Continuous Backup Retention**: Ranges from 1 day to 35 days.
  - **Retention Set to Always**: Backups will be retained indefinitely if no retention period is set.

Cross-Region and Cross-Account Copy:
  - **Cross-Region**: Copy backups to different AWS Regions using the "Copy to destination" option to minimize downtime and meet disaster recovery requirements.
  - **Cross-Account**: Store backup copies in another account's vault or a different vault within the same account using the external vault ARN for additional security.

Tags Added to Recovery Points:
  - **Purpose**: Tags help identify, organize, and filter resources and backups.
  - **Automatic Tagging**: Tags from the source are automatically copied to the protected snapshot.
  - **Backup Rule Tags**: Add tags specific to the backup rule, such as frequency and window, to the backups when created. Examples include compliance or severity tags.

Advanced Backup Settings:
  - **VSS Enabled Applications**: Supports backup and restore for Microsoft Windows applications like Windows Server, SQL Server, Exchange Server, and SharePoint on EC2 instances.

Resource Assignments:
  - **Definition**: Specifies which resources are protected by the backup plan.
  - **Creation**: Requires a name, IAM role with permissions, and one or more resources.
  - **Resource Types**: Choose which AWS service or third-party application resources to include (e.g., Amazon EBS volumes).
  - **Specific Resources**: Option to specify individual resource IDs.
  - **Tag-Based Selection**: Refine resource selection using tags to include new resources automatically.

Quotas for Resource Assignments:
| **Quota Type**           | **Limit**                          |
|--------------------------|------------------------------------|
| ARNs without Wildcards   | 500                                |
| ARNs with Wildcards      | 30                                 |
| Conditions               | 30                                 |
| Tags per Resource Assignment | 30                           |

Sample Backup Plan:
  - **Rules**: Can have multiple rules and be modified after creation.
  - **Resource Assignment**: Includes defining which resources are protected based on type, ID, or tags.




###  10.4.4. AWS Backup Demonstration

  - **Sign In**: Log in to the AWS Management Console and navigate to `Storage > AWS Backup`.
  - **Configure Resources**: 
  - Go to `My account > Settings`.
  - Choose `Configure resources` and activate Amazon EBS.
  - **Create Backup Plan**:
  - Select `Create Backup plan` from the dashboard or Backup plans page.
  - Choose `Build a new plan` and name it (e.g., `orders-EBS`).
  - Optionally, apply tags for organization.
  - **Define Backup Rules**:
  - Set a backup rule name (e.g., `orders-weekly`).
  - Choose the backup vault (Default or create a new one).
  - Set the frequency to `Weekly` and choose `Friday`.
  - Define the backup window (default is 5:00 AM UTC, lasting 8 hours).
  - Set the retention period to `2 Weeks`.
  - **Apply Backup Tags**: Optionally, add tags to recovery points.
  - **Review Backup Plan**: 
  - View the backup plan on the Backup plans page.
  - Add additional rules if needed (e.g., for monthly or daily backups).
  - **Assign Resources**:
  - Go to `Resource assignments` and choose `Assign resources`.
  - Enter a name for the assignment (e.g., `orders-EBS-prod`).
  - Select the default or existing IAM role with backup permissions.
  - Choose `EBS` as the resource type and specify if needed.
  - Optionally, refine by resource IDs or tags.
  - Confirm the resource assignment.
  - **View Backup Job Results**:
  - Go to `My account > Jobs`.
  - Filter to view jobs from the last 24 hours, 7 days, or 30 days.
  - Check the status of backup jobs and restore snapshots.


```markdown
| Step                      | Description                                               |
|---------------------------|-----------------------------------------------------------|
| **Sign In**               | Log in to AWS Management Console and navigate to AWS Backup. |
| **Configure Resources**   | Activate Amazon EBS under `My account > Settings`.       |
| **Create Backup Plan**    | Choose `Create Backup plan`, name it, and optionally tag it. |
| **Define Backup Rules**   | Set rule name, frequency, backup vault, backup window, and retention period. |
| **Apply Backup Tags**     | Optionally add tags to recovery points.                  |
| **Review Backup Plan**    | View and modify the backup plan and rules as needed.     |
| **Assign Resources**      | Assign specific resources, configure IAM role, and refine resource selection. |
| **View Backup Job Results** | Check job status under `My account > Jobs` and view results. |
```



###  10.4.5. AWS Backup Security

1. **Backup Vault**:
   - A container in AWS Backup for storing and organizing backups.
   - Can be secured with vault access policies.
   - Allows creating multiple vaults for different purposes (e.g., development, production).
   - Prevents unauthorized modification or deletion of backups within a vault.

2. **Creating Backup Vaults**:
   - Default backup vault created automatically with the AWS Backup console.
   - Manual creation required when using AWS CLI, SDK, or CloudFormation.
   - Vault names must be case-sensitive and between 2-50 alphanumeric characters, hyphens, or underscores.
   - Best practice: Create separate vaults for different types of data (e.g., financials vs. training resources).

3. **Encryption and IAM Roles**:
   - Backups support encryption using AWS KMS keys.
   - The default key is `aws/backup`, but you can specify a different AWS KMS key.
   - Encryption settings cannot be edited after a vault is created.
   - IAM roles control access to AWS Backup APIs.

4. **AWS Backup Vault Lock**:
   - Uses a WORM (Write Once Read Many) model to make backups immutable.
   - Prevents deletion or modification of backups and their lifecycle settings.
   - Provides additional protection to meet compliance requirements.
   - Can be activated via AWS Backup API, CLI, or SDK.

5. **Use Cases for AWS Backup Vault Lock**:
     - **Cloud-Centered Backups**: Protects critical data across AWS services.
     - **Business and Regulatory Compliance**: Ensures data meets compliance standards.
     - **Disaster Recovery**: Supports business continuity with secure data backups.
     - **Ransomware Protection**: Safeguards data from ransomware attacks and unauthorized changes.

6. **AWS Backup and AWS Organizations**:
   - Allows organization-wide backup protection and monitoring.
   - Centralizes backup policies across multiple AWS accounts.
   - Merges policies from the organizational root and units for effective application.
   - Uses IAM roles to perform backups on resources as specified by the backup plans.



| Place                           | Description                                                       |
|---------------------------------|-------------------------------------------------------------------|
| **AWS Backup Console**          | Creates default backup vault automatically.                      |
| **AWS CLI, SDK, CloudFormation**| Requires manual creation of backup vaults.                       |
| **AWS KMS**                     | Provides encryption keys for backups.                            |
| **AWS Backup API, CLI, SDK**    | Interfaces for activating Backup Vault Lock.                     |
| **AWS Organizations**           | Enables centralized backup management and policy application.     |

###  10.4.6. AWS Backup Monitoring

1. **AWS Backup Monitoring Overview**
   - AWS Backup integrates with various AWS tools to monitor backup jobs and configurations.
   - Key tools for monitoring include Amazon CloudWatch, Amazon SNS, and Amazon EventBridge.

2. **CloudWatch Metrics**
     - **CloudWatch**: Monitors AWS resources in real time and tracks metrics.
     - **Metrics Namespace**: `aws/backup` is used to track AWS Backup metrics.
     - **Common Metrics**:
       - **Jobs**: Tracks the number of backup, restore, and copy jobs across states.
       - **Recovery Points**: Monitors warm and cold recovery points, and their states.
     - **Example Use Cases**:
     - Alert on failed backup jobs if failures exceed a certain threshold.
     - Track recovery points to ensure they are properly managed.

   | **Category**     | **Metrics**                                    | **Example Dimensions**  | **Example Use Case**                                                             |
   |------------------|------------------------------------------------|--------------------------|----------------------------------------------------------------------------------|
   | Jobs             | Number of backup, restore, and copy jobs      | Resource type, vault name | Monitor failed backup jobs and trigger alerts if necessary.                       |
   | Recovery Points  | Number of warm and cold recovery points        | Resource type, vault name | Track deleted recovery points and their states in backup vaults.                  |

3. **Amazon SNS Integration**
     - **Amazon SNS**: A messaging service that delivers notifications from publishers to subscribers.
     - **Common Notifications**:
     - Alerts for failed backup jobs.
     - Notifications for job completion or expiration.

   | **Job Type**     | **Event**                         |
   |------------------|-----------------------------------|
   | Backup Job       | BACKUP_JOB_STARTED | BACKUP_JOB_COMPLETED |
   | Copy Job         | COPY_JOB_STARTED | COPY_JOB_SUCCESSFUL | COPY_JOB_FAILED |
   | Restore Job      | RESTORE_JOB_STARTED | RESTORE_JOB_COMPLETED |
   | Recovery Point   | RECOVERY_POINT_MODIFIED           |

4. **Amazon EventBridge**
     - **EventBridge**: A serverless event bus service that connects applications with data sources and targets.
     - **Integration with AWS Backup**:
     - Monitors and logs AWS Backup events for compliance and business continuity.
     - Event types include backup, restore, recovery point, vault changes, region settings, and backup plan state changes.
     - **EventBridge vs. CloudWatch Events**:
     - EventBridge provides more detailed monitoring and supports a wider range of event types compared to CloudWatch Events.

   | **Event Type**      | **Description**                                                                 |
   |---------------------|---------------------------------------------------------------------------------|
   | Backup              | Monitors backup job status and changes.                                          |
   | Restore             | Tracks restore job progress and completion.                                      |
   | Recovery Point      | Monitors changes to recovery points and their states.                             |
   | Vault               | Logs changes to backup vault settings and state.                                  |
   | Region Settings     | Tracks changes in backup region settings.                                         |
   | Backup Plan State   | Monitors changes to backup plan states and configurations.                        |

5. **Event Handling**
   - AWS Backup sends events to EventBridge every 5 minutes.
   - EventBridge provides more comprehensive event tracking compared to the AWS Backup notification API.



###  10.4.7. AWS Backup Compliance Summary

Overview:
- AWS Backup Audit Manager helps in managing compliance with backup policies and regulations.
- Provides built-in and customizable compliance controls for data protection.
- Automatically detects policy violations and prompts corrective actions.

Key Features:
  - **Compliance Controls:** 
  - Built-in controls can be customized for specific data protection policies.
  - Controls track adherence to backup schedules and retention periods.
  - **Automated Detection:** 
  - Detects deviations from defined backup parameters.
  - Provides alerts for quick corrective actions.

Audit and Reporting:
  - **Continuous Evaluation:**
  - Monitors backup activities and generates audit reports.
  - Reports help demonstrate compliance with regulatory requirements.
  - **Report Generation:**
  - Can generate periodic or on-demand reports.
  - Tracks backup, copy, and restore job statuses.
  - **Reporting Formats:**
  - Daily reports available in CSV, JSON, or both.
  - Reports delivered to an Amazon S3 bucket.
  - Up to 20 report plans per AWS account.

Controls:
1. **Backup Resources Protected by Backup Plan Control:**
   - Identifies gaps in backup coverage.
   - Selects resources by type, tag, or specific resource.

2. **Backup Plan Minimum Frequency and Retention Control:**
   - Customizable parameters for backup frequency and retention periods.
   - Default: hourly backups, one-month retention.

3. **Backup Prevent Recovery Point Manual Deletion Control:**
   - Allows up to five IAM roles to manually delete recovery points.
   
4. **Backup Recovery Point Encrypted Control:**
   - Ensures all recovery points are encrypted.
   - Evaluates recovery points with specific tags.

5. **Backup Recovery Point Minimum Retention Control:**
   - Ensures recovery points are retained for the specified period.

Usage:
  - **Setting Up:**
  - Start using AWS Backup Audit Manager via AWS Backup management console.
  - Set up controls to create compliance frameworks.

  - **Dashboard:**
  - Centralized view of backup activity and compliance status.
  - Provides insights into backup operations and compliance gaps.

Learning Resources:
- [Video on AWS Backup Audit Manager](https://www.youtube.com/watch?v=UH9sDD9UT38)
- [AWS Backup Product Page](https://aws.amazon.com/backup)
- [AWS News Blog on Backup Compliance](https://aws.amazon.com/blogs/aws/monitor-evaluate-and-demonstrate-backup-compliance-with-aws-backup-audit-manager/)

Report Plans and Templates:
  - **Report Plan:** Automates report creation and defines the destination S3 bucket.
  - **Report Template:** Defines the information to be included in reports.
  - **Report Timing:** Reports for the previous 24 hours, created between 1:00 and 5:00 AM UTC.


###  10.4.8. AWS Backup Customer Use Cases

1. **Cloud-Centered Backup**
     - **Cross-Account Management (CAM)**: Integrates with AWS Organizations to manage policies and resources across multiple accounts from a single view.
     - **Cross-Region Copy (CRC)**: Allows backup to be copied to other AWS Regions for disaster recovery and compliance.
     - **Cross-Account Backup (CAB)**: Enables backup to another AWS account within an organization, aiding in data recovery and protecting against insider threats.

2. **Use Case: Rackspace**
     - **Challenge**: Managing backups for thousands of customers with NFS servers required custom applications and significant administrative effort.
     - **Solution**: Leveraged Amazon EFS with AWS Backup to automate and streamline backups, reducing the need for custom solutions.
     - **Benefits**:
       - **50%** reduction in server configuration time.
       - **$20,000** savings in development costs.
     - Reduced support tickets and improved customer experience.

   | Aspect                 | Before AWS Backup                       | After AWS Backup                            |
   |------------------------|----------------------------------------|---------------------------------------------|
   | Configuration Time     | Longer with NFS                        | 50% faster with Amazon EFS                  |
   | Development Costs      | Higher due to custom solutions          | Saved $20,000                              |
   | Support Tickets        | 1,000 backup failures                   | Minimal failures, improved monitoring       |

3. **Use Case: ZS**
     - **Challenge**: Managing backups across 150 AWS accounts with various services and custom scripts.
     - **Solution**: Centralized backup management using AWS Backup, simplifying encryption, policy enforcement, and reducing operational overhead.
     - **Benefits**:
       - **$30,000** annual savings and **1,200 man-hours** reduction in backup operations.
     - Improved security, compliance, and operational efficiency.

   | Aspect                   | Before AWS Backup                      | After AWS Backup                            |
   |--------------------------|---------------------------------------|---------------------------------------------|
   | Backup Tools             | Third-party tools and custom scripts  | Centralized with AWS Backup                 |
   | Operational Costs        | Higher                                | Reduced by $30,000                         |
   | Man-Hours                 | Significant manual effort             | Reduced by 1,200 man-hours                  |

4. **Use Case: Santos**
     - **Challenge**: Maintaining compliance and managing backups for over 21,000 EBS volumes with custom scripts.
     - **Solution**: Automated routine backups with AWS Backup, reducing operational burden and improving compliance tracking.
     - **Benefits**:
       - **80%** reduction in backup management time.
       - **50%** reduction in operational costs.
     - Increased accuracy of snapshots from **80%** to **100%**.

   | Aspect                  | Before AWS Backup                     | After AWS Backup                            |
   |-------------------------|--------------------------------------|---------------------------------------------|
   | Backup Management Time  | High, manual effort                  | Reduced by 80%                             |
   | Operational Costs       | Higher                                | Reduced by 50%                             |
   | Snapshot Accuracy       | 80%                                    | 100%                                        |

5. **AWS Backup and Ransomware Mitigation**
     - **Challenge**: Ransomware threats require robust protection and recovery mechanisms.
     - **Solution**: Use of encryption and backup vaults with AWS KMS keys to isolate and protect backups from ransomware attacks.
     - **Partner Solution**: Integration with Open Raven for enhanced ransomware protection and recovery capabilities.

   | Aspect                  | Description                             |
   |-------------------------|-----------------------------------------|
   | Encryption               | Use AWS KMS keys to encrypt backups     |
   | Backup Vault Protection | Isolate backup access to prevent decryption by unauthorized users |
   | Partner Integration     | Open Raven integration with AWS Backup Audit Manager for ransomware protection |





