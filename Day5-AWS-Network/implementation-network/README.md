## AWS Architecture and Implementation Explanation
### Configure aws cli for terrafrom
```bash
#install aws cli 
sudo apt install python3-pip -y
pip3 install awscli --upgrade --user

#To configure first create credentials for test_user(create test_user also) from IAM.
#Then use Access key and Secret access key for configration aws cli.
#configure aws cli.
aws configure

#test configuration
aws ls #aws mb s3://test-bucket-create-sd4gsge8 && aws rb s3://test-bucket-create-sd4gsge8



#ssh for vm, log init script
sudo tail -f /var/log/cloud-init-output.log # follow log
sudo cat /var/log/cloud-init-output.log # all log

#access app from htpp://vm-external-ip:8501
#save data with adding new entries
#check bucket for versions
```

---



### Architecture Overview

This Terraform configuration sets up a basic AWS network architecture with a Virtual Private Cloud (VPC), public and private subnets, and EC2 instances. The architecture is designed to demonstrate fundamental AWS networking concepts and provides a foundation for more advanced setups.

### Components and Configuration

1. **Provider Configuration:**
   ```hcl
   provider "aws" {
     region = var.aws_region
   }
   ```
   - Configures the AWS provider to use the specified region for all resources.

2. **Key Pair:**
   ```hcl
   resource "aws_key_pair" "my_key" {
     key_name   = "my-aws-key"
     public_key = file("~/.ssh/my-aws-key.pub")
   }
   ```
   - Creates an SSH key pair to enable secure access to EC2 instances.

3. **VPC (Virtual Private Cloud):**
   ```hcl
   resource "aws_vpc" "my_vpc" {
     cidr_block = "10.0.0.0/16"
   }
   ```
   - Defines a VPC with a CIDR block of `10.0.0.0/16`, providing a private IP address space for the network.

4. **Internet Gateway:**
   ```hcl
   resource "aws_internet_gateway" "my_igw" {
     vpc_id = aws_vpc.my_vpc.id
   }
   ```
   - Attaches an Internet Gateway to the VPC, allowing instances in public subnets to access the internet.

5. **Public Subnet:**
   ```hcl
   resource "aws_subnet" "public_subnet" {
     vpc_id                  = aws_vpc.my_vpc.id
     cidr_block              = "10.0.1.0/24"
     availability_zone       = "${var.aws_region}a"
     map_public_ip_on_launch = true
   }
   ```
   - Creates a public subnet within the VPC. Instances in this subnet will receive a public IP address on launch, allowing them to be accessed from the internet.

6. **Private Subnet:**
   ```hcl
   resource "aws_subnet" "private_subnet" {
     vpc_id            = aws_vpc.my_vpc.id
     cidr_block        = "10.0.2.0/24"
     availability_zone = "${var.aws_region}a"
   }
   ```
   - Creates a private subnet within the VPC. Instances in this subnet do not receive a public IP address and cannot be accessed directly from the internet.

7. **NAT Gateway:**
   ```hcl
   resource "aws_eip" "nat_eip" {
     domain = "vpc"
   }

   resource "aws_nat_gateway" "my_nat_gateway" {
     allocation_id = aws_eip.nat_eip.id
     subnet_id     = aws_subnet.public_subnet.id
   }
   ```
   - Configures a NAT Gateway in the public subnet with an Elastic IP. This allows instances in the private subnet to access the internet for updates and downloads without being directly accessible from the internet.

8. **Route Tables:**
   - **Public Subnet Route Table:**
     ```hcl
     resource "aws_route_table" "public_rt" {
       vpc_id = aws_vpc.my_vpc.id

       route {
         cidr_block = "0.0.0.0/0"
         gateway_id = aws_internet_gateway.my_igw.id
       }
     }

     resource "aws_route_table_association" "public_association" {
       subnet_id      = aws_subnet.public_subnet.id
       route_table_id = aws_route_table.public_rt.id
     }
     ```
     - Routes traffic from the public subnet to the internet via the Internet Gateway.

   - **Private Subnet Route Table:**
     ```hcl
     resource "aws_route_table" "private_rt" {
       vpc_id = aws_vpc.my_vpc.id

       route {
         cidr_block     = "0.0.0.0/0"
         nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
       }
     }

     resource "aws_route_table_association" "private_association" {
       subnet_id      = aws_subnet.private_subnet.id
       route_table_id = aws_route_table.private_rt.id
     }
     ```
     - Routes traffic from the private subnet to the internet via the NAT Gateway.

