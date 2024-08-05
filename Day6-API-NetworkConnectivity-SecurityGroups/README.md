# 1. AWS API Gateway

AWS API Gateway is a fully managed service provided by Amazon Web Services that allows developers to create, publish, maintain, monitor, and secure APIs at any scale. It acts as a gateway for managing requests and responses between clients and backend services. Here’s a breakdown of its key features:

1. **API Creation and Management**:
   - **Create APIs**: You can create RESTful APIs, WebSocket APIs, or HTTP APIs.
   - **Design**: Define API endpoints, methods, and request/response models. You can use Swagger or OpenAPI specifications to define the API structure.
   - **Deploy**: Deploy APIs to different stages (e.g., development, staging, production) and manage different versions.

2. **Integration**:
   - **Backend Integration**: Connect APIs to various backend services like AWS Lambda functions, Amazon EC2 instances, or any HTTP endpoint.
   - **Mapping Templates**: Transform incoming requests and outgoing responses using mapping templates.

3. **Security**:
   - **Authentication**: Integrate with AWS Identity and Access Management (IAM) for access control, use Amazon Cognito for user authentication, or enable API key-based authentication.
   - **Authorization**: Implement authorization strategies using custom authorizers or AWS Lambda authorizers.

4. **Monitoring and Logging**:
   - **CloudWatch Integration**: Monitor API usage, performance metrics, and set up alarms for various API metrics.
   - **Logging**: Enable logging of request and response data to AWS CloudWatch Logs.

5. **Throttling and Caching**:
   - **Throttling**: Control the rate of API requests to prevent abuse and ensure fair usage.
   - **Caching**: Improve performance by caching API responses and reducing load on backend services.

6. **Documentation**:
   - **API Documentation**: Automatically generate and publish API documentation for developers to understand how to use the API.

7. **Deployment Options**:
   - **Custom Domain Names**: Use your own domain names for APIs and configure custom domain mappings.
   - **Edge-optimized, Regional, or Private**: Choose how your API is exposed (e.g., globally via CloudFront, within a region, or within a VPC).

8. **Versioning**:
   - **Multiple Versions**: Manage and deploy different versions of your API to handle updates and backward compatibility.


# 2. AWS Network Connectivity Options

## 2.1. General Concepts

- **Software-Defined Networking**: Cloud networks use software-defined networking rather than physical hardware, shifting network management from physical equipment to virtualized, software-based configurations.

- **Multi-Tier Architecture**: 
  - **Presentation Tier**: User interface layer.
  - **Application/Logic Tier**: Handles the business logic.
  - **Data Tier**: Manages data storage and retrieval.
  - This architecture organizes software components by function into distinct layers, often involving three tiers.

- **Multi-VPC Architecture**:
  - **Amazon VPC**: Allows you to create isolated virtual networks for deploying AWS resources.
  - **Multi-VPC Setup**: Enables communication and data sharing between multiple virtual private clouds to support complex applications.

- **High Availability**:
  - **Goal**: Minimizes downtime and maintains communication continuity.
  - **Techniques**: Implementing redundant components, parallel deployments, and eliminating single points of failure.

- **Hybrid Network**:
  - **Definition**: Connects at least two independent networks (cloud or on-premises) to enable communication across environments.
  - **Purpose**: Allows interaction between private and public clouds, simulating traditional network behavior.

- **High Performance**:
  - **Objective**: Reduces network delays and enhances user experience.
  - **Approach**: Directs data along the shortest and most efficient path to minimize latency and improve service quality.

- **Redundancy and Load Balancing**: Essential for high availability, ensuring that backup systems are in place and traffic is evenly distributed to avoid overloading any single component.

- **Failure Management**: Focuses on preventing communication disruptions and maintaining network functionality despite potential failures or issues.

- **Network Isolation**: Using VPCs to segment applications and resources, enhancing security and organizational control within the AWS cloud.

- **Scalability**: Cloud networks can dynamically adjust to handle varying loads and expand as needed, providing flexibility and efficiency for application deployment.



## 2.2 Connectivity Concept Benefits

1. **Multi-Tier Architecture**
   - Provides extra layers of defense against threats.
   - Enhances the availability of solutions by isolating sensitive data behind multiple layers.
   - Example: Data is placed at the end of a chain with presentation and application tiers preceding it.

