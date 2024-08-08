# 1. Introduction to Database Migration


##  1.1.Envisioning and assessing migration (AWS SCT)

- **Planning is Crucial:** Understand the scope of work based on database schema, data volumes, data types, resources, and stakeholders. Utilize integrated tools to support the project plan and automate migration.
- **Initial Assessment:** Assess the current environment, evaluate risks, and create a business case. Identify subject matter experts, stakeholders, and plan capacity for the target system.
- **Database Engine Migration:** Different database engines have unique features. Migrating to a new engine (e.g., Oracle to Amazon DynamoDB) can improve performance and reduce costs. Open-source databases may offer lower licensing costs.
- **AWS SCT Overview:** AWS Schema Conversion Tool (SCT) assists in cataloging the physical and logical components of your existing system, particularly useful for heterogeneous migrations.
- **Effort Assessment by AWS SCT:** AWS SCT assesses conversion complexity, categorizing efforts into simple, medium, and complex. Effort levels are color-coded (green, gray, orange, red) to estimate the time and resources required for different tasks.
- **Database Storage Object Conversion:** AWS SCT provides an assessment report on converting database storage objects (e.g., tables, indexes). It shows which objects are automatically converted and which require manual intervention, including the difficulty level.
- **Database Code Object Conversion:** AWS SCT helps convert database code objects (e.g., stored procedures, functions, triggers) into the target database's language. It highlights code that needs manual intervention if issues are detected.
- **Detailed Migration Report:** AWS SCT generates a detailed report listing migration objects requiring manual intervention, recommendations on handling unsupported features, and export options for tracking progress in a spreadsheet.


##  1.2. Converting database schemas (AWS SCT)

- **Database Object Conversion**: Involves converting tables, indexes, constraints, foreign keys, triggers, and stored procedures from the source database engine to the target engine. Does not include migrating actual data records.

- **AWS SCT Functionality**: Converts source-object definitions into formats compatible with the target engine and applies them when building the target database schema.

- **Heterogeneous Migration Challenges**: When migrating between different database engines, some features in the source database may not exist in the target database. AWS SCT flags these for manual intervention.

- **Alert System**: AWS SCT uses a color-coded alert system to indicate conversion difficulties:
  - Gray: Simple action required.
  - Yellow: Medium complexity.
  - Red: Complex action required.

- **Issue Identification**: For unconvertible items, AWS SCT flags them with specific colors and provides detailed assessments. For example, an unsupported bitmapped index might be flagged for manual adjustment.

- **Code Warnings**: AWS SCT may generate warnings for unsupported code elements (e.g., hints in SQL statements). These warnings indicate potential issues, but SCT can often ignore or modify the offending code without impacting the source database.

- **Manual Recoding**: When AWS SCT cannot convert certain features, manual recoding may be required using design patterns suited to the target engine’s capabilities.

- **Database Migration Playbooks**: AWS provides detailed migration playbooks for common source-to-target database combinations. These playbooks include design patterns to guide manual recoding where necessary.

- **Available Playbooks**: Migration playbooks include:
  - Microsoft SQL Server to Aurora MySQL
  - Microsoft SQL Server to Aurora PostgreSQL
  - Oracle to Aurora PostgreSQL
  - More playbooks are available for download on the AWS DMS resources page.

- **AWS SCT Extension Pack**: An add-on module that emulates source database functions in the target database, crucial for converting objects when migrating to engines like Amazon Redshift.

- **Supported Functions in Extension Pack**: The extension pack includes various functions required for successful migration, especially for data warehouses (e.g., Oracle to Amazon Redshift).

- **Next Steps**: After converting database schemas, AWS SCT can assist with converting application code and completing the data migration process.


##  1.3. Converting applications (AWS SCT)

- **Application Conversion Definition**
  - Porting application code written in languages like Java or C to a new target database.
  - Example: Porting embedded SQL in a web forms-based order entry application to a new database engine.

- **Impact on Database Migration**
  - Application conversion is the most complex aspect of migration.
  - Applications might be legacy, mission-critical, and difficult to rewrite.
  - Nonstandard features in applications may not be supported by the target database.
  - In-house expertise for legacy applications may be lacking.

- **AWS SCT Role in Application Migration**
  - AWS SCT helps modernize SQL code for the new database.
  - Extracts SQL statements embedded in application code.
  - Tracks all instances of embedded SQL.
  - Converts SQL to work with the target database.
  - Rebuilds the application program with the converted code.

- **Application Conversion Process with AWS SCT**
  - Identify SQL statements in the application code.
  - Convert these SQL statements to the target database format.
  - Rebuild the application with the converted SQL.

- **Additional Support by AWS SCT**
  - Modernizes schema including stored procedures and triggers.
  - Converts small utilities and scripts aiding various processes.

- **Next Steps Post Application Conversion**
  - Understand how AWS SCT helps with converting small utilities and scripts.
  - Proceed with other steps in the database migration process.


##  1.4. Converting scripts (AWS SCT)

- **Script Conversion Purpose**: Focuses on converting batch scripts used for ETL processes, database maintenance, disaster recovery, and other processes to ensure compatibility with the new database engine.
- **AWS SCT Role**: AWS Schema Conversion Tool (SCT) is used to convert database scripts from Oracle, Microsoft, and Teradata to PostgreSQL-derived databases, including Amazon Aurora and Amazon Redshift.
- **Script Types Covered**: Includes scripts related to ETL processes, database maintenance, and disaster recovery, which may not be directly related to applications but are crucial for database operations.
- **Automatic Conversion**: AWS SCT attempts to automatically convert scripts to work with the target database. If a script cannot be converted, AWS SCT flags the issue for manual intervention.
- **Database Engine Compatibility**: Supports conversion to PostgreSQL-compatible databases, ensuring that scripts work seamlessly on Amazon Aurora with PostgreSQL compatibility and Amazon Redshift.
- **Manual Intervention**: In cases where the conversion is not straightforward, AWS SCT provides notifications and highlights areas where manual changes are necessary.
- **Post-Script Conversion**: After script conversion, the next focus is on migrating the actual data, where AWS Database Migration Service (DMS) can assist.
- **Comprehensive Migration Assistance**: AWS SCT helps with not just schema conversion but also converting related scripts to ensure a smooth transition to the cloud-based database.
- **Tool Limitations**: AWS SCT may not convert every script perfectly, requiring developers to review and possibly adjust the code manually.
- **Visual Interface**: AWS SCT provides a user-friendly interface with visual cues (e.g., hotspots) to guide users through the script conversion process.
- **Next Steps**: Post-conversion, the emphasis shifts to actual data migration, utilizing AWS DMS to complete the transition.


##  1.5. Integrating with third-party applications

- **Role of Third-Party Applications in Migration**: Third-party applications often rely on databases that must be supported during migration or may access migrated databases.
  
- **Database Compatibility**: Some third-party applications can access different databases, but they need to be tested to ensure functionality post-migration.
  
- **Application Upgrades**: Applications might require upgrades to be compatible with a new database system, which should be factored into the migration process.
  
- **Business Intelligence and ETL Tools**: Verify that third-party BI and ETL tools continue to function after migration; this may require tool upgrades or adapter/API changes.
  
- **Legacy Database Consideration**: For third-party applications tightly coupled with specific databases, decide whether to maintain the legacy database or migrate it.
  
- **Testing and Validation**: Identify and validate third-party applications to ensure they work correctly after migration.
  
- **Adapter/API Modifications**: Some tools may need adapter or API modifications to connect to new databases.
  
