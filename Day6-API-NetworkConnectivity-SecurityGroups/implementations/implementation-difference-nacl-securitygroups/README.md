```bash
#install aws cli 
sudo apt install python3-pip -y
pip3 install awscli --upgrade --user

#To configure first create credentials for test_user(create test_user also) from IAM.
#Then use Access key and Secret access key for configration aws cli.
#configure aws cli.
aws configure

#create state s3
aws s3 mb s3://terraform-state-day2-sf48er9gytr


#ssh for vm, log init script
sudo tail -f /var/log/cloud-init-output.log # follow log
sudo cat /var/log/cloud-init-output.log # all log

#access app from htpp://vm-external-ip:8501
#save data with adding new entries
#check bucket for versions
```

deploy infra:
```hcl
terraform init
terraform plan
terraform graph | dot -Tpng > graph.png
terraform apply


```

test:
```bash
#ssh try ping google from 3 ec2s, sg and nacl_allow can ping but not nacl_deny 
ping -c 3 google.com

```

result
```bash
#sg can ping
ubuntu@ip-10-0-1-135:~$ ping -c 3 google.com
PING google.com (142.250.191.142) 56(84) bytes of data.
64 bytes from ord38s29-in-f14.1e100.net (142.250.191.142): icmp_seq=1 ttl=115 time=8.80 ms
64 bytes from ord38s29-in-f14.1e100.net (142.250.191.142): icmp_seq=2 ttl=115 time=8.88 ms
64 bytes from ord38s29-in-f14.1e100.net (142.250.191.142): icmp_seq=3 ttl=115 time=8.84 ms

--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 8.796/8.839/8.883/0.035 ms

#nacl_allow can ping
ubuntu@ip-10-0-2-131:~$ ping -c 3 google.com
PING google.com (142.250.191.174) 56(84) bytes of data.
64 bytes from ord38s30-in-f14.1e100.net (142.250.191.174): icmp_seq=1 ttl=113 time=8.04 ms
64 bytes from ord38s30-in-f14.1e100.net (142.250.191.174): icmp_seq=2 ttl=113 time=7.99 ms
64 bytes from ord38s30-in-f14.1e100.net (142.250.191.174): icmp_seq=3 ttl=113 time=8.01 ms

--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 7.991/8.014/8.042/0.021 ms

#nacl_deny cant ping
ubuntu@ip-10-0-3-227:~$ ping -c 3 google.com
PING google.com (142.250.190.14) 56(84) bytes of data.

--- google.com ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2048ms


```





destroy infra:
```hcl
terraform destroy
```