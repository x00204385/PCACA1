
# Connecting to an AWS Instance in a private subnet using a Bastion host

## Introduction

Proof of concept to create a VPC with some basic infrastructure:

- 2 public subnets
- 2 private subnets
- EC2 instances in each subnet (AWS Linux AMI)
- Security groups restricting access to instances (allow http, allow ssh)
- A MySQL RDS instance


<<<<<<< HEAD
```git clone https://github.com/HDaniels1991/AWS-Bastion-Host.git```

The repo requires you to have an AWS profile called: personal. It is possible to change the profile name in the variables.tf file.

The next step is to generate the SSH keys. In the terraform directory create another directory called keys and create your keys with the following command:

Trivial change to check permissions

```
# create the keys
ssh-keygen -f mykeypair
 
# add the keys to the keychain
ssh-add -K mykeypair  
```

## SSH Config File

```
Host bastion-instance
   HostName <Bastion Public IP>
   User ubuntu

Host private-instance
   HostName <Private IP>
   User ubuntu
   ProxyCommand ssh -q -W %h:%p bastion-instance
```
=======
>>>>>>> 979e853efe8295ad6e2ee0584855bde513f8690b
