# Three Tier Web Architecture

This project deploys a three-tier web application on AWS using Terraform. The application is a simple containerized service that is deployed in a highly available and scalable architecture.

## Architecture

The architecture consists of the following components:

*   **VPC**: A custom VPC with public, private, and database subnets distributed across multiple availability zones.
*   **Networking**: An Internet Gateway for public traffic and a NAT Gateway for private instances to access the internet.
*   **Application Load Balancers**: Public and private network load balancers to distribute traffic to the web and application tiers.
*   **Auto Scaling Groups**: Auto scaling groups for both the public (web) and private (application) tiers to ensure scalability and high availability.
*   **Launch Templates**: Launch templates define the configuration of the EC2 instances in the auto scaling groups.
*   **Database**: An Aurora PostgreSQL database for the data tier, deployed in isolated subnets.
*   **Security**: Security groups are used to control traffic between the different tiers and from the internet.

### Tiers:

*   **Web Tier (Public)**: This tier is responsible for handling incoming traffic from the internet. It consists of a public network load balancer and an auto scaling group of EC2 instances in public subnets.
*   **Application Tier (Private)**: This tier contains the core application logic. It consists of a private network load balancer and an auto scaling group of EC2 instances in private subnets.
*   **Database Tier (Private)**: This tier is responsible for data persistence. It consists of an Aurora PostgreSQL database in isolated database subnets.

## Prerequisites

*   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
*   [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
*   AWS Account with appropriate permissions

## Deployment

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/dagmar-lewis/three_tier_web_app
    cd three_tier_web_app
    ```

2.  **Configure AWS Credentials:**
    Make sure your AWS credentials are configured correctly. You can do this by setting the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables or by configuring an AWS profile.

3.  **Initialize Terraform:**
    ```bash
    cd ops/terraform/envs/prod
    terraform init
    ```

4.  **Review and Apply Terraform Plan:**
    ```bash
    terraform plan
    terraform apply
    ```

## Infrastructure Details

The infrastructure is defined in Terraform code, located in the `ops/terraform` directory. The code is organized into modules for reusability and clarity.

*   **Modules**:
    *   `vpc`: Creates the VPC, subnets, internet gateway, and NAT gateway.
    *   `auto_scaling_group`: Creates the auto scaling groups, launch templates, and load balancers.
    *   `rds`: Creates the Aurora PostgreSQL database.
*   **Environments**:
    *   `dev`: Configuration for the development environment.
    *   `prod`: Configuration for the production environment.

## Application Details

The application is a simple Docker container, `corentinth/it-tools:latest`. The launch templates for the auto scaling groups are configured to install Docker and run this container on instance launch. The application runs on port `8080`.

The `public_launch_template.sh` and `private_launch_template.sh` scripts in the `ops/scripts` directory are used as user data for the launch templates.

## Environments

The project is structured to support multiple environments (e.g., `dev`, `prod`). Each environment has its own Terraform workspace and configuration. To deploy to a different environment, navigate to the corresponding directory in `ops/terraform/envs` and run the deployment steps.