2. **Multi-VPC Architecture**
   - Separates and isolates Virtual Private Clouds (VPCs) for enhanced security and flexibility.
   - Allows for dedicated VPCs for different applications or functions (e.g., sales app, customer database, SecOps tools).
   - Facilitates controlled and secure interactions between VPCs through dedicated connections.

3. **High Availability**
   - Focuses on creating redundancy to avoid single points of failure.
   - Uses techniques like redundant components, standby equipment, and multiple network circuits to ensure continuous operation.
   - In AWS, achieves high availability by distributing resources across multiple Availability Zones within a Region.

4. **Hybrid Network**
   - Connects on-premises infrastructure with AWS Cloud for enhanced agility and scalability.
   - Allows for scenarios where data remains on-premises while leveraging cloud resources for specific needs.
   - Supports compliance and security requirements while utilizing cloud benefits.

5. **High Performance**
   - Aims to reduce latency and deliver data quickly to users.
   - Factors affecting performance include application processing time, connection delays, packet loss, bandwidth constraints, and physical distance.
   - Techniques to reduce latency involve optimizing routes, minimizing packet delays, and managing traffic patterns.

6. **Application Flexibility**
   - Enables applications to adapt to various requirements by utilizing different tiers and VPC configurations.
   - Facilitates dynamic scaling and resource allocation based on demand.

7. **Cost Efficiency**
   - Optimizes resource usage and cost by leveraging cloud scalability and hybrid solutions.
   - Reduces the need for over-provisioning in on-premises environments by utilizing cloud resources on-demand.

8. **Compliance and Security**
   - Ensures that hybrid networks adhere to regulatory requirements while benefiting from cloud scalability.
   - Employs robust security measures across multi-tier and multi-VPC architectures to protect sensitive data.

9. **Performance Monitoring**
   - Involves measuring network performance metrics to set goals and evaluate latency reduction techniques.
   - Uses performance simulations during development to identify and address potential bottlenecks.

10. **Redundancy and Failover**
    - Implements strategies to handle component failures and maintain service availability.
    - Includes using backup circuits, standby equipment, and geographically distributed resources.

11. **Data and Application Isolation**
    - Provides isolation between different application components and data for enhanced security and stability.
    - Uses separate VPCs and availability zones to protect critical resources.

12. **Network Optimization**
    - Focuses on optimizing network routes and resources to achieve the best performance.
    - Includes considerations for memory resources, traffic patterns, and efficient protocol use.


## 2.3 VPC Endpoints and AWS PrivateLink


1. **Private Connectivity**: VPC endpoints enable private connections between your VPC and supported AWS services without using public IP addresses. Traffic remains within the AWS network.

2. **Types of VPC Endpoints**:
   - **Gateway VPC Endpoints**: Target specific IP routes in a VPC route table for services like Amazon S3 and DynamoDB. They use prefix lists to route traffic.
   - **Interface Endpoints**: Powered by AWS PrivateLink, these are elastic network interfaces with private IP addresses used for traffic destined to AWS services or VPC endpoint services.
   - **Gateway Load Balancer Endpoints**: Also powered by AWS PrivateLink, these endpoints intercept traffic and route it through Gateway Load Balancers for services like security inspection.

3. **AWS PrivateLink**: Provides private connections between VPCs and AWS services, avoiding exposure to the public internet. It establishes TCP connections securely and scales easily.

4. **Benefits of AWS PrivateLink**:
   - **Security**: Avoids public IPs and internet traversal, using private IPs within a VPC for secure communication.
   - **Simplification**: Eliminates the need for internet gateways, NAT gateways, or VPC peering, simplifying network management.
   - **Capabilities**: Supports private access to AWS services, integration with on-premises networks via Direct Connect, and allows services to be offered via AWS Marketplace.

5. **AWS PrivateLink Considerations**:
   - **IPv6 Support**: Not supported.
   - **Traffic Visibility**: Traffic appears to originate from the Network Load Balancer. Proxy Protocol v2 can be used for additional traffic insights.
   - **DNS**: Private DNS hostnames resolve within the VPC. Custom DNS names can be configured for user-friendly access.

6. **DNS Hostname Types**:
   - **Endpoint-specific Regional DNS**: Includes a unique endpoint identifier and region.
   - **Zonal-specific DNS**: Includes Availability Zone in the hostname for cross-zone load balancing.
   - **Private DNS Hostnames**: Allows aliasing of endpoint DNS names to custom names like `myservice.example.com`.

