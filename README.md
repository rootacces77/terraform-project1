# terraform-project1
Diagram of the project is located at diagram/*.Different types of files can be found there .png .pdf .vsdx.

It is a basic web/database project with extra services,security and network isolation.Github is used as OIDC,terraform as IaC and Ansible for configuring EC2 instances.Project is multiaccount project(Management,Network,Security,Prod).

Clients connect using web browser and domain name registered in account.Connection goes through CloudFront which has two origins ALB and S3 (for static files).CloudFront is protected using WAF and Shield.CF connection with ALB is secured with header secret.Project uses Firewall Manager,AWS Config,Cloud Trail and Security Hub which is managed through Security account.Network account is used to deploy VPC's and share them using RAM.Network account is also responsible for routes,connection between VPC's and Route53.Everythin else is deployed within Prod account.

EC2 Image Builder for Web Image is moved to Stage2 since building two images at same time has chance to cause error (Same package manager and installing multiple things).

![Alt text](diagram/project1.png)