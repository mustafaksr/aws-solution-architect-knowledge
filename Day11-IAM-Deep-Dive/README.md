# 11. Day 11 - Deep Dive with Security: AWS Identity and Access Management (IAM)

## 11.1 The Principle of Least Privilege (PoLP) in AWS


The Principle of Least Privilege (PoLP) is a fundamental security concept in AWS that ensures users or systems are granted only the minimum level of access necessary to perform their tasks. By following this principle, organizations can enhance the security of their resources, minimize risks, and maintain control over sensitive information.

**Key Concepts:**

1. **AWS Shared Responsibility Model:**
      - **AWS Responsibility:** AWS secures the underlying infrastructure, including hardware, software, networking, and facilities.
      - **Customer Responsibility:** Customers secure their data, operating systems, networks, platforms, and other resources they create within AWS.

2. **Applying the Principle of Least Privilege:**
      - **Grant Access as Needed:** 
     - Start by denying all access and then grant permissions based on job roles. 
     - This approach ensures that only the right people have access to the necessary resources.
      - **Enforce Separation of Duties:**
     - Implement clear roles and responsibilities with appropriate authorizations.
     - Separation of duties helps prevent unauthorized access by limiting the scope of authority among different job functions.
      - **Avoid Long-Term Credentials:**
     - Centralize privilege management and reduce reliance on long-term credentials.
     - Use temporary security credentials that expire to minimize the risk of unauthorized access.



```markdown
| **Concept**                  | **Description**                                                                                   |
|------------------------------|---------------------------------------------------------------------------------------------------|
| **AWS Shared Responsibility**| AWS secures the infrastructure, while customers secure their resources and data.                   |
| **Grant Access as Needed**    | Deny all access initially, then grant permissions based on specific job roles.                    |
| **Separation of Duties**      | Define roles and responsibilities clearly to enforce proper authorization across job functions.   |
| **Avoid Long-Term Credentials**| Use temporary credentials to reduce security risks associated with long-term access.               |
```




## 11.2 Overview

This course focused on AWS Identity and Access Management (IAM) and provided in-depth knowledge on managing access to AWS services and resources securely. The course emphasized the importance of implementing the principle of least privilege, managing temporary credentials, and using IAM tools for troubleshooting and access analysis.

Key Learning Objectives

   - **Differentiate** between role-based and attribute-based access controls.
   - **Leverage** global and IAM condition keys according to best practices.
   - **Interact** with AWS Security Token Service (AWS STS) for temporary credentials.
   - **Manage** IAM session policies and duration to limit permissions.
   - **Create** an IAM identity provider.
   - **Demonstrate** the use of AWS SSO in identity federation.
   - **Troubleshoot** IAM access issues using available tools and services.

Course Outline

| **Section** | **Topic**                            | **Description**                                                                                                      |
|-------------|--------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **01**      | IAM Review                           | Covers IAM basics and evaluates understanding through an assessment.                                                 |
| **02**      | Access Control Deep Dive             | Focuses on role-based and attribute-based access controls, IAM global and condition keys, and advanced policy elements. |
| **03**      | Access Delegation Deep Dive          | Discusses providing temporary credentials for entities, enhancing security posture.                                  |
| **04**      | Identity Federation Deep Dive        | Explores assigning temporary credentials to users authenticated outside of AWS or via other AWS services.            |
| **05**      | Access Analysis and Troubleshooting  | Provides tools and examples for analyzing and troubleshooting IAM access issues and over-permissible credentials.    |

Detailed Learnings

 IAM Review
   - **Objective:** Review IAM basics and fundamentals.
   - **Outcome:** Solidify understanding of IAM before delving into advanced topics.

 Access Control Deep Dive
   - **Objective:** Understand role-based vs. attribute-based access controls.
   - **Outcome:** Learn to use IAM global and condition keys to fine-tune access control.

 Access Delegation Deep Dive
   - **Objective:** Efficiently manage access by providing temporary credentials.
   - **Outcome:** Improve security by minimizing reliance on long-term credentials.

 Identity Federation Deep Dive
   - **Objective:** Implement identity federation and manage cross-account access.
   - **Outcome:** Use AWS SSO and identity federation for secure, temporary access management.

 Access Analysis and Troubleshooting
   - **Objective:** Analyze and troubleshoot IAM policies and permissions.
   - **Outcome:** Gain expertise in identifying and resolving over-permissible access issues.



## 11.3  AWS IAM Fundamentals

IAM (Identity and Access Management) is essential for managing access credentials and securing resources in your AWS account. It provides a centralized mechanism for creating and managing individual users and their permissions. This summary covers the main concepts related to IAM, including users, groups, roles, and credentials.

---

**Users and Groups**

- When you open an AWS account, you start with an identity that has full access to all AWS services and resources.
- IAM is used to create less-privileged users and role-based access.
- Users and groups are vital for managing access to resources within a single AWS account.
- For organizations with multiple AWS accounts, identity federation is required for centralized management, as users and groups are not scalable.

| **Concept**       | **Description**                                                                                   |
|-------------------|---------------------------------------------------------------------------------------------------|
| **Users**         | Individual identities that can be assigned specific permissions to interact with AWS resources.   |
| **Groups**        | Collections of users with similar permissions, usually reflecting organizational roles.           |
| **Best Practice** | Create groups based on organizational roles rather than technical commonality.                    |

---

**Roles**

- IAM roles allow you to delegate access to users, applications, or services without sharing long-term credentials.
- Roles provide temporary security credentials to make AWS API calls.
- Roles are essential for managing access across multiple AWS accounts and are often used in scenarios involving:
  - IAM users or roles needing specific access.
  - Applications on EC2 instances accessing AWS resources.
  - AWS services calling other services on your behalf.
  - External users authenticated via identity providers (SAML 2.0, OpenID Connect).

| **Scenario**                                             | **Use Case**                                                                                     |
|----------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| **IAM User or Role**                                     | Same or different AWS account needing access provided by the role.                                |
| **Applications on EC2**                                  | Applications requiring access to AWS resources.                                                  |
| **AWS Service**                                          | Services calling other AWS services or managing resources on your behalf.                         |
| **External User**                                        | Users authenticated by identity providers (SAML 2.0, OpenID Connect) or custom-built brokers.     |

---

**Types of AWS Credentials**

- A user in AWS consists of a name, a password, and up to two access keys for API or CLI use.
   - **Password Policy**: A set of rules defining the type of password an IAM user can set, enforcing strong passwords and periodic changes.
   - **Multi-Factor Authentication (MFA)**: Adds an extra layer of security by requiring more than one authentication factor (username, password, and MFA code).
   - **Access Keys**: Used for programmatic calls to AWS services, each consisting of an access key ID and a secret key. Users can have two active access keys to facilitate key rotation or permission revocation.