7. **Pricing**:
   - **Interface and Gateway Load Balancer Endpoints**: Charged by the hour and per gigabyte processed.
   - **Gateway Endpoints**: No additional charge; standard data transfer and resource usage charges apply.

8. **Compliance**: VPC endpoints are useful for meeting compliance requirements by ensuring traffic does not leave the AWS network.


## 2.4.  AWS VPC Peering


1. **Definition**: VPC peering is a networking connection between two Virtual Private Clouds (VPCs) allowing private traffic routing between them.

2. **Benefits**:
   - **High Availability**: VPC peering does not rely on gateways or VPN connections, eliminating single points of failure and bandwidth bottlenecks.
   - **Inter-Region Peering**: Allows secure communication between VPCs in different AWS Regions using private IP addresses. Traffic is encrypted and does not traverse the public internet, reducing security threats.
   - **Cost-Effective**: Facilitates resource sharing and geographic redundancy without additional hardware or complex setup.

3. **Peering Across Accounts**: You can create VPC peering connections between VPCs in different AWS accounts.

4. **Peering Scenarios**:
   - **Full Resource Sharing**: Connects multiple VPCs in a mesh network where each VPC has a direct peering connection with every other VPC.
   - **Centralized Resource Access**: Establishes a peering connection to a central VPC for shared resources while other VPCs do not communicate directly with each other.

5. **Non-Valid Peering Configurations**:
   - **Overlapping CIDR Blocks**: VPC peering is not possible between VPCs with overlapping IPv4 CIDR blocks, even if intended for IPv6 communication.
   - **Transitive Peering**: Traffic cannot be routed between VPCs through an intermediary VPC; a direct peering connection is required.
   - **Edge-to-Edge Routing Restrictions**: Peering cannot extend through VPNs, Direct Connect, internet gateways, NAT devices, or gateway VPC endpoints.

6. **Pricing**: There is no cost for setting up or maintaining a VPC peering connection. Data transfer across peering connections is charged per gigabyte.




## 2.5.  AWS Direct Connect

1. **Private and Reliable Connection**:
   - Provides a private, reliable connection to AWS from a physical facility like a data center or office.
   - Offers complete control over data exchanged between your AWS environment and your chosen physical location.

2. **Performance and Availability**:
   - Guarantees 99.99% availability with consistent performance.
   - Reduces bandwidth costs compared to other connectivity options.

3. **Connection Types and Bandwidth**:
   - Supports physical connections of 1, 10, and 100 Gbps.
   - The 100-Gbps connection is ideal for large-scale data transfers, such as media distribution and financial trading systems.

4. **Link Aggregation Control Protocol (LACP)**:
   - Allows multiple dedicated connections to be grouped into link aggregation groups (LAGs).
   - Enables management of multiple connections as a single connection.

5. **Connection Specifications**:
   - Connections must be dedicated with port speeds of 1 Gbps, 10 Gbps, or 100 Gbps.
   - All connections in a LAG must have the same bandwidth.
   - A maximum of two 100-Gbps connections or four connections with lower speeds can be used in a LAG.

6. **Network Requirements**:
   - Must be co-located with a Direct Connect location, work with a Direct Connect Partner, or use an independent service provider.
   - Requires single-mode fiber with specific transceivers (e.g., 1000BASE-LX, 10GBASE-LR, 100GBASE-LR4).

7. **VLAN and BGP Configuration**:
   - Must support 802.1Q VLAN encapsulation across the connection.
   - Devices must support Border Gateway Protocol (BGP) with optional BGP MD5 authentication.
   - Asynchronous Bidirectional Forwarding Detection (BFD) can be configured.

8. **Letter of Authorization and Connecting Facility Assignment (LOA-CFA)**:
   - AWS provides LOA-CFA to show facility operators that AWS approves the connection request.
   - Completes the physical setup of the Direct Connect connection.

9. **Virtual Interface Types**:
   - **Private Virtual Interface**: Routes traffic to any VPC resource in the same private IP space.
   - **Public Virtual Interface**: Routes traffic to any VPC or AWS regional resource with a public IP address.
   - **Transit Virtual Interface**: Routes traffic through an AWS Transit Gateway to any VPC or regional resource.

10. **Pricing**:
    - Charges are based on port hours and outbound data transfer.
    - No minimum fee; pay only for what you use.

11. **Setup and Configuration**:
    - Use AWS Management Console to choose virtual interface types and configure the Direct Connect gateway.
    - Physical components and network requirements must be met before setting up the connection.