- **Next Steps**: After planning and preparation, proceed to data transfer using AWS DMS and supporting modernized applications.


##  1.6. Migrating data (AWS DMS)


- **Data Migration Overview**: The process of moving data records from a source to a target database, typically required during database migration. It can be challenging, especially with large data volumes or complex data types (e.g., LOBs, spatial data).
  
- **AWS DMS Use Cases**:
  - **Database Modernization**: Upgrade legacy databases to modern, cloud-ready, open-source engines.
  - **Database Migration**: Move data between platforms, either on-premises or in the cloud.
  - **Database Replication**: Continuously copy data to keep source and target databases in sync.

- **What is AWS DMS?**: A cloud service designed to facilitate the migration of relational databases, data warehouses, NoSQL databases, and other data stores to, from, or within the AWS Cloud.

- **AWS DMS Functionality**:
  - **Endpoint Concept**: Migrate data between source and target endpoints (databases), where at least one endpoint must be on AWS.
  - **Engine Compatibility**: Supports migrations between the same or different database engines (e.g., Oracle to PostgreSQL).
  
- **Migration Options**:
  - **Full-Load Migration**: Moves existing data from the source to the target.
  - **Ongoing Replication**: Uses change data capture (CDC) to keep the target in sync with a transactionally active source.
  - **Combined Approach**: Starts with a full load followed by ongoing replication.

- **Data Filtering and Transformation**: AWS DMS allows the selection of specific schemas or tables, filtering out unwanted records, and transforming data names to fit specific naming conventions.

- **Monitoring and Progress Tracking**:
  - **Replication Instance**: AWS DMS tasks run on Amazon EC2 instances configured with DMS software.
  - **Console Monitoring**: Real-time progress tracking, including the number of rows migrated, and access to detailed logs.

- **Data Validation**:
  - **Validation Option**: AWS DMS can validate the data migration to ensure that the source and target databases match, tracking progress incrementally as data is written to the target.

- **Post-Migration Steps**: After migrating schema and data, critical steps include testing, switching over production systems, and proper documentation.

##  1.7. Functionally testing entire system

1. **Confirm Migration Success**: Ensure the migration of schema, data, and applications to the target database has been completed as planned.

2. **Test Application Functionality**: Verify that all applications interacting with the database function correctly from a business perspective.

3. **Simulate Real-world Scenarios**: Test scenarios that reflect actual usage, such as order processing in a retail system.

4. **Involve Business Stakeholders**: Engage business stakeholders and analysts who understand user-facing applications to drive the testing process.

5. **Develop Test Cases**: Create test cases that cover various system boundaries and functional requirements.

6. **Verify Data Flow**: Check if data flows correctly through the system, including transactions and updates.

7. **Check Business Processes**: Ensure key business processes, like inventory management, work as expected.

8. **Perform End-to-End Testing**: Conduct end-to-end testing to validate that all integrated components of the system function together seamlessly.

9. **Monitor System Behavior**: Observe the system's behavior under different conditions to ensure stability and performance.

10. **Compare with Previous System**: Compare the functionality of the new system with the old one to confirm that no features are lost or broken.

11. **Validate User Interfaces**: Test user interfaces to ensure they interact correctly with the underlying database and system processes.

12. **Assess Error Handling**: Check how the system handles errors and edge cases to ensure robustness.

13. **Review System Boundaries**: Test the boundaries of the system to ensure it performs correctly under different conditions and loads.

14. **Ensure Data Integrity**: Verify that data integrity is maintained throughout the system after migration.

15. **Document Issues**: Record any issues or discrepancies encountered during testing and address them accordingly.

16. **Review and Sign Off**: Have business stakeholders review the results and provide sign-off to confirm the system is functioning as expected.


##  1.8. Tuning Performance

1. **Understand Performance Criteria**:
   - Identify specific performance criteria for your application, such as response times or throughput, based on functional testing requirements.

2. **Set Performance Benchmarks**:
   - Define benchmarks for performance, such as sub-second response times for interactive screens, to ensure a quality customer experience.

3. **Monitor During Migration**:
   - Monitor application performance continuously during the migration process to ensure it meets the established benchmarks.

4. **Parallel Functional Testing**:
   - Conduct performance tuning activities concurrently with functional testing to address any performance issues as they arise.

5. **Identify Bottlenecks**:
   - Investigate and identify potential bottlenecks at various system levels, including user-facing applications, SQL queries, database engines, and storage layers.

6. **Check SQL Statements**:
   - Review and optimize SQL statements prepared by the application to improve query performance and reduce execution time.

7. **Analyze Database Performance**:
   - Evaluate database engine performance, including indexing, query optimization, and resource allocation, to address performance issues.

8. **Examine Storage Layers**:
   - Assess the performance of associated storage layers to ensure they are not causing delays or bottlenecks.

9. **Collaborate with Stakeholders**:
   - Engage both business stakeholders and technical personnel to work together in identifying and resolving performance issues.

10. **Verify Issue Resolution**:
    - Confirm that identified performance issues are resolved effectively and that the application meets performance benchmarks.

11. **Implement Remediation**:
    - Apply appropriate remediation strategies if performance issues persist, ensuring they align with business needs and objectives.

12. **Continuous Improvement**:
    - Continuously monitor and refine performance tuning efforts to adapt to changing requirements and improve overall system efficiency.

13. **Performance Metrics Tracking**:
    - Track and analyze performance metrics to measure improvements and identify any new issues that may arise.

14. **Feedback Loop**:
    - Use feedback from performance monitoring and testing to make iterative improvements and ensure ongoing performance optimization.

15. **Document Changes**:
    - Document all performance tuning activities, changes made, and their impact on the application to maintain a record for future reference.

16. **Regular Reviews**:
    - Conduct regular reviews of performance tuning practices to ensure they remain effective and relevant to the evolving application landscape.



##  1.9. Integrating and deploying (AWS DMS)

1. **Minimize Downtime**: Aim for minimal downtime during the switch to the new database system. This can involve careful planning to ensure the migration fits within specified time windows and may be done in phases.

2. **Integration Process**:
   - **Initial Setup**: Begin by connecting your applications to the original database.
   - **Full-Load Migration**: Use AWS DMS to perform a complete migration of the database.
   - **Ongoing Replication**: Set up continuous data replication to keep the target database synchronized.

3. **Deployment Process**:
   - **Cutover Strategy**: Define how and when applications will be cut over to the new database system. This could be done in phases or all at once, depending on business needs.
   - **Application Transition**: Transition individual applications to the new database as planned.

4. **Rollback Planning**:
   - **Prepare for Rollback**: Have a rollback plan in case you need to revert to the original database system.
   - **Test Rollback**: Test the rollback procedures in a preproduction environment to ensure preparedness.

5. **Post-Migration Considerations**:
   - **Document New System State**: Record the details of the new system setup and configuration.
   - **Training**: Provide training for users and administrators on the new system.
   - **Post-Production Support**: Plan for ongoing support and maintenance after the migration.

6. **Testing**: Ensure that the migration and integration are thoroughly tested to avoid issues during the cutover process.

7. **Monitoring**: Implement monitoring to check the performance and health of the new system post-deployment.

8. **Data Consistency**: Verify data consistency between the source and target databases after migration to ensure accuracy.

9. **Performance Tuning**: Optimize the new database system for performance based on post-migration observations.

10. **Backup and Recovery**: Ensure that backup and recovery processes are updated and tested for the new database system.

11. **Security**: Review and apply necessary security configurations and policies for the new system.