9. **Security Groups:**
   - **Public Security Group:**
     ```hcl
     resource "aws_security_group" "web_sg" {
       vpc_id = aws_vpc.my_vpc.id

       ingress {
         from_port   = 22
         to_port     = 22
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
       }

       ingress {
         from_port   = 80
         to_port     = 80
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
       }

       ingress {
         from_port   = 443
         to_port     = 443
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
       }

       ingress {
         from_port   = -1
         to_port     = -1
         protocol    = "icmp"
         cidr_blocks = ["0.0.0.0/0"]
       }

       egress {
         from_port   = 0
         to_port     = 0
         protocol    = "-1"
         cidr_blocks = ["0.0.0.0/0"]
       }
     }
     ```
     - Allows SSH (port 22), HTTP (port 80), HTTPS (port 443), and ICMP traffic from anywhere.

   - **Private Security Group:**
     ```hcl
     resource "aws_security_group" "private_sg" {
       vpc_id = aws_vpc.my_vpc.id

       ingress {
         from_port   = 22
         to_port     = 22
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
       }

       ingress {
         from_port   = 80
         to_port     = 80
         protocol    = "tcp"
         cidr_blocks = [aws_subnet.private_subnet.cidr_block]
       }

       ingress {
         from_port   = 443
         to_port     = 443
         protocol    = "tcp"
         cidr_blocks = [aws_subnet.private_subnet.cidr_block]
       }

       ingress {
         from_port   = -1
         to_port     = -1
         protocol    = "icmp"
         cidr_blocks = ["0.0.0.0/0"]
       }

       egress {
         from_port   = 0
         to_port     = 0
         protocol    = "-1"
         cidr_blocks = ["0.0.0.0/0"]
       }
     }
     ```
     - Allows SSH (port 22) from anywhere, and HTTP (port 80) and HTTPS (port 443) traffic from within the private subnet.

10. **EC2 Instances:**
    - **Public Instances:**
      ```hcl
      resource "aws_instance" "public_instance-1" {
        ami             = "ami-003932de22c285676" 
        instance_type   = "t2.micro"
        subnet_id       = aws_subnet.public_subnet.id
        key_name        = aws_key_pair.my_key.key_name
        vpc_security_group_ids = [aws_security_group.web_sg.id]

        tags = {
          Name = "Public-Instance-1"
        }
      }
      
      resource "aws_instance" "public_instance-2" {
        ami             = "ami-003932de22c285676" 
        instance_type   = "t2.micro"
        subnet_id       = aws_subnet.public_subnet.id
        key_name        = aws_key_pair.my_key.key_name
        vpc_security_group_ids = [aws_security_group.web_sg.id]

        tags = {
          Name = "Public-Instance-2"
        }
      }
      ```
      - Launches two EC2 instances in the public subnet with a specified AMI, instance type, and associated security group.

    - **Private Instances:**
      ```hcl
      resource "aws_instance" "private_instance-1" {
        ami             = "ami-003932de22c285676" 
        instance_type   = "t2.micro"
        subnet_id       = aws_subnet.private_subnet.id
        key_name        = aws_key_pair.my_key.key_name
        vpc_security_group_ids = [aws_security_group.private_sg.id]

        tags = {
          Name = "Private-Instance-1"
        }
      }

      resource "aws_instance" "private_instance-2" {
        ami             = "ami-003932de22c285676" 
        instance_type   = "t2.micro"
        subnet_id       = aws_subnet.private_subnet.id
        key_name        = aws_key_pair.my_key.key_name
        vpc_security_group_ids = [aws_security_group.private_sg.id]

        tags = {
          Name = "Private-Instance-2"
        }
      }
      ```
      - Launches two EC2 instances in the private subnet with similar configurations as the public instances but with a different security group.

11. **Outputs:**


    ```hcl
    output "public_instance_ips" {
      value = aws_instance.public_instance-1.public_ip
    }
    
    output "private_instance_ips" {
      value = aws_instance.private_instance-1.private_ip
    }
    ```
    - Outputs the public and private IP addresses of the EC2 instances, which can be used for further configurations or access.

### Summary

This Terraform configuration sets up a simple yet effective AWS network architecture, including a VPC with public and private subnets, NAT Gateway for internet access from private subnets, and EC2 instances with appropriate security groups. This setup is suitable for a variety of use cases, such as hosting web applications and databases in a secure and isolated environment.


---

```hcl
terraform init
terraform plan
terraform graph | dot -Tpng > graph.png
terraform apply


```

Here’s a step-by-step guide to test connectivity between the various components of your AWS infrastructure:

### **Testing Connectivity in Your AWS Infrastructure**

#### **1. Test EC2 Instances Connectivity**