## 2.6. AWS Site-to-Site VPN and AWS Client VPN



### AWS Site-to-Site VPN
- **Purpose**: Connects on-premises networks to AWS VPCs securely using IPsec technology.
- **Components**:
  - **Customer Gateway**: Represents your on-premise gateway device with routing information.
  - **Customer Gateway Device**: The physical or software device on the customer side.
  - **Virtual Private Gateway**: The VPN concentrator on AWS’s side of the connection.
  - **Transit Gateway**: Acts as a hub to interconnect VPCs and on-premises networks.
- **Features**:
  - Uses two tunnels per connection, terminating in different Availability Zones.
  - Supports IPv4 and IPv6-Dualstack with separate tunnels; IPv6 outer tunnel connections are not supported.
  - Limited throughput: 1.25 Gbps per tunnel (1 Gbps in practice) with Transit Gateway supporting up to 2.5 Gbps aggregate.
  - ECMP and MED supported with AWS Transit Gateway.
  - Public IPv4 addresses used, no private Direct Connect support.
  - Accelerated Site-to-Site VPN connects via AWS Global Accelerator.
- **Monitoring**: Metrics available through Amazon CloudWatch, recorded for 15 months.
- **Pricing**: Charges include hourly rates for connections, data transfer out, and additional fees for accelerated connections and Global Accelerators.

### AWS Client VPN
- **Purpose**: Provides secure access to AWS resources and on-premises networks using OpenVPN technology.
- **Components**:
  - **Client VPN Endpoint**: Configured by administrators to control access to networks and resources.
  - **VPN Client Application**: Software used by users to connect to the Client VPN endpoint.
  - **Configuration File**: Provided by administrators, includes endpoint and certificate information.
- **Features**:
  - Supports only IPv4 traffic.
  - SAML 2.0-based federated authentication works with specific AWS clients; integration with AWS Single Sign-On requires a workaround.
  - CIDR ranges must be /22 to /12 and must not overlap with VPC routes.
  - No support for subnet associations in dedicated tenancy VPCs or overlapping client CIDR ranges.
  - AWS Certificate Manager certificates require private key access for mutual authentication.
- **Monitoring**: Usage reporting through CloudWatch Logs, metrics published every five minutes.
- **Pricing**: Based on active client connections per hour and number of associated subnets; partial hour usage is prorated.


## 2.7. AWS Transit Gateway

1. **High Availability and Scalability**
   - AWS Transit Gateway provides scalable interconnectivity between VPCs and on-premises networks.
   - It supports a hub-and-spoke network architecture for consolidating and managing routing within a Region.

2. **Inter-Regional Peering**
   - Facilitates inter-regional routing by peering with other Transit Gateways.
   - Routes network traffic between VPCs in different Regions over the AWS global backbone, avoiding the internet.

3. **Hybrid Network Integration**
   - Integrates with hybrid network configurations, such as Direct Connect and AWS Site-to-Site VPN connections.

4. **Attachments**
   - Supports various connections including VPCs, SD-WAN appliances, Direct Connect gateways, peering connections with other transit gateways, and VPN connections.

5. **MTU (Maximum Transmission Unit)**
   - Supports an MTU of 8,500 bytes for VPC, Direct Connect, and peering connections.
   - Supports an MTU of 1,500 bytes for VPN connections.

6. **Route Tables**
   - Each Transit Gateway has a default route table and can have additional route tables.
   - Route tables contain dynamic and static routes determining the next hop based on the destination IP address.

7. **Associations**
   - Each attachment is linked to exactly one route table.
   - A route table can be associated with multiple attachments.

8. **Route Propagation**
   - VPC, VPN, or Direct Connect gateways can propagate routes to a Transit Gateway route table.
   - Routes from Direct Connect attachments are propagated by default; static routes are required for VPCs.

9. **Peering Connections**
   - AWS Transit Gateway supports simplified management of inter-region traffic through fewer peering connections compared to VPC peering.
   - Reduces the need for multiple routing configurations and security policies.

10. **Performance and Limits**
    - AWS Transit Gateway FAQs provide detailed information about performance and limits.

11. **Pricing**
    - Charges are based on the number of connections per hour and per GB of data processed.
    - For detailed pricing, refer to the AWS Transit Gateway pricing page.


## 2.8. Design Patterns 



### 2.8.1. Simplifying Multi-VPC Routing

