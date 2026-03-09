# Portfolio Website Infrastructure

This repository contains the **Terraform infrastructure code** used to deploy my portfolio website on AWS.  
The infrastructure is designed using a modular Terraform structure and follows infrastructure-as-code best practices.

## Architecture

The website is deployed as a **serverless architecture**:

CloudFront → S3 → Static Website  
CloudFront → API Gateway → Lambda → DynamoDB

Components:

- **S3** – Hosts the static website files.
- **CloudFront** – CDN used to deliver the website globally.
- **API Gateway** – Exposes an API endpoint used for the visitor counter.
- **Lambda** – Serverless function that updates and retrieves the visitor count.
- **DynamoDB** – Stores the page visit counter.
- **Terraform** – Manages and provisions the infrastructure.

### environments/
Contains environment-specific Terraform configurations.

- **dev** – Development infrastructure.
- **prod** – Production infrastructure.

### modules/
Reusable Terraform modules for each AWS component.

- **s3** – Static website hosting bucket.
- **cloudfront** – CDN distribution.
- **api_gateway** – API endpoint configuration.
- **lambda_tracking** – Visitor counter Lambda function.
- **dynamodb** – Database storing visit counts.

## Features

- Infrastructure defined entirely in **Terraform**
- Modular and reusable Terraform structure
- Serverless visitor counter using **Lambda + DynamoDB**
- Global content delivery with **CloudFront**
- Static website hosting with **S3**

## Notes

- Remote Terraform state is stored in **S3** with **DynamoDB state locking**.
- Environment variables and sensitive values are excluded from version control.
- Infrastructure is designed to be low-cost and suitable for personal projects.