| **Credential Type**  | **Purpose**                                                                                       |
|----------------------|---------------------------------------------------------------------------------------------------|
| **Password**         | Required for signing into the AWS Management Console.                                              |
| **Access Keys**      | Required for programmatic access via AWS CLI, SDKs, or direct API calls.                           |
| **MFA**              | Enhances security by requiring additional authentication factors.                                  |
| **Best Practice**    | Regularly rotate access keys and enforce strong password policies.                                 |

---

**Key Takeaways**

- Create IAM groups that reflect organizational roles rather than technical commonality.
- IAM roles enable defining permissions and granting temporary access, improving security posture.
- IAM allows employees and applications to access AWS resources using existing identity systems.
- IAM is integrated into most AWS services, providing centralized access control management.

For more information, refer to the [AWS IAM User Guide on access policies for job functions](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions.html).

## 11.4 IAM Policy Basics


**IAM Request Context**

IAM policies are governed by three main components: **Principal**, **Action**, and **Resource**. These elements correspond to the subject, verb, and object in a sentence, and together, they define what is in the policy and how it operates.

| **Component** | **Description** |
|---------------|-----------------|
| **Principal** | The entity (user, role, external user, or application) that sends the request, along with the policies associated with it. |
| **Action**    | What the principal is attempting to do (e.g., S3:ListBucket). |
| **Resource**  | The AWS resource object upon which the actions are performed (e.g., an S3 bucket). |

**Identity-Based Policies**

These policies manage access by being attached to IAM identities or AWS resources. They are stored as JSON documents in AWS and are evaluated whenever a principal entity (like a user or role) makes a request. Based on these policies, the request is either allowed or denied. There are three types of identity-based policies:

| **Policy Type**      | **Description** |
|----------------------|-----------------|
| **AWS Managed**      | Created and managed by AWS. These policies can be attached to multiple users, groups, and roles. Recommended for beginners. |
| **Customer Managed** | Created and managed by the user in their AWS account. They offer more precise control and can also be attached to multiple users, groups, and roles. |
| **Inline**           | Embedded directly into a single user, group, or role. Best for maintaining a strict one-to-one relationship between a policy and a principal. Not generally recommended unless necessary. |

**IAM Policy Example**

