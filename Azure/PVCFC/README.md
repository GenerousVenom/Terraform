# Basic Azure Landing Zone by Terraform

This is a simple landing zone designed by Terraform. After this project, you can learn:
- The advanced concepts of Azure: Azure Bastion, Endpoint, Key Vault, ... 
- Terraform basic commands: init, plan, apply, destroy
- How to use Terraform to build Azure resource
- How to organize Terraform configuration files

## 1. Landing Zone Architecture
In this project, we have 3 different resource groups in a subscription
- RSG 1: sg-sea-rsg-dmgmt-01 - This is a management landing zone
- RSG 2: sg-sea-rsg-pro-01 - This is a production landing zone
- RSG 3: sg-sea-rsg-nonrsg-01 - This is a non-production landing zone

All resource will be allocated in Southeast Asia

![plot](./Architecture%20SVTECH%20v1.1.png)

## 2. Naming Convention
xx-yyy-zzzz-tttttt-vv (e.g: sg-sea-rsg-dmgmt-01)
- xx = Location (sg: Singapore)
- yyy = Region (sea: Southeast Asia)
- zzzz = Resource Type (rsg: Resource Group)
- tttttt = Environment (dmgmt: Production)
- vv = Instance Number (01...)

## 3. Methods
There are 2 approaches, each of them has their pros and cons, you need to carefully consider basing on certain situations. 
- Method 1: Easy to manage, more files -> Difficult for the beginning
- Method 2: Easy to write, less files -> Difficult to track and cooperate, no inheritance