#### Scenario Overview
- **Context:** Post-merger AWS environment with multiple VPCs from two companies.
- **Initial Setup:** VPCs were peered to facilitate the merger, creating a complex network of VPC peering and site-to-site VPNs.
- **Issue:** Increased service interruptions due to configuration conflicts and lack of centralized traffic management.

#### Identified Problems
- **Configuration Conflicts:** Frequent service interruptions were caused by configuration conflicts during new system implementations or modifications.
- **Complex Routing:** The existing mesh pattern of VPN and VPC peering connections led to complex routing configurations.

#### Proposed Solution
- **Design Pattern:** Transition to a hub-and-spoke model using AWS Transit Gateway.
- **Plan:** Replace existing VPC peering connections with a central transit gateway to streamline network management.

#### Benefits of the Hub-and-Spoke Model
1. **Centralized Management:** The transit gateway centralizes all routing tables, simplifying network management.
2. **Reduced VPC Peering:** One transit gateway replaces all five VPC peering connections.
3. **Streamlined VPN Connections:** The number of site-to-site VPN connections is reduced to one, maintaining satellite office access.
4. **Optimized Direct Connect:** Direct Connect terminates on the transit gateway, reducing the number of Direct Connect gateways to one without affecting access from the main office.

#### Summary
- **Outcome:** The transition to a hub-and-spoke design with AWS Transit Gateway reduces complexity, operational overhead, and configuration conflicts, providing a more manageable and efficient network setup.


### 2.8.2. Highly Available Hybrid Network Connections

How to design hybrid networks with high availability by using AWS Direct Connect and other methods.



1. **Direct Connect Service Availability**
   - AWS guarantees a 99.99% service-level agreement (SLA) for Direct Connect.
   - The SLA applies from the AWS router to the AWS environment, not to the segments before reaching AWS.

2. **Limitations of Direct Connect**
   - If there's an issue with the company's router or circuit at the Direct Connect Partner locations, connectivity to AWS can be disrupted.
   - Problems at the partner locations can prevent the company from reaching AWS until resolved.

3. **Original Network Design**
   - In the original setup, there were single points of failure.
   - If a failure occurred at one location or in the connectivity setup, it could affect access to AWS.

4. **Improved Design**
   - The updated design aims to eliminate single points of failure.
   - This involves using multiple Direct Connect Partner locations and routes to ensure continuous connectivity to AWS.

5. **Redundancy and High Availability**
   - Adding redundancy in network design enhances resilience.
   - Ensuring multiple connection paths can prevent outages caused by failures at a single point.

6. **Design Considerations**
   - Evaluate network design to incorporate redundancy.
   - Plan for failure scenarios and implement failover strategies.

7. **Practical Implications**
   - Ensuring high availability requires thoughtful design and testing.
   - Companies must consider both AWS and partner location failures.

8. **Learning Resources**
   - Hot spots in the lesson provide deeper insights into the network design and failure scenarios.
   - Select each hot spot for detailed explanations and design improvements.

- Understanding and implementing resilient network designs are crucial for maintaining high availability and minimizing disruptions in hybrid network setups.


### 2.8.3. AWS Regional High Availability: Cross-Regional VPC Peering


1. **Cross-Regional Application Deployment:**
   - **Latency Optimization:** Routes users to the Region with the lowest latency, ensuring the best response times based on their location.
   - **Load Distribution:** Balances application load across multiple Regions to prevent performance degradation in case one Region's application decreases in performance.
   - **Redundancy:** Provides redundancy by ensuring users can still access the application from alternate Regions if one Region experiences an interruption.

2. **Amazon Route 53:**
   - A global DNS service that manages traffic globally through various routing types, such as latency-based routing.
   - Routes end users to the Region with the least latency for optimal performance.

3. **Elastic Load Balancing:**
   - Each Region has a public load balancer that handles incoming traffic and distributes it to EC2 instances in an Auto Scaling group.
   - EC2 instances in each Region host the application specific to that Region.

4. **Application Database:**
   - Transactions and data are stored in clustered backend databases in each Region, ensuring consistency and reliability.

5. **VPC Peering Connection:**
   - Uses inter-Region VPC peering to connect regional VPCs, enabling cost-effective data replication between Regions.
   - Ensures inter-Region traffic is encrypted and remains on the global AWS backbone, avoiding public internet traversal.