A typical IAM policy grants specific permissions to AWS resources. Here’s an example of an identity-based policy for an Amazon S3 bucket:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::example_bucket"
    }
  ]
}
```

**Conditions in IAM Policies**

IAM policies can include a **Condition** element to specify when a policy is in effect. This is optional and allows for finer control over access. Conditions are written using operators (e.g., `StringEquals`, `IpAddress`) and keys (e.g., `aws:username`, `aws:SourceIp`).

Here are two examples:

1. **Username Condition Example**:
   ```json
   "Condition": {
     "StringEquals": {
       "aws:username": "JohnDoe"
     }
   }
   ```

2. **IP Address Condition Example**:
   ```json
   "Condition": {
     "IpAddress": {
       "aws:SourceIp": "203.0.113.0/24"
     }
   }
   ```

Multiple conditions can be used within a single policy and are evaluated using logical AND. Various condition keys are available depending on your specific use case. For more details on condition operators, refer to the [AWS documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html).

## 11.5 Policy Evaluation in AWS



AWS manages access through policies attached to IAM identities (users, groups, or roles) or AWS resources. These policies define permissions and are evaluated when an IAM principal (user or role) makes a request, whether via the AWS Management Console, CLI, or API.

 Types of Policies

| **Policy Type**              | **Description**                                                                                                                                               | **Purpose**                                                              |
|------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| **Identity-based Policies**  | Managed and inline policies attached to IAM identities (users, groups, or roles).                                                                              | Grant access to AWS resources.                                           |
| **Resource-based Policies**  | Inline policies attached to AWS resources like S3 buckets. They grant permissions to specified principals.                                                     | Grant access to specific AWS resources.                                  |
| **Permissions Boundaries**   | Set maximum permissions that an identity-based policy can grant to an IAM entity.                                                                              | Restrict permissions for IAM entities.                                   |
| **AWS Organizations SCPs**   | Service control policies applied to AWS accounts, specifying the maximum permissions for an account or organizational unit (OU).                               | Restrict permissions for entities within AWS accounts.                   |
| **Access Control Lists (ACLs)** | Control access to resources across accounts. They grant permissions to specified principals but do not support JSON policy structure.                         | Grant cross-account permissions to AWS resources.                        |
| **Session Policies**         | Inline policies passed during a session when a role is assumed, limiting permissions granted by identity-based policies.                                        | Restrict permissions for assumed roles and federated users.              |

 Guardrails vs. Grants

   - **Guardrails**: Policies like SCPs, permissions boundaries, and session policies are used to restrict permissions.
   - **Grants**: Identity-based policies, resource-based policies, and ACLs are used to grant access.

Using a combination of these policy types enhances security and limits potential damage in case of a security incident.

 Explicit and Implicit Denies

   - **Explicit Deny**: A request is explicitly denied if an applicable policy includes a `Deny` statement. This override any `Allow` statements.
   - **Implicit Deny**: Occurs when no applicable `Allow` statement is present. By default, IAM users, roles, and federated users are denied access unless explicitly allowed.

 Decision-Making Process

AWS evaluates the following when authenticating a principal's request:
1. **Within an Account**: Requires a service control policy (SCP) **AND** an IAM policy **OR** a resource-based policy.
2. **Across Accounts**: Requires a service control policy (SCP) **AND** an IAM policy **AND** a resource-based policy.

 Key Takeaways

   - **Implicit Deny by Default**: All requests are implicitly denied unless explicitly allowed.
   - **Explicit Allow Overrides**: An explicit allow in an identity-based or resource-based policy overrides the implicit deny.
   - **Impact of Guardrails**: Permissions boundaries, SCPs, or session policies can override an explicit allow with an implicit deny.
   - **Explicit Deny Supremacy**: An explicit deny in any policy always overrides any allows.
   - **Resource-Based Policies**: If a resource-based policy allows an action, the final decision is allow. If not, evaluation continues.
   - **Session Policies**: If a session policy does not allow the requested action, the request is implicitly denied.



## 11.6 The Matching Game

AWS policy evaluation ensures secure access to resources through authentication and authorization.

**The Matching Game**
- AWS, like a secured marina, limits access points called API endpoints, which support HTTPS and TLS encryption. Each API request is authenticated and authorized via IAM and recorded by AWS CloudTrail.

**Who is Requesting Access?**
   - **Principal**: The entity making a request, such as a person, role, or application, authenticated as an AWS root user or IAM entity.
   - **Context**: Includes the principal (e.g., `arn:aws:iam::<AWS-account-ID>:user/<username>`), principal tags (e.g., `dept=123`), and condition keys (e.g., `aws:UserID`).

**Types of Principals:**

| Principal Type      | Description                                                                                                       | Example                                                                                                                                           |
|---------------------|-------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| **AWS Accounts**    | Delegates authority to an entire AWS account, allowing permissions to IAM users and roles.                        | `arn:aws:iam::123456789012:root`                                                                                                                  |
| **IAM Users**       | Specifies individual users; logical OR is applied if multiple principals are specified.                            | `arn:aws:iam::<AWS-account-ID>:user/<username>`                                                                                                   |
| **Federated Users** | Manages identities outside AWS via Identity Providers (IdP) like SAML or web identity providers.                  | `cognito-identity.amazonaws.com` (for web identity)                                                                                               |
| **IAM Roles**       | Used to delegate access to AWS resources, allowing entities to assume roles and gain new permissions.             | `arn:aws:iam::<AWS-account-ID>:role/<role-name>`                                                                                                  |
| **AWS Services**    | Service roles allow AWS services to assume roles, usually defined in a trust policy.                              | `emr.amazonaws.com` (for Amazon EMR)                                                                                                              |

**How and What Do They Want to Access?**
   - **Authorization**: AWS checks the policies related to the request’s context during authorization. This includes actions (e.g., `iam:GetUser`), resources (e.g., `arn:aws:iam::<AWS-account-ID>:user/<username>`), and resource tags (e.g., `dept=456`).

**Analyzing the Authorization Context**
- The request context, built from request details, is used to match and evaluate against applicable IAM policies to determine whether access is granted or denied. 

This summary highlights the core process of policy evaluation in AWS, including authentication, principal types, and the authorization context used to control access to resources.

## 11.7 Attributes and Tagging

Attribute-based access control (ABAC) is an AWS authorization strategy that defines permissions based on attributes, also known as tags. These tags can be attached to both IAM principals (users or roles) and AWS resources. ABAC offers a scalable and manageable solution for environments that grow rapidly, allowing you to create policies that automatically apply permissions as new resources are added.

**Comparison Between ABAC and RBAC:**

| **Authorization Model** | **Description**                                                                                                           | **Use Case**                                                                                                                  |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| Role-Based Access Control (RBAC) | Permissions are defined based on a person's job function. Policies are created for each job function and attached to IAM users, groups, or applications via roles. | Suitable for smaller, more static environments where roles align closely with job functions. |
| Attribute-Based Access Control (ABAC) | Permissions are defined based on attributes (tags). Operations are allowed only when the principal's tag matches the resource tag. | Ideal for rapidly growing environments, offering scalable and flexible permissions management. |

**Key Features of ABAC:**

   - **Scalable:** As teams and resources grow, permissions are automatically applied based on attributes, eliminating the need for constant policy updates.
  
   - **Manageable:** Fewer policies need to be created and maintained, as a single policy can cover multiple scenarios through the use of tags.

   - **Granular Permissions:** ABAC allows for the granting of least privilege by permitting actions only when the resource tag matches the principal's tag, reducing the risk of over-permissioning.

**Example Use Case:**

Imagine a scenario where both Bob and Alice share the same job function but belong to different cost centers. In a traditional RBAC model, you would need two separate roles to grant access to resources specific to each cost center. However, with ABAC, a single role can be used. The policy would grant access to resources only if the resource’s cost center tag matches the user's cost center tag, thereby simplifying the management of roles and reducing the number of roles required. 

By combining both RBAC and ABAC, AWS allows for flexible and scalable permissions management, making it easier to handle complex and dynamic environments.


## 11.8 IAM Condition Keys

IAM Condition Keys allow you to specify the circumstances under which a policy is in effect by comparing keys in the request context with values in the policy. Below are key details regarding IAM Condition Keys:

| **Condition Key**           | **Description**                                                                                                        | **Operator Type** |
|-----------------------------|------------------------------------------------------------------------------------------------------------------------|-------------------|
| **iam:AWSService**           | Controls access to a specific service role, allowing the creation of roles for a particular service.                    | String            |
| **iam:OrganizationsPolicyId**| Grants IAM entity access to specific Service Control Policies (SCPs) within AWS Organizations.                          | String            |
| **iam:PermissionsBoundary**  | Checks that a specified policy is attached as a permissions boundary to an IAM principal resource.                      | String            |
| **iam:PolicyARN**            | Verifies the ARN of a managed policy in requests that involve that policy, controlling how users apply managed policies.| ARN               |
| **iam:ResourceTag**          | Ensures that a tag attached to an identity resource matches a specified key name and value.                             | String            |
| **iam:PassedToService**      | Specifies the service principal to which a role can be passed, restricting role passing to specified services.          | String            |
| **iam:AssociatedResourceArn**| Specifies the ARN of the resource associated with a role at the destination service.                                     | ARN               |

Summary of IAM Condition Keys:

   - **iam:AWSService:** Controls service role creation.
   - **iam:OrganizationsPolicyId:** Manages access to SCPs within AWS Organizations.
   - **iam:PermissionsBoundary:** Ensures a specific policy is attached as a boundary.
   - **iam:PolicyARN:** Controls the application of managed policies via ARN.
   - **iam:ResourceTag:** Matches tags on identity resources.
   - **iam:PassedToService:** Restricts role passing to specific services.
   - **iam:AssociatedResourceArn:** Restricts roles to specified resources based on ARN.

These keys provide granular control over when policies apply, enhancing security and ensuring proper access management within AWS environments.

## 11.9 Global Condition Keys

Global condition keys in AWS IAM start with the `aws:` prefix and can be used to enforce conditions on requests made to AWS services. These keys are particularly useful in defining and controlling how and by whom AWS resources are accessed. 

**Global Condition Keys Overview**
- Global condition keys are used to apply conditions to AWS service requests.
- Not all AWS services support all global condition keys.
- Common global condition keys include `aws:CalledVia`, `aws:CalledViaFirst`, and `aws:CalledViaLast`.

**Key Concepts**

   - **aws:CalledVia**
  - Tracks the sequence of services making requests on behalf of the IAM principal.
  - For example, if User 1 makes a request via AWS CloudFormation, which then makes requests to DynamoDB and AWS KMS, the `aws:CalledVia` key will list the services in the order of the chain: `cloudformation.amazonaws.com`, `dynamodb.amazonaws.com`, and `kms.amazonaws.com`.
  
   - **aws:CalledViaFirst**
  - Enforces the service that must be the first in the chain of requests.
  - Example: To allow managing a KMS key only if the first request was made via AWS CloudFormation.

   - **aws:CalledViaLast**
  - Enforces the service that must be the last in the chain of requests.
  - Example: To allow managing a KMS key only if the last request was made via DynamoDB.

**Example Policies**

1. **Policy Allowing Requests if Made via DynamoDB**
   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Sid": "KmsActionsIfCalledViaDynamodb",
               "Effect": "Allow",
               "Action": [
                   "kms:Encrypt",
                   "kms:Decrypt",
                   "kms:ReEncrypt*",
                   "kms:GenerateDataKey",
                   "kms:DescribeKey"
               ],
               "Resource": "arn:aws:kms:region:111122223333:key/my-example-key",
               "Condition": {
                   "ForAnyValue:StringEquals": {
                       "aws:CalledVia": ["dynamodb.amazonaws.com"]
                   }
               }
           }
       ]
   }
   ```