12. **Compliance**: Ensure that the new database system complies with relevant regulatory and compliance requirements.

13. **Documentation**: Maintain detailed documentation of the migration process, including configurations and decisions made.

14. **User Feedback**: Collect feedback from users to identify any issues or areas for improvement in the new system.

15. **Continuous Improvement**: Use the feedback and post-deployment monitoring to make ongoing improvements to the database system.

16. **Integration with Other Systems**: Ensure that the new database integrates properly with other systems and applications in your environment.

##  1.10. Training and transferring knowledge
 
1. **Assess Training Needs**: Identify the need for training on the new database engine, AWS, and AWS RDS based on your team's familiarity with these technologies.

2. **Plan Training Sessions**: Allocate time for team training to cover new technologies and processes introduced by the migration.

3. **Document Changes**: Ensure that all changes made during the migration, such as modifications to tables, stored procedures, and application code, are documented.

4. **Share Knowledge**: Distribute documentation and insights gained during the migration to team members responsible for maintaining the application.

5. **Manage Resistance to Change**: Prepare to address resistance from team members who may be reluctant to adopt new technologies or changes in procedures.

6. **Acknowledge Cultural Shifts**: Recognize that migration to the cloud involves changes in technology and mindset, and manage the cultural aspects associated with this transition.

7. **Understand Status Changes**: Be aware that the perceived value of team members may shift due to the introduction of new technologies and cloud environments.

8. **Handle Organizational Politics**: Navigate potential organizational politics and ensure transparency to ease the transition process.

9. **Develop New Management Features**: Create or adapt features for managing the new environment, such as monitoring and paging, as some previous tools may no longer be applicable.

10. **Prepare for Technical Hurdles**: Anticipate and plan for technical challenges associated with new tools and environments.

11. **Train on New Tools**: Provide training for any new tools or features introduced in the new environment.

12. **Encourage Continuous Learning**: Promote an ongoing learning culture to help the team adapt to evolving technologies and methodologies.

13. **Document Best Practices**: Share best practices and lessons learned during the migration to enhance future projects and processes.

14. **Support Team Adaptation**: Offer support and resources to help team members adapt to new roles or changes in their responsibilities.

15. **Monitor Progress**: Track the progress of training and adaptation to ensure that all team members are becoming proficient with the new technologies.

16. **Review and Adjust Training Programs**: Regularly review the effectiveness of training programs and make adjustments based on feedback and evolving needs.

##  1.11. Documenting and Controlling Versions

1. **Importance of Documentation**: 
   - Essential for system deployment and operations.
   - Document all system changes and operational procedures.

2. **Infrastructure as Code (IaC)**: 
   - AWS supports IaC, allowing management of cloud infrastructure with code.

3. **Script All Steps**: 
   - Use scripting to document the creation and configuration of your infrastructure.

4. **Version-Control Systems**: 
   - Employ version control for all infrastructure changes.
   - Code reviews should be required for database and server infrastructure modifications.

5. **AWS Tools**:
   - **AWS CloudFormation**: Manages AWS resources programmatically.
   - **AWS Cloud Development Kit (CDK)**: Allows programmatic management of AWS resources.

6. **Database Management**:
   - Script the creation of Amazon RDS instances and clusters, including backups.
   - Use AWS OpsWorks for database server configuration and management if preferred.

7. **Resource Creation Best Practices**:
   - Prefer AWS CloudFormation templates or similar tools for creating AWS resources.
   - Manage database schemas as source code.

8. **Code as Artifacts**:
   - Treat infrastructure and database artifacts as code for consistency and version control.

9. **Code Reviews**:
   - Implement code reviews for infrastructure changes to ensure quality and stability.

10. **Automation**:
    - Automate the provisioning and management of resources where possible.

11. **Backup and Recovery**:
    - Include backup processes in your infrastructure scripts for disaster recovery.

12. **Change Management**:
    - Document and track changes to infrastructure to maintain a clear history of modifications.

13. **Security and Compliance**:
    - Ensure that changes comply with security policies and regulatory requirements.

14. **Testing**:
    - Test infrastructure changes in a staging environment before applying them to production.

15. **Documentation Updates**:
    - Regularly update documentation to reflect current infrastructure and operational procedures.

16. **Tool Integration**:
    - Integrate with other AWS services and tools for a cohesive infrastructure management strategy.


##  1.12. Planning for Support in Post-Production

### Planning for Support in Post-Production

1. **Assess Post-Migration Support Needs:**
   - Determine the types of support your application will require once migration is complete.

2. **Automate Routine Tasks:**
   - Use AWS tools to automate backups and other regular support tasks.

3. **Schedule Regular Checks:**
   - Regularly verify that automated tasks are functioning as expected.

4. **Allocate Personnel:**
   - Assign staff to handle tasks that cannot be automated.

5. **Develop a Support Plan:**
   - Create a comprehensive plan detailing the support activities needed post-migration.

6. **Monitor Application Performance:**
   - Continuously monitor the performance of the migrated application to ensure it meets expectations.

7. **Handle Unexpected Issues:**
   - Plan for potential issues that may arise and establish procedures for resolving them.

8. **Update Documentation:**
   - Ensure that documentation is updated to reflect the new environment and support procedures.

9. **Train Support Staff:**
   - Provide training for staff to handle the specific needs of the migrated application.

10. **Implement Incident Response:**
    - Develop an incident response plan for handling emergencies or unexpected outages.

11. **Review and Adjust Support Resources:**
    - Periodically review support resources and adjust as necessary to address evolving needs.

12. **Ensure Compliance:**
    - Verify that the support plan adheres to any relevant compliance and regulatory requirements.

13. **Backup Verification:**
    - Regularly test backups to ensure data integrity and recovery capabilities.

14. **Review Automated Tasks:**
    - Periodically review and adjust automated tasks to optimize performance and efficiency.

15. **Communicate with Stakeholders:**
    - Keep stakeholders informed about support processes and any issues that arise.

16. **Evaluate Support Effectiveness:**
    - Assess the effectiveness of your support plan and make improvements as needed.



# 2. Amazon Simple Storage Service (Amazon S3) Cost Optimization


##  2.1. Introduction to optimizing Amazon S3 costs


1. **Cost Optimization Overview**:
   - Start with understanding your storage characteristics by focusing on four pillars of optimization.

2. **Four Pillars of Cost Optimization**:
   - **Application Requirements**: Define performance and access needs.
   - **Data Organization**: Properly categorize and manage your data.
   - **Understanding Access Patterns**: Analyze how data is accessed and adjust storage strategies accordingly.
   - **Continuous Right-Sizing**: Regularly adjust storage types based on usage patterns.

3. **Analyzing Data Access Patterns**:
   - **Predictable Workloads**: Use Amazon S3 Storage Class Analysis to track access patterns and adjust lifecycle policies.
   - **Unpredictable Workloads**: Use S3 Intelligent-Tiering to automatically move data across multiple access tiers.

4. **S3 Intelligent-Tiering Details**:
   - Optimizes cost by moving data between frequent, infrequent, and archival tiers.
   - Can save up to 95% on costs compared to standard storage.
   - Offers low-latency performance with no retrieval or lifecycle charges.

5. **Data Organization Tools**:
   - **Amazon S3 Inventory**: Audits and reports on object replication and encryption statuses.
   - **Amazon S3 Server Access Logging**: Provides detailed records of bucket requests for security and usage insights.
   - **AWS CloudTrail Logs**: Monitors and logs AWS account activity for auditing and compliance.