6. **Session Resumption:**
   - If a user’s session is interrupted, they are routed to the alternate Region upon reconnection.
   - Session data is synchronized across Regions via the VPC peering connection, allowing users to resume their session seamlessly.

7. **Inter-Region Traffic Security:**
   - Inter-Region traffic is encrypted and does not traverse the public internet, maintaining security and privacy.

8. **Service Documentation:**
   - For detailed information, refer to [Cross-Region DNS-Based Load Balancing and Failover](#) and [VPC Peering Basics](#).


### 2.8.4. AWS Transit Gateway Peering Overview

- **Centralized Traffic Management**: AWS Transit Gateway enables routing between VPCs within an AWS Region, facilitating centralized traffic management across resources, services, and accounts.

- **Support for VPN and Direct Connect**: Transit Gateway integrates with AWS VPN and Direct Connect gateways, allowing centralized management of incoming and outgoing traffic.

- **Inter-Region Peering**: AWS Transit Gateway supports inter-Region peering, creating a nontransitive, bidirectional route between transit gateways in different Regions.

- **Encryption and Security**: Traffic across inter-Region peering connections is automatically encrypted and travels over the global AWS backbone, avoiding public internet threats such as DDoS and man-in-the-middle attacks.

- **Regional Service Design**: Transit gateways function as a regional service, supporting a hub-and-spoke network design within their respective Region. This allows traffic to route from any connected VPC to any other VPC within the same Region.

- **Nontransitive Routing**: Inter-Region peering is nontransitive, meaning traffic can only route from a transit gateway in the source Region to the transit gateway in the destination Region, and not through other Regions.

- **Mesh Network Design**: For highly available multi-Region environments, a mesh network design is necessary. Each transit gateway should be peered with every other transit gateway in the environment to ensure efficient traffic movement.

- **Design Considerations**: When designing a multi-Region environment with transit gateways, consider the quotas and limits for your transit gateways to ensure optimal performance and capacity.


# 3. Differences Between Security Groups and NACLs

1. **Scope**:
   - **Security Groups**: Operate at the instance level (associated with EC2 instances).
   - **NACLs**: Operate at the subnet level (applied to all instances within a subnet).

2. **Statefulness**:
   - **Security Groups**: Stateful; if you allow an incoming request, the response is automatically allowed, regardless of outbound rules.
   - **NACLs**: Stateless; responses to allowed inbound requests must be explicitly allowed by outbound rules and vice versa.

3. **Rules Evaluation**:
   - **Security Groups**: Rules are evaluated based on "allow" only; implicit deny if not allowed.
   - **NACLs**: Rules are evaluated in numerical order, and both "allow" and "deny" rules can be specified.

4. **Rule Types**:
   - **Security Groups**: Only allow rules are supported; no deny rules.
   - **NACLs**: Support both allow and deny rules.

5. **Default Rules**:
   - **Security Groups**: Default to allow all outbound traffic and deny all inbound traffic unless rules are specified.
   - **NACLs**: Default to allow all inbound and outbound traffic; can be modified to restrict traffic.

6. **Rule Limits**:
   - **Security Groups**: Typically have a higher limit on the number of rules that can be defined compared to NACLs.
   - **NACLs**: Have a limit on the number of inbound and outbound rules, which may be more restrictive.

7. **Application**:
   - **Security Groups**: Applied to individual instances or groups of instances.
   - **NACLs**: Applied to entire subnets, affecting all instances within that subnet.

8. **Associations**:
   - **Security Groups**: An instance can be associated with multiple security groups.
   - **NACLs**: A subnet can be associated with only one NACL at a time, though multiple NACLs can exist.

9. **Default Configuration**:
   - **Security Groups**: Automatically created with a default configuration when a new instance is launched.
   - **NACLs**: Have default settings for default and custom NACLs that can be modified.

10. **Logging**:
    - **Security Groups**: Do not directly provide logging of traffic; logging must be implemented using other services like VPC Flow Logs.
    - **NACLs**: Logging can be enabled for monitoring traffic that is allowed or denied by the rules using VPC Flow Logs.

11. **Rule Specificity**:
    - **Security Groups**: Rules are defined based on IP address, CIDR blocks, or security groups.
    - **NACLs**: Rules are more granular and can be based on IP address, CIDR blocks, and specific ports or ranges.

12. **Default Behavior**:
    - **Security Groups**: Implicitly deny all traffic unless explicitly allowed.
    - **NACLs**: Explicitly deny traffic based on configured rules, with default allow settings unless modified.