2. **Policy Allowing Requests with Specific Chain of Services**
   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Sid": "KmsActionsIfCalledViaChain",
               "Effect": "Allow",
               "Action": [
                   "kms:Encrypt",
                   "kms:Decrypt",
                   "kms:ReEncrypt*",
                   "kms:GenerateDataKey",
                   "kms:DescribeKey"
               ],
               "Resource": "arn:aws:kms:region:111122223333:key/my-example-key",
               "Condition": {
                   "StringEquals": {
                       "aws:CalledViaFirst": "cloudformation.amazonaws.com",
                       "aws:CalledViaLast": "dynamodb.amazonaws.com"
                   }
               }
           }
       ]
   }
   ```

**Global Condition Keys Summary**

| Key                   | Description                                                | Example Use Case                                         |
|-----------------------|------------------------------------------------------------|----------------------------------------------------------|
| `aws:CalledVia`       | Lists services in the request chain.                       | Restrict access if requests were made via a specific service. |
| `aws:CalledViaFirst`  | Specifies the first service in the request chain.          | Enforce that requests must start from a particular service. |
| `aws:CalledViaLast`   | Specifies the last service in the request chain.           | Enforce that requests must end with a particular service. |

**Additional Information**
- IAM supports other global condition keys beyond the ones covered here.
- For more details, refer to the AWS documentation on global condition keys.


## 11.10 Advanced Policy Elements


AWS provides advanced policy elements that allow you to create more concise and specific policies by specifying exceptions rather than listing all applicable conditions. Key elements include NotPrincipal, NotAction, and NotResource.

**NotPrincipal**

   - **Purpose**: Specifies exceptions to a list of principals, allowing or denying access to all except the specified ones.
   - **Usage with "Allow"**: Avoid using `NotPrincipal` with "Effect": "Allow" as it grants access to all except the specified principal, which might include unauthenticated users.
   - **Usage with "Deny"**: When used with "Effect": "Deny", it denies the specified actions to all except the listed principals. Ensure to specify the account ARN to avoid inadvertently denying access to the entire account.

**NotAction**

   - **Purpose**: Excludes specific actions from the policy, resulting in shorter policies by listing only the actions that should not be allowed.
   - **Usage with "Allow"**: Avoid using `NotAction` with "Effect": "Allow" as it allows all actions except those specified, which might be broader than intended.
   - **Usage with "Deny"**: When used with "Effect": "Deny", it denies all actions except those listed. Ensure actions you want to allow are explicitly mentioned elsewhere in the policy.

**NotResource**

   - **Purpose**: Excludes specific resources from the policy, useful for policies that apply within a single AWS service.
   - **Usage with "Allow"**: Be cautious as it grants access to all resources not explicitly listed, potentially giving more permissions than intended.
   - **Usage with "Deny"**: Denies access to all resources not listed. Ensure the resources to be limited are explicitly specified.



| **Element**  | **Purpose**                                          | **Usage with "Allow"**                                     | **Usage with "Deny"**                                       |
|--------------|------------------------------------------------------|-------------------------------------------------------------|-------------------------------------------------------------|
| NotPrincipal | Specifies exceptions to a list of principals.       | Avoid; can grant access to unauthenticated users.          | Denies access to all except listed principals.              |
| NotAction    | Excludes specific actions from the policy.           | Avoid; allows all actions except those specified.          | Denies all actions except those listed.                     |
| NotResource  | Excludes specific resources from the policy.         | Caution; may grant broader access than intended.           | Denies access to all resources except those listed.         |

## 11.11 Interacting with AWS STS

Interacting with AWS STS involves several key concepts and procedures for managing temporary security credentials. 

**AWS Security Token Service (STS) Overview**

AWS STS allows you to grant temporary access to AWS resources by generating security credentials that are valid for a limited period. These credentials are useful for scenarios where you need to provide access without managing long-term credentials. 

**Temporary Security Credentials**

   - **Duration**: Credentials can last from a few minutes to several hours. After expiration, they are no longer valid and must be reissued if needed.
   - **Dynamic Generation**: Credentials are generated dynamically and are not stored long-term. They can be requested anew before expiration if permissions allow.

**Use Cases**

| Use Case                 | Description |
|--------------------------|-------------|
| **Identity Federation**  | Allows external systems to authenticate users and grant them access to AWS resources. Types include corporate and web identity federation. |
| **Cross-Account Access** | Allows users in one AWS account to access resources in another account using roles and permissions defined in trust policies. |
| **Roles for EC2**        | Provides temporary credentials to EC2 instances, allowing applications on the instance to access AWS resources without long-term credentials. |

**Assuming a Role**

   - **AssumeRole API**: Used to request temporary security credentials for accessing AWS resources. Credentials include an access key ID, a secret access key, and a security token.
   - **Endpoint**: All STS API requests are directed to `https://sts.amazonaws.com`.

**AssumeRole Request Parameters**

| Parameter        | Description |
|------------------|-------------|
| **DurationSeconds** | Sets the validity period of the temporary credentials (15 minutes to 12 hours). |
| **Policy**       | Inline session policy that defines permissions. |
| **PolicyArns.member.N** | ARNs of IAM managed policies for additional permissions. |
| **Tags.member.N** | Session tags with key-value pairs. |
| **SerialNumber and TokenCode** | MFA details for authentication in cross-account scenarios. |

**Assuming a Role Example**

1. An analyst in Account A needs access to resources in Account B.
2. The analyst uses the AssumeRole API to request credentials from Account B.
3. AWS STS verifies the trust policy and permissions, then returns temporary credentials.

**Security Token Components**

   - **Access Key ID**: Identifies the temporary credentials.
   - **Secret Access Key**: Signs API calls.
   - **Session Token**: Required for API calls to use the credentials.

AWS STS helps manage temporary security credentials efficiently, providing flexibility and security for accessing AWS resources across different scenarios.

## 11.12 Resource-based polilcies