6. **Using Data Organization Tools Together**:
   - Combine S3 Inventory, Server Access Logs, and CloudTrail to assess data usage and optimize storage costs.

7. **Tagging and Cost Allocation**:
   - Use object tags to categorize data.
   - Employ cost allocation tags for better cost tracking and organization.

8. **Cost and Usage Monitoring Tools**:
   - **S3 Storage Class Analysis**: Monitors object access patterns for cost-effective storage transitions.
   - **Amazon QuickSight**: Visualizes S3 data with BI dashboards for actionable insights.
   - **S3 Storage Lens**: Provides visibility into storage usage and trends.
   - **Amazon CloudWatch**: Offers insights into application performance and resource utilization.
   - **AWS Budgets**: Customizable budgeting tool for tracking cost and usage.
   - **AWS Cost and Usage Reports**: Detailed billing and usage reports.


##  2.2. Storage Class Analysis

- **Purpose**: Amazon S3 Storage Class Analysis helps monitor access patterns to optimize data storage costs by transitioning data to appropriate storage classes.
- **Data Access Patterns**: It aids in understanding which data is accessed frequently (hot) versus infrequently (warm or cold).
- **Visualization**: Provides daily visualizations of storage usage on the AWS Management Console, which can be exported for further analysis.
- **Cost Optimization**: Helps determine when to transition data to less frequently accessed storage classes, reducing overall storage costs.
- **Configuration Options**:
  - **Entire Bucket**: Analyze the entire contents of an S3 bucket.
  - **Prefix and Tags**: Configure filters by prefix, object tags, or a combination to group objects. You can set up to 1000 filter configurations per bucket.
- **Exports**: Daily exports of analysis data can be configured, creating a historical log. Files are updated daily in your chosen destination.
- **Report Generation**: Initial reports are generated after 24 hours, with daily updates thereafter.
- **Data Handling**: Exported CSV files can be opened with spreadsheet applications or imported into other tools. Data is sorted by date and object age group.
- **Analysis Tools**: Use Amazon QuickSight or other business intelligence tools to analyze and report on the data gathered from storage class analysis.
- **Permissions**: Specific permissions are required for accessing and managing Amazon S3 Storage Class Analysis (details provided in the linked documentation).
- **Application**: Helps make informed decisions about data placement in storage classes, further aiding cost reduction.
- **Report Details**: Reports include columns that provide insights into data access patterns and can be customized based on the configuration.
- **Long-Term Monitoring**: Provides ongoing monitoring and data updates to continuously optimize storage usage.
- **Scenario Updates**: Learn to interpret and act on analysis reports for effective data management.


##  2.3. Amazon QuickSight

- **Amazon QuickSight Overview**: Cloud-scale business intelligence (BI) service for data visualization and insights.
- **Integration with Amazon S3**: Uses Amazon S3 analytics data to understand data usage and growth patterns.
- **Visualization Access**: Visualizations are accessible directly through the Amazon S3 console, eliminating the need for manual data exports.
- **Pre-built Visuals**: Offers pre-built visuals to help understand storage access patterns of S3 buckets.
- **Dashboards**: A collection of charts, graphs, and insights updated with the latest data. Interactions with the dashboard are personal and do not affect others' views.
- **Data Analysis**: Requires enabling Storage Class Analysis on S3 buckets to observe and analyze access patterns over time.
- **Access Permissions**: QuickSight must be granted access to S3 buckets to gather or read export files.
- **Storage Class Analysis**: Observes data access patterns and can automatically send this data to QuickSight for analysis.
- **Usage Insights**: Provides insights into data access frequency, helping identify infrequently accessed files.
- **Cost Management**: Enables configuration of rules to move infrequently accessed files to lower-cost storage tiers.
- **Lifecycle Policies**: Learn how to use Lifecycle Policies to manage data movement between storage tiers based on access patterns.
- **Interactive Features**: Dashboards are interactive, allowing for real-time data exploration and analysis.
- **Comprehensive Analysis**: QuickSight offers comprehensive analysis tools for understanding data growth and access patterns.
- **User-specific Views**: Changes made to dashboards are specific to the user's view and do not impact others.
- **Further Learning**: Additional resources and customer examples can be explored for deeper understanding and practical applications.
- **Pricing Information**: Details on QuickSight pricing can be found through the provided Amazon link.


##  2.4. S3 Lifecycle policies

- **Purpose**: S3 Lifecycle policies manage object storage cost-effectively throughout their lifecycle by automatically transitioning objects to different storage classes or deleting them based on their age.
  
- **Supported Transitions**: Policies enable transitioning objects between storage classes (e.g., S3 Standard to S3 Intelligent-Tiering) based on object creation dates. The transitions follow a downward, waterfall model where objects can move to lower-cost storage classes but cannot move back to higher-cost ones.

- **Object Size Constraints**: 
  - Objects larger than 128 KB benefit from transitioning between storage classes.
  - Transitioning smaller objects (less than 128 KB) is not cost-effective.
  
- **Use Cases**:
  - **Application Logs**: Transition logs to cheaper storage after a certain period and eventually delete them.
  - **Limited Time Access**: Archive infrequently accessed documents after their immediate need has passed.
  - **Archival**: Use S3 for long-term archival of media, records, and backups for compliance purposes.

- **Lifecycle Configuration and Versioning**:
  - Rules can be applied to both versioned and unversioned buckets.
  - Different rules can be set for current and noncurrent object versions.
  
- **Object Expiration**:
  - Expired objects are queued for removal and deleted asynchronously.
  - No charge for storage time of expired objects.
  
- **Versioning-Enabled Buckets**:
  - Expiration actions add a delete marker with a unique version ID for the current version.
  
- **Versioning-Suspended Buckets**:
  - Creates a delete marker with a null version ID, effectively deleting the object.
  
- **Non-Versioned Buckets**:
  - Objects are permanently deleted upon expiration.
  
- **Minimum Storage Duration**:
  - Objects must remain in S3 Standard for at least 30 days before transitioning to S3 Standard-IA or S3 One Zone-IA.
  - Minimum storage duration of 30 days applies to objects in S3 Intelligent-Tiering, S3 Standard-IA, and S3 One Zone-IA, with pro-rated charges if deleted early.

- **Unsupported Configurations**:
  - Lifecycle configuration is not supported on MFA-enabled buckets.
  - Lifecycle actions are not logged by AWS CloudTrail; use Amazon S3 Server access logs for tracking.

- **Multipart Uploads**:
  - Used for uploading large objects by splitting them into parts, uploading them in parallel, and reassembling them.
  - Ideal for objects over 100 MB or when network conditions are unreliable.

- **Cost Considerations**:
  - Ensure that transitions and storage policies align with cost management and operational efficiency.

- **Additional Resources**:
  - Videos and tutorials are available to demonstrate the configuration of lifecycle policies.


##  2.5. Archiving for Cost Savings

1. **Purpose of Archiving**:
   - Archiving is designed for long-term data preservation and retention, helping to lower storage costs and manage data effectively.

