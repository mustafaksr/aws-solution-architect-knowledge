# AWS Solution Architect Knowledge Readiness Path Learning

## Overview
This repository is designed to support the AWS Solutions Architect - Knowledge Badge Readiness Path. It combines summaries and insights from a structured 15-day AWS learning journey with practical implementations. The learning plan is tailored for Solutions Architects and Solution-Design Engineers, focusing on designing and managing resilient, secure, and highly available cloud-based solutions using AWS.

The repository includes practical implementations of the learning path, focusing on Terraform-based infrastructure setups and Streamlit app deployments. These implementations illustrate the application of AWS concepts in real-world scenarios

### Learning Plan
About the Learning Path:
The AWS Knowledge Badge Readiness Path helps individuals build comprehensive knowledge in designing applications and large distributed systems on AWS. It includes domain-specific content, such as courses, knowledge checks, and a knowledge badge assessment. The path is structured to guide learners through various AWS services and best practices, but it also allows for flexibility in choosing content that best fits individual learning needs.

[View the AWS Solution Architect Knowledge Badge Readiness Path on Notion](https://helix-minnow-e03.notion.site/9e06c208efcc4f59aaf5549210ae52c7?v=0633597eaccf46fea83dbdc762aa9b9d)


## Day 1 - AWS Technical Essentials

### Notes
- [AWS Technical Essentials](Day1-aws-technical-essentials/README)

### Implementation
- [Terraform Streamlit App Deployment](Day1-aws-technical-essentials/implementation/)
  - Deployed a Streamlit application on an EC2 instance with an RDS database connection.
---

## Day 2 - AWS Compute Services Overview

### Notes
- [AWS Compute Services Overview](Day2-aws-iam-compute-storage/README)

### Implementation
- [Terraform Streamlit App Deployment](Day2-aws-iam-compute-storage/implementation/)
  - Configured an S3 bucket to store Terraform remote state for the previously deployed app.
  - Added Elastic Block Store (EBS) for persistent storage to the EC2 instance.
---

## Day 3 - AWS S3, EBS, and Databases

### Notes
- [AWS S3, EBS, and Databases](Day3-EBS-Databases/README)

### Implementation
- [RDS Deployment](Day3-EBS-Databases/implementation-RDS/)
  - Integrated an RDS instance with the existing EC2 Streamlit app.

- [DynamoDB Deployment](Day3-EBS-Databases/implementation-DynamoDB/)
  - Deployed a simple inventory Streamlit app on EC2 using DynamoDB for storage, featuring three text fields.

- [DocumentDB Deployment](Day3-EBS-Databases/implementation-DynamoDB/)
  - Developed a Streamlit app hosted on EC2, connected to DocumentDB and S3. The app supports two text fields and one image field.
---

## Day 4 - Dynamodb-ElastiCache

### Notes
- [Dynamodb-ElastiCache](Day4-Dynamodb-ElastiCache/README)

### Implementation
- [MongoDB Deployment with EC2](Day4-Dynamodb-ElastiCache/implementation-2xEC2-MongoDB-Streamlit/)
  - Set up two EC2 instances: one for MongoDB server and another for the Streamlit application.

- [ElastiCache Deployment](Day4-Dynamodb-ElastiCache/implementation-Elasticache/)
  - Implemented an application using ElastiCache to enhance performance and scalability.



Certainly! Here’s how you can update your main README to include Day 5:

---

## Day 5 - AWS Networking Basics

### Notes
- [AWS Networking Basics](Day5-AWS-Network/README)

### Implementation
- [Network Connectivity Deployment](Day5-AWS-Network/implementation-network/)
  - Deployed a Virtual Private Cloud (VPC) with multiple subnets using Terraform.
  - Configured public and private subnets, route tables, and NAT Gateway.
  - Validated network connectivity between instances and tested internet access via NAT Gateway.

---