Managing Role Sessions in AWS involves understanding how to control and limit permissions for users assuming roles, and how to track these sessions.

   - **Session Policies**:
     - **Purpose**: Restrict permissions for specific sessions beyond the default role permissions.
     - **How It Works**: When assuming a role, a session policy can be included to limit what the user can do. This policy is inline and can be specified by the user or set up via an identity broker.
     - **Benefits**:
       - **Reduces Role Creation**: Multiple users can use the same role but with different permissions for their sessions.
       - **Fine-Grained Control**: Limits permissions for specific actions, ensuring users only get what they need for their session.

   - **Identity-Based Policies**:
     - **Interaction**: Permissions are the intersection of the IAM entity's identity-based policy and the session policy.
     - **Flexibility**: AWS managed or customer managed policies can be used as session policies.

   - **Resource-Based Policies**:
     - **Interaction**: When using resource-based policies, permissions from these policies are combined with identity-based policies, and session policies further restrict these permissions.
     - **Result**: Permissions are the intersection of session policies with resource-based or identity-based policies.

   - **Naming Role Sessions**:
     - **Role Session Name**: Uniquely identifies each IAM role session.
     - **Usage**: Helps track user actions in AWS CloudTrail logs.
     - **Naming Examples**:
       - **AWS Service**: AWS sets the session name. Example: EC2 instance (Instance ID), Lambda function (Function name).
       - **SAML-Based**: AWS sets the session name based on the attribute from the identity provider.
       - **User-Defined**: Users specify the session name when making an AssumeRole API call.

   - **Policy Example**:
  ```json
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "RoleTrustPolicyRequireUsernameForSessionName",
              "Effect": "Allow",
              "Action": "sts:AssumeRole",
              "Principal": {"AWS": "arn:aws:iam::111122223333:root"},
              "Condition": {
                  "StringLike": {"sts:RoleSessionName": "${aws:username}"}
              }
          }
      ]
  }
  ```

   - **Role Session Name Examples**:
  | AWS Service          | Session Name Example        |
  |----------------------|------------------------------|
  | Amazon EC2 instance  | Instance ID (i-0502a47dfc551c555) |
  | AWS Lambda function  | Function name (aws-ct-processing) |
  | Amazon Cognito pool  | Cognito identity credentials  |

     - **SAML-Based**: Session name from the identity provider attribute.
     - **User-Defined**: Specified during AssumeRole API call.

   - **CloudTrail Example**:
  ```json
  {
      "eventVersion": "1.05",
      "userIdentity": {
          "type": "AWSService",
          "invokedBy": "lambda.amazonaws.com"
      },
      "eventTime": "2019-08-26T11:15:26Z",
      "eventSource": "sts.amazonaws.com",
      "eventName": "AssumeRole",
      "awsRegion": "us-east-2",
      "sourceIPAddress": "lambda.amazonaws.com",
      "userAgent": "lambda.amazonaws.com",
      "requestParameters": {
          "roleSessionName": "backend-logic-fn",
          "roleArn": "arn:aws:iam::123456789012:role/backend-logic-fn-role"
      },
      "responseElements": {
          "credentials": {
              "sessionToken": "AgoJb3JpZ……2luX2VjEJz",
              "accessKeyId": "ASIAUF7B273EXAMPLE",
              "expiration": "Aug 26, 2019 11:15:26 PM"
          }
      }
  }
  ```

## 11.13 Session Tagging

Session Tagging

Session tags are attributes passed when you assume an IAM role or federate a user via AWS CLI or API. They are used for access control and monitoring but are only valid for the duration of the session and are not stored permanently. Session tags consist of a customer-defined key and an optional value. To use session tags, the IAM policy must include the `sts:TagSession` action.

**Key Points:**

   - **Session Tags**: Attributes specified when requesting a session, used for access control and monitoring.
   - **Session Tag Rules**:
  - Must follow IAM and AWS STS tag naming rules, including case sensitivity and restricted prefixes.
  - New tags override existing tags with the same key.
  - Cannot be passed via AWS Management Console.
  - Valid only for the current session.
  - Maximum of 50 session tags allowed.
  - Viewable in AWS CloudTrail logs.

   - **Role Chaining**:
     - **Definition**: Using a role to assume another role through AWS CLI or API.
     - **Transitivity**: Tags from an initial role session can be made transitive, passing to subsequent sessions in a role chain.
     - **Example**: Assuming Role 1, then Role 2, and finally Role 3, with each role tagged in IAM. Session tags from Role 1 can persist through Roles 2 and 3 if set as transitive.

**Summary Table**

| Feature           | Description |
|-------------------|-------------|
| **Session Tags**  | Attributes for role assumption and federated users, valid only for the current session. |
| **Rules for Tags** | Follow IAM and AWS STS naming conventions; new tags override old ones; not passed via Management Console. |
| **Maximum Tags**  | 50 |
| **Viewing Tags**  | Accessible in AWS CloudTrail logs |
| **Role Chaining** | Tags can be passed between roles if set as transitive, useful for maintaining consistent tags across sessions. |

Session tagging supports managing complex scenarios, such as role chaining and dynamic access control, helping enforce security policies and manage permissions effectively.

## 11.14 Federating Users in AWS


**Federating Users in AWS**

Identity federation in AWS allows users to access AWS resources using an identity provider (IdP) that manages authentication. The process involves creating a trust relationship between the IdP and AWS, where the IdP authenticates users, and AWS controls resource access. AWS supports common identity standards like SAML 2.0, OpenID Connect (OIDC), and OAuth 2.0.

**AWS Federation Solutions**

1. **Single Sign-On (SSO) to AWS Accounts**
      - **Service:** AWS IAM Identity Center (formerly AWS SSO)
      - **Use Case:** Provides a single sign-on experience for users accessing AWS accounts and centrally manages access to resources.

2. **Fine-Grained Access to AWS Resources**
      - **Service:** AWS IAM
      - **Use Case:** Manages fine-grained permissions for access to AWS services and resources.

3. **Access to Web and Mobile Applications**
      - **Service:** AWS Cognito
      - **Use Case:** Manages user sign-up, sign-in, and access for web and mobile applications.

**Summary Table**

| **Use Case**                       | **AWS Service**        | **Description**                                                                                   |
|------------------------------------|------------------------|---------------------------------------------------------------------------------------------------|
| Single Sign-On to AWS Accounts     | AWS IAM Identity Center | Provides SSO for accessing AWS accounts and centralizes resource access management.              |
| Fine-Grained Access to AWS Resources| AWS IAM                | Manages detailed permissions and access controls for AWS resources.                               |
| Access to Web and Mobile Applications | AWS Cognito           | Handles user authentication and access for web and mobile applications.                          |

## 11.15 SAML-Based Federation

SAML-Based Federation enables federated access to AWS accounts using IAM and AWS STS by integrating a SAML 2.0-based Identity Provider (IdP).

   - **Federated Access**: Allows users to access AWS resources without needing individual IAM identities. Users authenticate via a corporate IdP, which then federates them to AWS.

   - **Process Overview**:
  1. **User Authentication**: Users log into their corporate IdP portal.
  2. **SAML Assertion**: The IdP returns a SAML assertion containing user attributes and identity information.
  3. **AssumeRoleWithSAML**: The assertion is used to request temporary security credentials from AWS STS.
  4. **Access AWS Console**: The user receives temporary credentials and gains access to the AWS Management Console.

   - **Configuration**:
     - **SAML IdP Setup**: Configure your SAML IdP to issue claims required by AWS.
     - **IAM Configuration**:
    - Create a SAML provider in AWS.
    - Define an IAM role with a trust policy referencing the SAML provider.

   - **AssumeRoleWithSAML Request Parameters**:
     - **DurationSeconds**: Specifies the duration of the role session, from 15 minutes to 12 hours (default 1 hour).
     - **Policy**: Inline session policy for permissions.
     - **PolicyArns.member.N**: Managed session policies (up to 10 ARNs).

   - **AssumeRoleWithSAML Response**:
  - Provides temporary security credentials tied to the role-based access without user-specific credentials.

   - **ABAC Integration**:
     - **Attributes-Based Access Control (ABAC)**: Uses user attributes passed as session tags to define access permissions.
     - **Example**: Users can be granted access to resources based on attributes like "CostCenter". Only resources tagged with the user's cost center are accessible.