2. **Amazon S3 Glacier Storage Classes**:
   - **S3 Glacier Instant Retrieval**:
     - Provides instant access to archived data with milliseconds retrieval time.
     - Stored across multiple AWS Availability Zones.
     - Includes retrieval fees per GB and a minimum object size of 128 KB.
     - Suitable for data requiring immediate access and long-term retention.

   - **S3 Glacier Flexible Retrieval**:
     - Allows access to archived data in minutes, with retrieval options including expedited (1-5 mins), standard (3-5 hours), and bulk (5-12 hours).
     - Free bulk retrievals, with retrieval fees for non-bulk requests.
     - Minimum storage duration of 90 days.
     - Useful for large data sets not needing immediate access.

   - **S3 Glacier Deep Archive**:
     - Offers the lowest cost storage with retrieval within a few hours.
     - Ideal for large amounts of data needing long-term storage.
     - Minimum duration requirement of 180 days.
     - Best for data that is rarely accessed but needs to be retained.

3. **Uploading Data**:
   - Direct uploads are possible for data from 1 byte to 5 GB.
   - For larger files, multipart uploads are recommended to handle large objects efficiently.

4. **AWS Storage Gateway**:
   - **File Gateway**: Provides access to S3 for file storage.
   - **Volume Gateway**: Offers block storage.
   - **Tape Gateway**: Replaces physical tapes with virtual tapes in AWS, supports existing backup workflows, and provides cost-effective storage.

5. **AWS Snowball Edge**:
   - Facilitates large-scale data transfers with on-board storage and compute capabilities.
   - Data can be imported directly into S3 Glacier Deep Archive for cost-effective long-term storage.

6. **Retrieval Options**:
   - **Expedited Retrieval**: Available within 1-5 minutes with provisioned capacity.
   - **Standard Retrieval**: Typically 3-5 hours for S3 Glacier Flexible Retrieval, and 12 hours for S3 Glacier Deep Archive.
   - **Bulk Retrieval**: Free for S3 Glacier Flexible Retrieval, 5-12 hours completion, and 48 hours for S3 Glacier Deep Archive.

7. **Provisioned Capacity**:
   - Allows paying a fixed fee to ensure retrieval capacity for expedited requests.

8. **Monitoring Restores**:
   - S3 Glacier storage classes must complete restore requests before data is accessible.
   - Notifications can be set up via Amazon SNS or periodically checked using the describe job operation.

9. **Cost Benefits**:
   - Using S3 Glacier storage classes helps in reducing long-term storage costs compared to physical backups.

10. **Compliance and Security**:
    - Provides compliance controls for regulatory requirements and ensures secure data transfer and storage.

11. **Transitioning Data**:
    - Data can transition between different S3 Glacier classes based on changing needs and cost considerations.

12. **Integration with Existing Backup Solutions**:
    - AWS Storage Gateway supports transitioning from physical to virtual tapes, simplifying backup processes and reducing costs.

13. **Use Cases**:
    - Best suited for long-term data retention, regulatory compliance, and archival of rarely accessed data.

14. **Archive Management**:
    - Helps in managing large volumes of data cost-effectively while ensuring data integrity and availability.

15. **Training Resources**:
    - AWS Training Dashboard offers additional resources to deepen knowledge of S3 Glacier storage classes.


##  2.6. Amazon S3 Storage Lens

1. **Centralized Visibility**: Provides a single view of object storage usage and activity across multiple AWS accounts within an organization.
2. **Granular Metrics**: Offers metrics pre-aggregated by up to six levels, including account, Region, storage class, bucket, prefix, and AWS Organization.
3. **Cost Efficiency**: Produces actionable recommendations to help improve cost-efficiency and apply best practices for data protection.
4. **No Performance Impact**: Does not impact performance while using S3 Storage Lens.
5. **Interactive Dashboard**: Displays metrics in an interactive dashboard on the Amazon S3 console or through CSV/Parquet data exports.
6. **Data Visualization**: Allows visualization of insights, trends, and outliers with recommendations for optimizing storage costs.
7. **Access Control**: Requires specific IAM permissions to access S3 Storage Lens actions; root user credentials cannot be used.
8. **Integration with AWS Management**: Can be controlled through the AWS Management Console, CLI, SDKs, or REST API.
9. **IAM Permissions**: Necessary to grant permissions to IAM users, groups, or roles to enable/disable S3 Storage Lens and access dashboards.
10. **AWS Organizations Integration**: Collects metrics and usage data for all accounts in an AWS Organization, with trusted access enabled through AWS Organizations APIs.
11. **Delegated Administration**: Allows creation of organization-wide dashboards and configurations by delegated administrators.
12. **Custom Dashboards**: Supports the creation of default and custom dashboards for tailored views and analyses.
13. **Recommendations and Alerts**: Provides recommendations and call-outs for improvements and reminders for best practices.
14. **Trusted Service**: Once activated, S3 Storage Lens becomes a trusted service within your AWS Organization’s hierarchy.
15. **Data Export**: Metrics can be exported in CSV or Parquet format for detailed analysis.
16. **No Root Access**: Dashboards cannot be accessed using root user credentials; IAM permissions are required for access.

##  2.7. Amazon S3 Storage Lens and Amazon CloudWatch

- **Amazon CloudWatch Overview**:
  - Amazon CloudWatch is a monitoring and observability service that provides actionable insights into cloud infrastructure.
  - It functions as a metrics repository where AWS services, such as Amazon S3, store and manage metrics.
  - Users can retrieve and analyze these metrics to generate graphical representations in the CloudWatch console.

- **Key Elements of CloudWatch**:
  - **Metrics**: Quantitative data collected from various AWS services.
  - **Dimensions**: Categories used to filter metrics.
  - **Filters**: Criteria to refine and view specific metrics.
  - **Dashboards**: Customizable views to visualize metric data.
  - **Alarms**: Notifications based on metric thresholds and conditions.

- **CloudWatch Metrics for Amazon S3**:
  - Provides detailed metrics to monitor the performance of applications using Amazon S3.
  - Metrics data is retained for 15 months, offering long-term insights into application performance.
  - Includes different categories of metrics, each offering unique monitoring options.

- **Using CloudWatch for Forecasting and Budgeting**:
  - CloudWatch metrics can help forecast costs and manage budgets.
  - Integration with AWS Budgets allows for tracking and reporting on S3 storage consumption.
  - Enables the creation of monthly reports to meet leadership team requests.

- **Graphic Illustration**:
  - A graphic shows the process of CloudWatch collecting, monitoring, acting on, and analyzing metrics.


##  2.8. Viewing, budgeting, and forecasting your Amazon S3 costs


### Introduction to AWS Budgets
- **AWS Budgets**: Allows you to track and take action on AWS cost and usage.
- **Custom Budgets**: Set and manage custom budgets for costs, usage, reservation utilization, or coverage.
- **Alerts**: Get notifications when costs or usage exceed budget thresholds or are forecasted to exceed.
- **Metrics**: Track monthly fixed targets, variable targets, fixed usage amounts, and daily utilization.

### Best Practices for Setting Budgets
1. **Custom Budgets**: Set budgets based on costs, usage, and reservation metrics.
2. **Recurring Budgets**: Establish budgets on a recurring basis to ensure continuous monitoring.
3. **Alert Recipients**: Budget alerts can be sent to up to 10 email addresses and one Amazon SNS topic.
4. **Forecast Alerts**: Forecast-based alerts might be sent multiple times within a budget period if forecasted values fluctuate.
5. **Historical Data**: AWS needs approximately five weeks of usage data to generate accurate budget forecasts.

### AWS Budgets Tutorial
- **Tutorial Access**: Learn more about managing AWS costs through the provided tutorial.

### Cost and Usage Reports
- **AWS Cost and Usage Reports (CUR)**: Provides detailed information on individual costs and usage, useful at an enterprise scale.
- **Report Access**: Download from Amazon S3 console, query with Amazon Athena, or upload into Amazon Redshift/QuickSight.

