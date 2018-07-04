# Terraform templates for Event Gateway

The current setup is not intended for production use, as it lacks some security and resilience features.

## Running the scripts

First, create a state bucket and provide its name in the `backend.tf` file.

Then run:

```
terraform init 
terraform apply
```

## Resources created

* VPC, 2 public subnet with Internet Gateway, 3 private subnets with routing tables and security groups
* NAT Gateway with Elastic IP
* 2 Application Load Balancers (config & events APIs) with listeners and target groups
* ECS cluster with 2 services and Fargate tasks
* 3 EC2 instances (t2.micro) for hosting etcd cluster

## Etcd

Etcd v3.3 nodes are running on CoreOS system, each on a separate EC2 instance.
For discovery mechanism, DNS SRV records are used, as described here: https://coreos.com/etcd/docs/latest/v2/clustering.html#discovery

## Configuration

All parameters are included in the `terraform/variables.tf` file.