Key Resources
| Resource                                          | Description                                          |
|---------------------------------------------------|------------------------------------------------------|
| [About SAML 2.0-based federation in the IAM User Guide](#)   | Information on SAML 2.0 federation setup.           |
| [Creating SAML identity providers in the IAM User Guide](#)   | Guide to configuring SAML IdPs.                     |
| [Configuring a relying party and claims in the IAM User Guide](#) | Steps to configure relying parties and claims.      |
| [Creating a role for SAML 2.0 federation in the IAM User Guide](#) | Instructions for creating IAM roles for SAML federation. |

This process streamlines user access management by leveraging existing corporate identities and allows for scalable, dynamic access control through AWS.

## 11.16 Web-Based Federation

**Web-Based Federation**

AWS supports identity federation for customer-facing web and mobile applications through web identity providers such as Amazon Cognito, Login with Amazon, Facebook, Google, or any OpenID Connect-compatible identity provider.

**Key Concepts:**

   - **Identity Federation**: Allows web and mobile applications to authenticate users via web identity providers without embedding long-term AWS credentials.
   - **Amazon Cognito**: Acts as an identity broker, managing the federation process and simplifying authentication for mobile and web applications.

**Authentication Workflow:**

1. **User Authentication**: Users sign in using a web identity provider (e.g., Amazon Cognito, Google).
2. **Token Exchange**: The application exchanges the web identity token for an Amazon Cognito token via API operations.
3. **Temporary Security Credentials**: Amazon Cognito requests temporary credentials from AWS STS using the AssumeRoleWithWebIdentity API.
4. **Access Control**: The temporary credentials allow access based on the role’s permissions and policies.

**AssumeRoleWithWebIdentity Request:**

   - **Identity Token**: Required from a supported identity provider.
   - **Role Creation**: A role must be created and configured to trust the identity provider.
   - **No Long-Term Credentials**: Applications do not need to embed long-term AWS credentials.

**Optional Parameters:**

| Parameter         | Description                                                                                   |
|-------------------|-----------------------------------------------------------------------------------------------|
| DurationSeconds   | Specifies the role session duration (900 seconds to 12 hours). Default is 1 hour.           |
| Policy            | IAM policy used as an inline session policy; permissions are the intersection of role and session policies. |
| PolicyArns.member.N | ARNs of IAM managed policies for the session. Up to 10 ARNs can be provided. |

**AssumeRoleWithWebIdentity Response:**

   - **Temporary Credentials**: Includes an access key ID, secret access key, and security token for signing AWS service API calls.

**Amazon Cognito for Mobile Applications:**

   - **Features**: Adds user sign-up, sign-in, and access controls; supports social and enterprise identity providers.
   - **Scalability**: Handles millions of users.
   - **Authentication Workflow**:
  1. User logs in via web IdP.
  2. Device sends GetId API call to Amazon Cognito.
  3. Token validation: Ensures the token is valid, not expired, and matches the application and user identifiers.
  4. Calls GetCredentialsForIdentity API to get temporary security credentials.

For more details, refer to resources on web identity federation API operations and the Web Identity Federation Playground.


## 11.17 AWS IAM Identity Center for User Federation

AWS IAM Identity Center (formerly AWS Single Sign-On) simplifies federated access management across AWS accounts and business applications.

AWS IAM Identity Center Benefits:
   - **Built-in Integrations:** Seamlessly integrates with cloud applications like Salesforce, Box, GitHub, and Office 365.
   - **Directory Management:** Provides a built-in directory for user and group management, serving as an IdP for IAM Identity Center applications, AWS Management Console, and SAML 2.0 compatible apps.
   - **AWS Services Integration:** Works with AWS Organizations for centralized management.
   - **Logging and Auditing:** Records all sign-in and administrative activities in CloudTrail, with the ability to forward logs to SIEM solutions like Splunk and Sumo Logic.
   - **AWS Access Portal:** Allows users to sign in with corporate credentials and access assigned accounts and applications from a single location.
   - **CLI Access:** Supports AWS CLI v2 for accessing AWS resources with short-term credentials, enhancing security.

Renaming Details:
   - **AWS SSO User:** Now referred to as "workforce user" or "user".
   - **AWS SSO User Portal:** Renamed to "AWS access portal".
   - **AWS SSO-Integrated Applications:** Known as "Identity Center enabled applications".
   - **AWS SSO Directory:** Called "Identity Center directory".
   - **AWS SSO Store:** Now "identity store used by IAM Identity Center".

IAM Identity Center Configuration:
   - **Permission Sets:** Define a user’s permissions to access AWS accounts, consisting of AWS-managed or custom policies. These sets are provisioned as IAM roles in AWS accounts. Users can have multiple permission sets and must select a role when signing into the AWS access portal.

Integrations:
   - **Supported IdPs:** IAM Identity Center supports SAML 2.0 IdPs and corporate Active Directories for user federation.

Reference Links:
- [Getting Started with AWS IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/getting-started.html)
- [Service-Linked Roles Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_terms-and-concepts.html#iam-term-service-linked-role)

YouTube Demos:
- [Basic AWS SSO Configuration](https://www.youtube.com/watch?v=example)
- [Signing into AWS CLIv2](https://www.youtube.com/watch?v=example)

## 11.18 AWS IAM Identity Center for User Federation



IAM Policy Simulator is a tool to test and troubleshoot identity-based policies, IAM permissions boundaries, AWS Organizations service control policies (SCPs), and resource-based policies. It does not make actual AWS service requests, allowing safe testing of policies that could affect the live environment. It provides results on whether actions are allowed or denied.

**Common Use Cases:**

   - **Test Policies Attached to IAM Entities:** Evaluate the effect of policies attached to IAM users, groups, or roles. You can test all attached policies or select individual ones to see allowed or denied actions for specific resources.
  
   - **Test Permissions Boundaries:** Assess the impact of permissions boundaries on IAM entities.

   - **Test Resource-Based Policies:** Evaluate policies attached to AWS resources like S3 buckets, SQS queues, SNS topics, or Glacier vaults.

   - **Test SCPs Impact:** Analyze the effect of service control policies if the account is part of an AWS Organization.

   - **Test New Policies:** Simulate the impact of new policies not yet attached to any IAM entity by typing or copying them into the simulator.

   - **Simulate Real-World Scenarios:** Provide context keys (e.g., IP addresses, dates) in policy conditions to simulate real-world scenarios.

   - **Identify Specific Statements:** Determine which specific statements in a policy affect access to resources or actions.

**Granting Permissions:**

**Console Users:**

   - **For Users:**
  - `iam:GetGroupPolicy`
  - `iam:GetPolicy`
  - `iam:GetPolicyVersion`
  - `iam:GetUser`
  - `iam:GetUserPolicy`
  - `iam:ListAttachedUserPolicies`
  - `iam:ListGroupsForUser`
  - `iam:ListGroupPolicies`
  - `iam:ListUserPolicies`
  - `iam:ListUsers`

   - **For Groups:**
  - `iam:GetGroup`
  - `iam:GetGroupPolicy`
  - `iam:GetPolicy`
  - `iam:GetPolicyVersion`
  - `iam:ListAttachedGroupPolicies`
  - `iam:ListGroupPolicies`
  - `iam:ListGroups`

   - **For Roles:**
  - `iam:GetPolicy`
  - `iam:GetPolicyVersion`
  - `iam:GetRole`
  - `iam:GetRolePolicy`
  - `iam:ListAttachedRolePolicies`
  - `iam:ListRolePolicies`
  - `iam:ListRoles`

   - **For SCPs:**
  - `organizations:DescribePolicy`
  - `organizations:ListPolicies`
  - `organizations:ListPoliciesForTarget`
  - `organizations:ListTargetsForPolicy`

**API Users:**

   - **For Users, Groups, or Roles:**
  - `iam:GetContextKeysForPrincipalPolicy`
  - `iam:SimulatePrincipalPolicy`

   - **For Custom Policies:**
  - `iam:GetContextKeysForCustomPolicy`
  - `iam:SimulateCustomPolicy`

**Example IAM Policy:**

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "iam:GetGroup",
                "iam:GetGroupPolicy",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:GetUser",
                "iam:GetUserPolicy",
                "iam:ListAttachedGroupPolicies",
                "iam:ListAttachedRolePolicies",
                "iam:ListAttachedUserPolicies",
                "iam:ListGroups",
                "iam:ListGroupPolicies",
                "iam:ListGroupsForUser",
                "iam:ListRolePolicies",
                "iam:ListRoles",
                "iam:ListUserPolicies",
                "iam:ListUsers"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

**Permissions Table:**

| Role                      | Actions                                                                                                                                                  |
|---------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Console Users (Users)** | `iam:GetGroupPolicy`, `iam:GetPolicy`, `iam:GetPolicyVersion`, `iam:GetUser`, `iam:GetUserPolicy`, `iam:ListAttachedUserPolicies`, `iam:ListGroupsForUser`, `iam:ListGroupPolicies`, `iam:ListUserPolicies`, `iam:ListUsers` |
| **Console Users (Groups)**| `iam:GetGroup`, `iam:GetGroupPolicy`, `iam:GetPolicy`, `iam:GetPolicyVersion`, `iam:ListAttachedGroupPolicies`, `iam:ListGroupPolicies`, `iam:ListGroups` |
| **Console Users (Roles)** | `iam:GetPolicy`, `iam:GetPolicyVersion`, `iam:GetRole`, `iam:GetRolePolicy`, `iam:ListAttachedRolePolicies`, `iam:ListRolePolicies`, `iam:ListRoles`  |
| **Console Users (SCPs)**  | `organizations:DescribePolicy`, `organizations:ListPolicies`, `organizations:ListPoliciesForTarget`, `organizations:ListTargetsForPolicy` |
| **API Users (Principal)** | `iam:GetContextKeysForPrincipalPolicy`, `iam:SimulatePrincipalPolicy`                                                                                     |
| **API Users (Custom)**    | `iam:GetContextKeysForCustomPolicy`, `iam:SimulateCustomPolicy`                                                                                         |

## 11.19 IAM Access Analyzer

IAM Access Analyzer is a tool designed to continuously monitor and evaluate policies for changes, helping to identify and address security and governance issues related to resource sharing. It provides insights into who has access to AWS resources both publicly and across accounts, allowing for proactive management of unintended access.

Here is a summary of IAM Access Analyzer:

   - **Purpose**: Monitors policies for changes, identifies security and governance issues related to resource sharing, and helps protect resources from unintended access.
   - **Findings**: Provides detailed findings on who has public and cross-account access to AWS resources.
   - **Accessibility**: Findings are available through the IAM, Amazon S3, and AWS Security Hub consoles, as well as via APIs. Reports can be exported for auditing.

How It Works

1. **Enable IAM Access Analyzer**: 
   - Create an analyzer for your AWS account or organization (using AWS Organizations). This is known as the zone of trust.
   - Only one analyzer can be created per Region in an account.

2. **Resource Types Supported**:
      - **IAM Roles**: Analyzes trust policies and generates findings for roles within the zone of trust.
      - **Amazon S3 Buckets**: Generates findings for bucket policies, ACLs, or access points that grant access to external entities.
      - **AWS KMS Keys**: Generates findings if key policies or grants allow external access.
      - **AWS Lambda Functions**: Generates findings for policies that grant access to functions to external entities.
      - **Amazon SQS Queues**: Generates findings for policies that allow external access to queues.

Granting Permissions

To configure and use IAM Access Analyzer effectively, ensure the account has the necessary permissions:

   - **Full Access**: Apply the `IAMAccessAnalyzerFullAccess` managed policy.
   - **Read-Only Access**: Apply the `IAMAccessAnalyzerReadOnlyAccess` managed policy.
   - **Custom Policy Requirements**:
  - Include `access-analyzer:*` and `iam:CreateServiceLinkedRole` permissions.

**Example Policy JSON**:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "access-analyzer:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "iam:AWSServiceName": "access-analyzer.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "organizations:DescribeAccount",
        "organizations:DescribeOrganization",
        "organizations:DescribeOrganizationalUnit",
        "organizations:ListAccounts",
        "organizations:ListAccountsForParent",
        "organizations:ListAWSServiceAccessForOrganization",
        "organizations:ListChildren",
        "organizations:ListDelegatedAdministrators",
        "organizations:ListOrganizationalUnitsForParent",
        "organizations:ListParents",
        "organizations:ListRoots"
      ],
      "Resource": "*"
    }
  ]
}
```

Summary Table

| **Feature**                  | **Details**                                                                                     |
|------------------------------|-------------------------------------------------------------------------------------------------|
| **Purpose**                  | Monitor and analyze policies, identify security issues, protect resources from unintended access |
| **Findings Provided**        | Public and cross-account access to AWS resources                                                |
| **Accessibility**            | IAM, Amazon S3, AWS Security Hub consoles, APIs, and exportable reports                           |
| **Resource Types Supported** | IAM Roles, Amazon S3 Buckets, AWS KMS Keys, AWS Lambda Functions, Amazon SQS Queues              |
| **Permission Policies**      | `IAMAccessAnalyzerFullAccess`, `IAMAccessAnalyzerReadOnlyAccess`, custom policy with specific permissions |


## 11.20 IAM Access Analyzer


**Viewing Access History**

IAM Access Analyzer helps you identify unused permissions and refine your policies to adhere to the principle of least privilege by providing last accessed information for IAM entities and policies.

**Types of Last Accessed Information**

   - **Allowed AWS Service Information**: Shows the services that were accessed.
   - **Allowed Action Information**: Includes actions such as creation, deletion, and modification (available only for Amazon S3 management actions).

**Information Available for Each IAM Resource**

| IAM Resource | Description |
|--------------|-------------|
| User         | Shows the last time a user tried to access each allowed service. |
| Group        | Displays the last time a group member attempted to access each allowed service, including the total number of members who attempted access. |
| Role         | Provides the last time someone used the role to access each allowed service. |
| Policy       | Shows the last time a user or role attempted to access each allowed service, including the total number of entities that attempted access. |

**Access Advisor Tab**

- To view last accessed information:
  1. Navigate to the IAM dashboard.
  2. Select the desired IAM resource.
  3. Choose the Access Advisor tab to view the information.

**Tracking Period**

- Recent activity appears within 4 hours in the IAM console.
- Service information tracking period: Last 400 days.
- Actions information tracking period began on April 12, 2020.

**Considerations**

   - **PassRole**: The `iam:PassRole` action is not tracked.
   - **Report Owner**: Only the principal who generates the report can view its details. Credentials must match those of the principal who generated the report.
   - **IAM Entities**: Information includes users, roles in your account, or the AWS account root user in the specified Organizations entity. Unauthenticated attempts are not included.
   - **IAM Policy Types**: Includes policies directly attached to a role or user, but not resource-based policies, access control lists, AWS Organizations SCPs, IAM permissions boundaries, or session policies.
   - **Required Permissions**: To use the IAM console, CLI, or API, you need specific IAM permissions such as `iam:GenerateServiceLastAccessedDetails`, `iam:Get*`, `iam:List*`, etc.

**Required Permissions for Console, CLI, or API**

| Operation            | Required Permissions                                  |
|----------------------|-------------------------------------------------------|
| IAM Console          | `iam:GenerateServiceLastAccessedDetails`, `iam:Get*`, `iam:List*` |
| AWS CLI/API          | `iam:GenerateServiceLastAccessedDetails`, `iam:GetServiceLastAccessedDetails`, `iam:GetServiceLastAccessedDetailsWithEntities`, `iam:ListPoliciesGrantingServiceAccess` |

---

## 11.21 Troubleshooting with AWS CloudTrail


**AWS CloudTrail Overview**

AWS CloudTrail records actions taken by IAM users or roles, capturing all AWS service API calls as events. This includes calls from the AWS Management Console, AWS CLI, and API tools. CloudTrail is enabled by default for new AWS accounts and can be configured to deliver events continuously to an Amazon S3 bucket for further analysis. If a trail is not configured, recent events can still be viewed in the CloudTrail console under Event history.

**Common Questions CloudTrail Can Answer**

| **Question**                                               | **Description**                                                                                   |
|------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| What actions did a user take over a given period of time? | Analyze the log to determine what actions a user performed during a specific time frame.        |
| For a given resource, which AWS user has taken actions on it? | Identify the AWS user who performed actions on a specific resource.                             |
| What is the source IP address of a given activity?         | Locate the IP address from which a particular activity originated.                               |
| Which user activities failed due to inadequate permissions? | Find activities that failed because the user lacked the necessary permissions.                    |

**AWS CloudTrail Log Example**

| **Log Content**  | **Description**                                                                                        |
|------------------|--------------------------------------------------------------------------------------------------------|
| Who made the request? | Verify the IAM user’s account ID and access key ID. For example, janedoe made a request.         |
| When and from where? | Check the request’s date and source. For instance, a request on July 15, 2020, at 9:40 PM (UTC) from the AWS Management Console. |
| What happened?       | Identify the specific action and policy involved. For example, a GetUserPolicy API call for policy ReadOnlyAccess-JaneDoe-201407151307. |

**CloudTrail Log Fields**

| **Field**            | **Description**                                                                                             |
|----------------------|-------------------------------------------------------------------------------------------------------------|
| eventTime            | The date and time of the event in UTC.                                                                     |
| eventType            | Type of event: AwsConsoleSignin, AwsServiceEvent, or AwsApiCall.                                            |
| eventSource          | The service where the request was made, e.g., cloudformation.amazonaws.com for AWS CloudFormation.          |
| eventName            | The specific action requested, such as GetUserPolicy.                                                      |
| sourceIPAddress      | The IP address or DNS name from which the request originated.                                               |
| userAgent            | The tool or application used to make the request, e.g., aws-sdk-java, aws-cli/1.3.23.                      |
| errorMessage         | Any error message returned by the service.                                                                  |
| requestParameters    | Parameters sent with the API call, such as bucketName in an S3 API call.                                   |
| resources            | AWS resources involved in the event, such as the resource's ARN or account number.                          |
| userIdentity         | Details about the user or service that made the call, including Root, IAMUser, AssumedRole, FederatedUser, AWSAccount, or AWSService. |

**Additional Information**

- CloudTrail logs sign-in events for AWS Management Console, AWS forums, and AWS Marketplace.
- Successful and failed sign-in attempts for IAM and federated users are logged, but only successful sign-ins for AWS account root users.



## 11.22 AWS Well-Architected Tool

The AWS Well-Architected Tool is a self-service utility designed to assist users in evaluating their AWS workloads according to best practices. It offers a consistent process for reviewing workload architectures, identifying potential risks, and recommending improvements.

   - **Purpose**: Helps review AWS workloads without needing an AWS solutions architect.
   - **Functionality**:
  - Define your workload.
  - Answer questions across six pillars of the AWS Well-Architected Framework.
  - Receive a plan with improvement recommendations.
   - **Cost**: Free to use; charges apply only for consumed AWS resources.
   - **Availability**: Limited to specific AWS Regions.

Pillars of the AWS Well-Architected Framework

| Pillar                | Description |
|-----------------------|-------------|
| Operational Excellence | Focuses on operations and monitoring of workloads. |
| Security              | Addresses the protection of information and systems. |
| Reliability           | Ensures the workload is resilient and can recover from failures. |
| Performance Efficiency | Optimizes resources for performance and efficiency. |
| Cost Optimization     | Manages costs and ensures efficient use of resources. |

For further details and to check availability in different Regions, refer to the AWS Well-Architected Tool FAQs.