**1.1. Access Public EC2 Instances**

1. **Obtain Public IPs:**
   - Go to the AWS Management Console.
   - Navigate to the EC2 Dashboard.
   - Locate the public EC2 instances (`public_instance-1` and `public_instance-2`).
   - Note their Public IP addresses.

2. **SSH into a Public EC2 Instance:**
   ```bash
   ssh -i ~/.ssh/my-aws-key.pem ec2-user@<PUBLIC_IP_OF_PUBLIC_INSTANCE>
   ```
   Replace `<PUBLIC_IP_OF_PUBLIC_INSTANCE>` with the actual IP address.

**1.2. Test Connectivity from Public to Private Instances**

1. **From the Public EC2 Instance:**
   - SSH into a public EC2 instance as described above.
   - Test connectivity to private instances:
     ```bash
     ping <PRIVATE_IP_OF_PRIVATE_INSTANCE>
     ```
     Replace `<PRIVATE_IP_OF_PRIVATE_INSTANCE>` with the actual IP address of a private instance.
   - Use `telnet` or `nc` to test specific ports:
     ```bash
     telnet <PRIVATE_IP_OF_PRIVATE_INSTANCE> 22
     ```
     This checks if the private instance is accepting SSH connections.

**1.3. Access Private EC2 Instances**

1. **Connect from a Public Instance:**
   - SSH into a public EC2 instance.
   - Use SSH agent forwarding to connect to a private instance:
     ```bash
     ssh -A ec2-user@<PUBLIC_IP_OF_PUBLIC_INSTANCE>
     ssh ec2-user@<PRIVATE_IP_OF_PRIVATE_INSTANCE>
     ```
     Ensure your local SSH agent is running and holding the key.

#### **2. Test Connectivity Between Subnets**

**2.1. Test Connectivity Between Public and Private Subnets**

1. **From a Public EC2 Instance:**
   - SSH into a public EC2 instance.
   - Test connectivity to a private EC2 instance as mentioned above.

2. **From a Private EC2 Instance:**
   - SSH into a private EC2 instance (from a public EC2 instance using SSH forwarding).
   - Test connectivity to a public EC2 instance:
     ```bash
     ping <PUBLIC_IP_OF_PUBLIC_INSTANCE>
     ```

#### **3. Test Internet Connectivity**

**3.1. Test from Public EC2 Instances**

1. **SSH into a Public EC2 Instance:**
   - Use the public IP of one of your public EC2 instances.

2. **Check Internet Connectivity:**
   - Use `curl` or `wget` to test access to an external website:
     ```bash
     curl -I https://www.google.com
     ```
   - Check DNS resolution:
     ```bash
     nslookup www.google.com
     ```

**3.2. Test from Private EC2 Instances**

1. **SSH into a Private EC2 Instance (from a public instance):**
   - Use SSH forwarding to access a private EC2 instance.

2. **Check Internet Connectivity:**
   - Test access to an external website:
     ```bash
     curl -I https://www.google.com
     ```

   - If the private instance cannot access the internet, ensure that the NAT Gateway is correctly configured and associated with the private subnet’s route table.

#### **4. Test VPC Internal Connectivity**

**4.1. Test VPC Internal DNS**

1. **SSH into any EC2 instance (public or private).**
2. **Test internal DNS resolution:**
   - Use the internal DNS name of the EC2 instances to check connectivity:
     ```bash
     ping <EC2_INTERNAL_DNS_NAME>
     ```

### **Summary of Tests**

- **Public Instances:** Test SSH access, internet connectivity, and internal connectivity to private instances.
- **Private Instances:** Test connectivity to public instances and internet access through the NAT Gateway.
- **Subnets:** Ensure that traffic flows between public and private subnets correctly.

By following these instructions, you can verify the connectivity and proper functioning of your AWS infrastructure.

### RESULTS

Creaate EC2 Instance Connect Endpoint for private vms to connect web-based ssh from Endpoints.
- Select VPC
- Select Private Subnet
- Click Create 
- Select Connect using EC2 Instance Connect Endpoint from EC2 Instance Connect
- Select Endpoint
- Click Connect

