# Resume Challenge

A fully serverless resume website deployed on AWS, featuring a static frontend and a dynamic backend, all managed with Infrastructure as Code.

## Features

- **Frontend:** Static website built with React, hosted on S3, and delivered via CloudFront.
- **Backend:** AWS Lambda function behind API Gateway for dynamic features (e.g., user count).
- **Infrastructure as Code:** All AWS resources provisioned and managed using Terraform.
- **CI/CD:** Automated deployment pipelines using GitHub Actions.
- **Security:** Fine-grained IAM roles and policies, HTTPS via ACM, and DNS managed with Route 53.
- **Scalable & Cost-Effective:** Serverless architecture with pay-as-you-go AWS services.

## Architecture

- **S3:** Hosts the static frontend.
- **CloudFront:** Distributes the website globally with low latency.
- **API Gateway:** Exposes RESTful endpoints for dynamic features.
- **Lambda:** Handles backend logic (e.g., user count).
- **DynamoDB:** Stores persistent data.
- **Route 53 & ACM:** DNS management and SSL certificates.
- **Terraform:** Manages all AWS resources.
- **GitHub Actions:** CI/CD for infrastructure and application code.

---
**Link [yurii-k.xyz](https://www.yurii-k.xyz/)**
**Project by [Yurii Kycha Kolot](https://github.com/ykycha-kolot)**

```mermaid
flowchart TD
 subgraph subGraph0["GitHub Actions Workflows"]
        WF1["frontend.yml"]
        WF2["backend.yml"]
        WF3["infrastructure.yml"]
  end
    UA["User Browser"] -. DNS lookup .-> R53["Route53"]
    R53 -- returns domain --> UA
    UA -- HTTPS --> CF["CloudFront CDN"]
    CF -- Static assets --> S3["S3 Bucket"]
    CF -- API requests --> APIGW["API Gateway"]
    APIGW -- invokes --> LAMBDA["Lambda Function"]
    LAMBDA -- reads/writes --> DDB["DynamoDB"]
    R53 -- domain validation --> ACM["ACM"]
    WF1 -- Deploy static site --> S3
    WF2 -- Deploy Lambda code --> LAMBDA
    WF3 --> S3 & CF & APIGW & LAMBDA & DDB & R53 & ACM
```