### Billing Reports
- **Types**: Monthly report, cost allocation report, and detailed billing report.
- **Billing Responsibility**: The S3 bucket owner is billed for S3 fees unless the bucket is a Requester Pays bucket.

### Cost Allocation Tags
- **Purpose**: Assign metadata to resources to help categorize and track costs.
- **Types**:
  - **AWS Generated Tags**: Automatically applied for cost allocation, but may have gaps.
  - **User-Defined Tags**: Created and applied by users, activated via Billing and Cost Management console.

### Usage Reports
- **Dynamic Reports**: Allow selection of usage type, operation, and time period.
- **Formats**: Downloadable as XML or CSV files.

### Downloading Reports
- **Report Size**: CUR reports can be large and may be split into multiple files if they exceed application capacity.
- **Access Methods**: Download from Amazon S3 console, query with Athena, or upload to Redshift/QuickSight.

### Final Note
- **Engagement Complete**: With these tools and practices, you should now have a better understanding of managing and forecasting your storage utilization costs on AWS.


# 3. Deep Dive: Amazon Elastic Block Store (Amazon EBS) Cost Optimization


##  3.1. AWS Well-Architected Cost Optimization Pillar

1. **Cost-Optimized Workloads**:
   - Achieve outcomes at the lowest possible price while meeting functional requirements.
   - Fully utilize resources to minimize costs.

2. **AWS Well-Architected Framework**:
   - Helps understand the pros and cons of decisions while building systems on AWS.
   - Provides architectural best practices for secure, reliable, efficient, and cost-effective systems.

3. **Pillars of the AWS Well-Architected Framework**:
   - Security
   - Operational Excellence
   - Reliability
   - Performance Efficiency
   - Cost Optimization

4. **Cost Optimization Pillar Objectives**:
   - Practice Cloud Financial Management.
   - Be aware of expenditure and usage.
   - Implement cost-effective resources.
   - Manage demand and supply of resources.
   - Optimize over time.

5. **Design Principles**:
   - **Implement Cloud Financial Management**: Develop processes for managing cloud costs effectively.
   - **Adopt a Consumption Model**: Use services based on actual consumption rather than fixed costs.
   - **Measure Overall Efficiency**: Evaluate the efficiency of your resources and their cost-effectiveness.
   - **Stop Spending on Undifferentiated Heavy Lifting**: Avoid unnecessary costs associated with managing infrastructure that can be outsourced or automated.
   - **Analyze and Attribute Expenditure**: Understand and allocate costs to different business units or projects.

6. **Applying Cost Optimization to Amazon EBS**:
   - **Select Appropriate Volume Types**: Choose the right Amazon EBS volume type based on performance and cost.
   - **Size Your EBS Volumes**: Ensure that volumes are appropriately sized to avoid over-provisioning or under-provisioning.
   - **Monitor Volume Performance**: Regularly review EBS volume performance to optimize size and cost.
   - **Manage Snapshot Retention**: Optimize costs related to EBS snapshots by managing their retention and lifecycle.

7. **Continuous Improvement**:
   - Cost optimization is an ongoing process of refinement throughout a workload's lifecycle.
   - Regularly review and adjust to achieve better cost management and efficiency.