```bash
### From public-vm-1 to others.
ubuntu@ip-10-0-1-69:~$ ping -c 3 10.0.2.94 #ping public to private-vm-1, should not work.
PING 10.0.2.94 (10.0.2.94) 56(84) bytes of data.

--- 10.0.2.94 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2043ms

ubuntu@ip-10-0-1-69:~$ ping -c 3 10.0.2.222 #ping public to private-vm-2, should not work.
PING 10.0.2.222 (10.0.2.222) 56(84) bytes of data.

--- 10.0.2.222 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2026ms

ubuntu@ip-10-0-1-69:~$ ping -c 3 18.118.31.82 #ping public to public-vm-2-external-ip, should work.
PING 18.118.31.82 (18.118.31.82) 56(84) bytes of data.
64 bytes from 18.118.31.82: icmp_seq=1 ttl=63 time=0.410 ms
64 bytes from 18.118.31.82: icmp_seq=2 ttl=63 time=0.597 ms
64 bytes from 18.118.31.82: icmp_seq=3 ttl=63 time=0.553 ms

--- 18.118.31.82 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2043ms
rtt min/avg/max/mdev = 0.410/0.520/0.597/0.079 ms

ubuntu@ip-10-0-1-69:~$ ping -c 3 10.0.1.32 #ping public to public-vm-2-internal-ip, should work.
PING 10.0.1.32 (10.0.1.32) 56(84) bytes of data.
64 bytes from 10.0.1.32: icmp_seq=1 ttl=64 time=1.06 ms
64 bytes from 10.0.1.32: icmp_seq=2 ttl=64 time=0.488 ms
64 bytes from 10.0.1.32: icmp_seq=3 ttl=64 time=0.468 ms

--- 10.0.1.32 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2026ms
rtt min/avg/max/mdev = 0.468/0.673/1.064/0.276 ms

### From private-vm-1 to others.

ubuntu@ip-10-0-2-94:~$ ping -c 3 10.0.2.94 #ping from private-vm-1 to private-vm-2, should work.
PING 10.0.2.94 (10.0.2.94) 56(84) bytes of data.
64 bytes from 10.0.2.94: icmp_seq=1 ttl=64 time=0.025 ms
64 bytes from 10.0.2.94: icmp_seq=2 ttl=64 time=0.036 ms
64 bytes from 10.0.2.94: icmp_seq=3 ttl=64 time=0.035 ms

--- 10.0.2.94 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2051ms
rtt min/avg/max/mdev = 0.025/0.032/0.036/0.005 ms

ubuntu@ip-10-0-2-94:~$ ping -c 3 3.133.120.202 #ping from private-vm-1 to public-vm-1, should work.
PING 3.133.120.202 (3.133.120.202) 56(84) bytes of data.
64 bytes from 3.133.120.202: icmp_seq=1 ttl=62 time=0.925 ms
64 bytes from 3.133.120.202: icmp_seq=2 ttl=62 time=0.704 ms
64 bytes from 3.133.120.202: icmp_seq=3 ttl=62 time=0.716 ms

--- 3.133.120.202 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 0.704/0.781/0.925/0.101 ms

ubuntu@ip-10-0-2-94:~$ ping -c 3 18.118.31.82 #ping from private-vm-1 to public-vm-2, should work.
PING 18.118.31.82 (18.118.31.82) 56(84) bytes of data.
64 bytes from 18.118.31.82: icmp_seq=1 ttl=62 time=1.08 ms
64 bytes from 18.118.31.82: icmp_seq=2 ttl=62 time=0.694 ms
64 bytes from 18.118.31.82: icmp_seq=3 ttl=62 time=0.674 ms

--- 18.118.31.82 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2034ms
rtt min/avg/max/mdev = 0.674/0.816/1.082/0.187 ms

ubuntu@ip-10-0-2-94:~$ ping -c 3 10.0.1.69 #ping from private-vm-1 to public-vm-1-internal, should work.
PING 10.0.1.69 (10.0.1.69) 56(84) bytes of data.
64 bytes from 10.0.1.69: icmp_seq=1 ttl=64 time=0.718 ms
64 bytes from 10.0.1.69: icmp_seq=2 ttl=64 time=0.499 ms
64 bytes from 10.0.1.69: icmp_seq=3 ttl=64 time=0.492 ms

--- 10.0.1.69 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2052ms
rtt min/avg/max/mdev = 0.492/0.569/0.718/0.104 ms
ubuntu@ip-10-0-2-94:~$ ping -c 3 10.0.1.32 #ping from private-vm-1 to public-vm-2-internal, should work.
PING 10.0.1.32 (10.0.1.32) 56(84) bytes of data.
64 bytes from 10.0.1.32: icmp_seq=1 ttl=64 time=0.816 ms
64 bytes from 10.0.1.32: icmp_seq=2 ttl=64 time=0.502 ms
64 bytes from 10.0.1.32: icmp_seq=3 ttl=64 time=0.552 ms

--- 10.0.1.32 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2027ms
rtt min/avg/max/mdev = 0.502/0.623/0.816/0.137 ms

```


```hcl
terraform destroy
```