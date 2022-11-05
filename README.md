
# Connecting to an AWS Instance in a private subnet using a Bastion host

## Introduction

Proof of concept to create a VPC with some basic infrastructure:

- 2 public subnets
- 2 private subnets
- EC2 instances in each subnet (AWS Linux AMI)
- Security groups restricting access to instances (allow http, allow ssh)
- A MySQL RDS instance