For more detailed information, refer to the [AWS Well-Architected Framework documentation](https://aws.amazon.com/well-architected/).


##  3.2. Common Amazon EBS Cost Optimization Opportunities

1. **Delete Inactive or Unattached EBS Volumes**:
   - Regularly monitor and remove unused EBS volumes.
   - High-performance volumes like Provisioned IOPS io2 can be costly if unused.
   - Clean up unused EBS volumes and snapshots of removed EC2 AMIs to reduce costs.

2. **Avoid Over-Provisioning EBS Volumes**:
   - Provision volumes according to actual needs rather than anticipated future requirements.
   - Use dynamic volumes that can expand on-demand instead of over-sizing.

3. **Avoid Over-Sizing Provisioned Performance Options**:
   - Be cautious with provisioned performance for EBS volumes.
   - Utilize performance options that do not require increased capacity to save costs.

4. **Use Newer EBS Volume Types**:
   - Transition to newer volume types like gp3 and io2 Block Express for cost savings.
   - Newer volume types often offer lower base pricing and better performance-to-capacity ratios.

5. **Use Lower-Cost EBS Volume Types**:
   - Opt for lower-cost volume types when they meet your performance needs.
   - Consider gp3 volumes as a cost-effective alternative to higher-cost volume types.

6. **Design Efficient DLM Policies**:
   - Implement Data Lifecycle Manager (DLM) policies to retain only necessary snapshots.
   - Regularly clean up snapshots to optimize storage costs.

7. **Use EBS Snapshots Archive**:
   - Store long-term archival snapshots in lower-cost EBS Snapshots Archive.
   - This tier offers reduced pricing compared to standard snapshots.

8. **Utilize AWS Backup for Archival**:
   - Use AWS Backup for creating and managing archival data copies.
   - AWS Backup allows you to tier backups to lower-cost storage options, providing cost efficiency.

9. **Back Up Data Before Deleting Volumes**:
   - Ensure important data is backed up using AWS Backup or transferred to lower-cost storage like Amazon S3 before deleting volumes.

10. **Monitor and Adjust Performance Levels**:
    - Regularly assess and adjust performance levels to match actual usage and requirements.

11. **Clean Up Old AMIs and Snapshots**:
    - Remove outdated EC2 AMIs and associated snapshots to reduce unnecessary charges.

12. **Consider Data Retention Policies**:
    - Verify data retention needs and set policies accordingly to avoid unnecessary costs from retained data.

13. **Explore Volume Type Migration**:
    - When migrating to new volume types, adjust provisioned capacity and performance to match your needs and cost objectives.

14. **Utilize Elastic Volumes**:
    - Leverage Elastic Volumes for dynamic scaling of both performance and capacity to control costs effectively.

15. **Analyze Cost vs. Performance**:
    - Regularly evaluate the cost versus performance of EBS volumes to ensure cost-efficiency.

16. **Stay Updated on New Volume Types**:
    - Keep informed about AWS innovations and new EBS volume types to take advantage of the latest cost-saving options.


##  3.3. AWS Pricing Considerations for Amazon EBS

1. **Pay-as-You-Go**: With AWS, you pay only for what you use. For Amazon EBS, this means you pay based on provisioned volume size and performance metrics (IOPS and throughput).

2. **Pricing Based on Volume Type**: Pricing for EBS volumes varies by the volume type and the AWS Availability Zone in which they reside.

3. **Snapshot Pricing**: The cost for Amazon EBS Snapshots is based on the storage capacity consumed by the snapshots.

4. **Volume Type Costs**: EBS volume pricing is per GB-month for the provisioned capacity, and performance costs (IOPS and throughput) are also calculated per month.

5. **Performance Costs**: 
   - **Provisioned IOPS**: Priced per IOPS-month.
   - **Provisioned Throughput**: Priced per megabytes per second per month (MB/s-month).

6. **Regional Pricing Variability**: EBS volume pricing can vary by AWS Region.

7. **Instance Stores vs EBS Volumes**:
   - **Instance Stores**: Included in the EC2 instance cost, suitable for temporary data, and do not support EBS Snapshots or AWS Backup.
   - **EBS Volumes**: Charged separately from EC2 instances and persist independently of instance state.

8. **Cost Optimization**:
   - **Instance Stores**: Can reduce costs if the data is ephemeral and can be recreated.
   - **EBS Volumes**: You pay for the EBS volumes for the duration they are provisioned, regardless of their attachment status.

9. **Volume Type Selection**: Performance characteristics of EBS volumes can overlap. Choose based on cost-effectiveness to meet performance requirements.

10. **Performance Considerations**:
    - Minimum storage size needed.
    - IOPS and throughput performance profiles.
    - Latency and data durability requirements.

11. **Volume Type Comparison**: Compare volume types based on performance profiles and cost to select the most appropriate and cost-effective option.

12. **Latency Requirements**: Consider sub-millisecond latency offered by instance stores versus EBS volumes.

13. **Data Durability**: Evaluate how data durability needs influence the choice between instance stores and EBS volumes.

14. **EBS Volume Management**: Costs are incurred for EBS volumes for their entire existence, whether they are attached to an instance or not.

15. **Cost Calculation**: Calculate costs based on provisioned volume size, IOPS, throughput, and storage consumed by snapshots.

16. **Review and Adapt**: Regularly review your EBS volume types and configurations to ensure cost-efficiency as new volume types become available.


##  3.4. Amazon EBS Pricing

1. **Cost Structure**:
   - Pricing is based on provisioned volume size, IOPS, and throughput.
   - Charged per GB-month for volumes, IOPS-month for provisioned IOPS, and MB/s-month for throughput.
   - Billing is based on seconds of actual use, with a 30-day month considered.

2. **Provisioned Volume Size**:
   - Costs are calculated based on the total GB provisioned for the volume.
   - Formula: \[(Provisioned GB) * (price per GB-month)\] / (1 month).

3. **Provisioned IOPS**:
   - Costs are for IOPS exceeding the baseline amount.
   - Ratios for IOPS-to-volume size vary by volume type (e.g., gp3 has 500:1 ratio).

4. **Provisioned Throughput**:
   - Costs are for throughput exceeding the base amount.
   - Example: gp3 volumes have a base of 125 MB/s; additional throughput incurs extra charges.

5. **Pricing by Volume Type**:
   - **General Purpose SSD gp2**: Billed per GB-month with I/O included; no separate IOPS or throughput options.
   - **General Purpose SSD gp3**: Billed per GB-month with free baseline performance; additional IOPS and throughput billed separately.
   - **Provisioned IOPS SSD io1**: Billed per GB-month and provisioned IOPS; no baseline IOPS.
   - **Provisioned IOPS SSD io2**: Billed per GB-month and provisioned IOPS with tiered pricing for high IOPS.

6. **SSD-backed Volumes**:
   - **gp2**: I/O included; performance scales with volume size.
   - **gp3**: Includes baseline performance; additional IOPS and throughput can be provisioned independently.

7. **HDD-backed Volumes**:
   - **st1 (Throughput Optimized HDD)**: Billed per GB-month; performance scales with volume size.
   - **sc1 (Cold HDD)**: Billed per GB-month; I/O included and performance scales with volume size.

8. **Example Calculations**:
   - **gp2**: Cost for 2,000 GB volume for 12 hours: $3.33.
   - **gp3**: Cost for 2,000 GB volume, 10,000 IOPS, 500 MB/s throughput for 12 hours: $3.63.
   - **io1**: Cost for 2,000 GB volume, 1,000 IOPS for 12 hours: $5.25.
   - **io2**: Cost for 2,000 GB volume, 60,000 IOPS for 12 hours: $60.30.
   - **st1**: Cost for 2,000 GB volume for 12 hours: $1.50.
   - **sc1**: Cost for 2,000 GB volume for 12 hours: $0.50.

9. **Elastic Volumes**:
   - You can only increase volume sizes within the same volume. To decrease, you need to copy data to a new volume.

10. **Regional Pricing**:
    - Prices vary by AWS Region; examples are based on US East (N. Virginia).

11. **Provisioning Impact**:
    - Provisioning affects minimum volume sizes for IOPS and throughput; each volume type has specific ratios and requirements.

12. **Tiered Pricing for io2**:
    - io2 volumes offer tiered pricing for high IOPS, which reduces costs as IOPS increase.

13. **Billing Increment**:
    - Billed in per-second increments with a minimum of 60 seconds.

14. **Snapshot Pricing**:
    - Additional information available on the Amazon EBS Pricing page.

15. **Performance Scaling**:
    - For SSD-backed volumes, performance scales with volume size; HDD-backed volumes scale similarly without separate IOPS or throughput options.


##  3.5. AWS EBS Volume Type Pricing Comparisons


### General Pricing and Sizing Requirements
1. **gp2 Volumes**
   - Increase sustained IOPS and throughput by increasing volume capacity.
   - 3 IOPS per GB of storage (e.g., 900 sustained IOPS requires 300 GB).
   - No separate IOPS provisioning; costs are based on provisioned volume capacity.

2. **gp3 Volumes**
   - Separate provisioning for volume capacity, IOPS, and throughput.
   - Includes 3,000 IOPS and 125 MB/s throughput by default.
   - 500:1 IOPS ratio (e.g., 5,000 IOPS requires 10 GB).
   - Costs include volume capacity, extra IOPS above 3,000, and throughput above 125 MB/s.

3. **io1 Volumes**
   - Separate provisioning for volume capacity and IOPS.
   - 50:1 IOPS ratio (e.g., 5,000 IOPS requires 100 GB).
   - Costs are based on provisioned volume capacity and IOPS.
   - Provisioned IOPS charged flat up to 64,000 IOPS.

4. **io2 Volumes**
   - Separate provisioning for volume capacity and IOPS.
   - 500:1 IOPS ratio (e.g., 50,000 IOPS requires 100 GB).
   - Costs include provisioned volume capacity and IOPS.
   - Tiered IOPS pricing: Tier 1 (up to 32,000 IOPS), Tier 2 (32,001 to 64,000 IOPS), Tier 3 (over 64,000 IOPS).

### Pricing Comparison Scenarios

1. **Scenario 1: 3,000 Sustained IOPS**
   - **gp2**: 1,000 GB volume, $100.00/month.
   - **gp3**: 25 GB volume (includes 3,000 IOPS), $2.00/month.
   - **io1**: 60 GB volume, 3,000 IOPS, $202.50/month.
   - **io2**: 25 GB volume, 3,000 IOPS, $198.13/month.

2. **Scenario 2: 6,000 Sustained IOPS**
   - **gp2**: 2,000 GB volume, $200.00/month.
   - **gp3**: 25 GB volume (includes 3,000 IOPS) + 3,000 extra IOPS, $17.00/month.
   - **io1**: 120 GB volume, 6,000 IOPS, $405.00/month.
   - **io2**: 25 GB volume, 6,000 IOPS, $393.13/month.

3. **Scenario 3: 12,000 Sustained IOPS**
   - **gp2**: 4,000 GB volume, $400.00/month.
   - **gp3**: 25 GB volume (includes 3,000 IOPS) + 9,000 extra IOPS, $47.00/month.
   - **io1**: 240 GB volume, 12,000 IOPS, $810.00/month.
   - **io2**: 25 GB volume, 12,000 IOPS, $783.13/month.

### Conclusion
- **gp3** offers the best overall value for workloads under 16,000 IOPS and 1,000 MB/s, providing significant cost savings compared to gp2 and high IOPS io1/io2 volumes.

### Additional Comparison for io1 vs io2

1. **16,000 IOPS**
   - **io1**: Requires 320 GB, **io2**: Requires 150 GB.
   - **io2** costs $21.25 less in provisioned capacity.

2. **32,000 IOPS**
   - **io1**: Requires 640 GB, **io2**: Requires 150 GB.
   - **io2** costs $61.25 less in provisioned capacity.

3. **64,000 IOPS**
   - **io1**: Requires 1,280 GB, **io2**: Requires 150 GB.
   - **io2** costs $141.25 less in provisioned capacity.
   - io2 has lower cost due to tiered pricing for IOPS above 32,000 IOPS.

**Summary**: io2 volumes offer a lower-cost alternative due to a higher IOPS per GB ratio and a tiered IOPS pricing structure compared to io1.


##  3.6. EBS Snapshot Billing Review

1. **Cost Basis**: EBS Snapshot pricing is based on the actual storage capacity used, not on the provisioned size of EBS volumes.

2. **Snapshot Types**: 
   - **Base Snapshot**: A full copy of the data is created.
   - **Incremental Snapshots**: Only changed blocks since the last snapshot are stored, reducing storage costs.

3. **Data Transfer Costs**: When copying EBS Snapshots across AWS Regions, you are charged for data transfer. Storage in the destination Region incurs standard EBS Snapshot charges.

4. **Snapshot Archive**:
   - **Storage Cost**: Charged based on the amount of data stored in GB and the AWS Region, typically about a quarter of the cost of standard EBS Snapshot storage.
   - **Retrieval Cost**: There is an additional flat rate per GB to retrieve archived snapshots.

5. **Pricing Example (Standard Storage)**:
   - **Scenario**: 70 GB of data initially and an additional 30 GB added halfway through the month.
   - **Calculation**: 
     - Cost for initial data: $0.05/GB-month * 70 GB * 30 days = $105.00.
     - Cost for additional data: $0.05/GB-month * 30 GB * 15 days = $22.50.
     - **Total Monthly Cost**: $4.25.

6. **Pricing Example (Archive Storage)**:
   - **Scenario**: Retaining 100 GB of data monthly, with occasional retrieval.
   - **Monthly Storage Cost**: 
     - $0.0125/GB-month * 100 GB = $1.25.
   - **Retrieval Cost**:
     - $0.03/GB * 25 GB = $0.75.
   - **Total Retrieval Cost**: $0.75.

7. **Storage Calculation Formula**:
   - For regular snapshots: 
     - \[ (Rate per GB-month) * (stored data size) * (time period) \] / \[ (time period units per month) \].
   - For retrieval: 
     - \[ (Rate per GB) * (retrieved data size) \].

8. **Pricing Reference**: All examples are based on AWS Region US East (N. Virginia) as of December 6, 2021. Rates may change without notice.

9. **Billing Cycle**: Costs are calculated based on the storage and retrieval durations specified in the billing period.

10. **Incremental Snapshot Billing**: Only the changed data blocks since the last snapshot are billed, optimizing storage costs.

11. **Data Transfer Fees**: Additional charges apply when copying snapshots between AWS Regions.

12. **Compliance Archiving**: Archive snapshots are often used for compliance and long-term retention purposes, benefiting from lower storage costs but incurring retrieval fees.

13. **Snapshot Management**: Regularly review and manage snapshots to control storage and retrieval costs effectively.

14. **Optimization Tips**: Regularly delete old or unnecessary snapshots to minimize storage costs.

15. **Snapshot Frequency**: Plan snapshot schedules and retention policies to balance cost and data protection needs.

16. **EBS Snapshot Vault**: The storage cost is based on the total data stored in the snapshot vault, not the provisioned EBS volume size.


##  3.7. Using AWS Compute Optimizer for EBS Volumes

1. **EBS Volume Configuration:** Choosing the correct EBS volume type can be complex, but AWS allows you to change volume types and performance characteristics as needed.

2. **AWS Compute Optimizer Overview:** AWS Compute Optimizer helps monitor EBS volumes to ensure optimal performance and cost-effectiveness.

3. **Performance Monitoring:** Compute Optimizer analyzes EBS volume configuration and utilization metrics to determine if they are optimized.

4. **Optimization Recommendations:** It generates recommendations to reduce costs and improve performance based on the analysis of your resources.

5. **Utilization Graphs:** Compute Optimizer provides graphs showing recent and projected utilization metrics to assist in evaluating price/performance trade-offs.

6. **Visualization and Analysis:** The service helps visualize usage patterns, aiding decisions on when to move or resize resources while meeting performance and capacity requirements.

7. **Supported Resources:** Compute Optimizer generates recommendations for EC2 instances, Auto Scaling groups, EBS volumes, and AWS Lambda functions.

8. **Data Requirements:** Recommendations are generated only if resources meet specific requirements and have accumulated sufficient metric data.

9. **Opt-In Requirement:** You must opt-in for Compute Optimizer to analyze your AWS resources.

10. **Account Types Supported:** The service supports standalone AWS accounts, member accounts of an organization, and the management account of an organization.

11. **Data Source:** Compute Optimizer uses data from Amazon CloudWatch for its analysis.

12. **Dashboard Insights:** The Compute Optimizer dashboard displays optimization findings for your resources, providing actionable insights.

13. **Cost and Performance Trade-Offs:** Recommendations help balance cost and performance, ensuring your resources are used efficiently.

14. **Resource Management:** The service assists in managing resources by suggesting changes to improve their cost-effectiveness and performance.


##  3.8. AWS Compute Optimizer Demonstration

- **Accessing AWS Compute Optimizer**: Sign in to the AWS Management Console with admin-level permissions and navigate to AWS Compute Optimizer under the Management and Governance section.

- **Available Options**: The Compute Optimizer dashboard includes options for EC2 instances, Auto Scaling groups, Lambda functions, and EBS volumes.

- **EBS Volumes Feature**: The EBS volumes option is newly launched and will expand with more features over time.

- **Viewing Recommendations**: Select the "View recommendations for EBS volumes" link to open the Recommendations dashboard.

- **Volume Analysis**: Recommendations are based on at least 30 hours of CloudWatch metric data. New volumes are not analyzed until they have enough metric history.

- **Metrics for Recommendations**: Recommendations are based on IOPS (input/output operations per second), not on utilization or throughput.

- **Dashboard Customization**: Use the GEAR icon to modify the columns visible in the dashboard. You can toggle columns to add or remove them from view.

- **Attached vs. Unattached Volumes**: Only attached volumes are visible in the dashboard. Unattached volumes must be monitored with AWS Trusted Advisor.

- **Finding Optimized Volumes**: Use the "Findings" dropdown to sort volumes by All findings, Not optimized, or Optimized.

- **Cost Optimization Example**: A gp3 volume with 6,000 IOPS was found to be underutilized compared to its cost. Reducing IOPS saved $15/month.

- **Comparing Volume Types**: gp3 volumes offer more IOPS and cost savings compared to io1 volumes. gp3 volumes provide up to 16,000 IOPS with significant cost benefits.

- **Optimized Volumes Comparison**: Comparing optimized gp2 and gp3 volumes showed that gp3 provides more capacity and IOPS for the same price.

- **Reviewing Recommendations**: Use the "Optimized" link to view charts and metrics that compare current configurations with recommendations.

- **Graph Metrics**: View metrics like Average or Maximum resource utilization. Adjust the time range for the charts from 1 day to 2 weeks.

- **First Release Capabilities**: The initial release of Compute Optimizer for EBS helps identify optimal IOPS settings and volume sizes based on performance needs.

- **Further Information**: Additional details on Compute Optimizer, Trusted Advisor, and CloudWatch are available through the provided links.


