# ByteBrain AKS

A full-stack, cloud-native application deployed on **Azure Kubernetes Service (AKS)**. ByteBrain is a modern application featuring a Node.js/Express backend API with MongoDB database integration and a React frontend with Vite, all containerized and orchestrated through Kubernetes.

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Local Development Setup](#local-development-setup)
- [Building & Running](#building--running)
- [Deployment](#deployment)
- [Infrastructure as Code](#infrastructure-as-code)
  - [Infrastructure Architecture](#infrastructure-architecture)
  - [Infrastructure Directory Structure](#infrastructure-directory-structure)
  - [Infrastructure Prerequisites](#infrastructure-prerequisites)
  - [Infrastructure Configuration](#infrastructure-configuration)
  - [Infrastructure Deployment](#infrastructure-deployment)
  - [Terraform State Management](#terraform-state-management)
  - [Module Documentation](#module-documentation)
  - [Infrastructure Outputs](#infrastructure-outputs)
  - [Best Practices](#best-practices)
  - [Infrastructure Troubleshooting](#infrastructure-troubleshooting)
- [Technology Stack](#technology-stack)
- [Environment Configuration](#environment-configuration)
- [API Documentation](#api-documentation)
- [Development Workflow](#development-workflow)
- [Troubleshooting](#troubleshooting)
- [Security Considerations](#security-considerations)
- [Performance Optimization](#performance-optimization)
- [Contributing](#contributing)

## Project Overview

ByteBrain AKS is a scalable, cloud-native application deployed on Azure with the following architecture:

- **Frontend**: React application with Vite, hosted on **Azure Static Web Apps**
- **Backend**: Node.js/Express API running on **Azure Kubernetes Service (AKS)**
- **Database**: MongoDB Atlas (external cloud-hosted MongoDB)
- **Infrastructure**: Azure cloud resources managed by Terraform
- **Secrets**: Azure Key Vault for centralized configuration management
- **Local Development**: Docker Compose for easy backend testing

### Key Features

- Full-stack TypeScript development
- Container-based deployment
- Kubernetes-native configuration
- Azure resource management via Terraform
- JWT authentication & bcrypt password hashing
- CORS-enabled API
- Environment-based configuration using Azure Key Vault
- Azure Managed Identity for secure service authentication

## Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                       ByteBrain Architecture                      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Internet Users                                                  │
│       │                                                          │
│       ├──────────────────┬──────────────────────┐                │
│       │                  │                      │                │
│       ▼                  ▼                      ▼                │
│  ┌─────────────┐  ┌──────────────┐     ┌──────────────────┐    │
│  │   Frontend  │  │   API Docs   │     │  Backend API     │    │
│  │   Web App   │  │  (Optional)  │     │   (REST/GraphQL) │    │
│  └─────────────┘  └──────────────┘     └────────┬─────────┘    │
│  (Azure Static         (Optional)               │               │
│   Web Apps)                         ┌───────────┼───────────┐   │
│                                     │           │           │   │
│                    ┌────────────────▼────────┐  │           │   │
│                    │  Azure Container        │  │           │   │
│                    │  Registry (ACR)         │  │           │   │
│                    │  - bytebrain-backend    │  │           │   │
│                    └────────────────────────┘  │           │   │
│                                                │           │   │
│       ┌────────────────────────────────────────┼───────────┘   │
│       │                                        │                │
│       ▼                                        ▼                │
│  ┌─────────────────────────────────┐  ┌──────────────────┐    │
│  │   Azure Kubernetes Service      │  │  Azure Key Vault │    │
│  │   (AKS Cluster)                 │  │  Secrets:        │    │
│  │                                 │  │  - DB connection │    │
│  │  ┌───────────────────────────┐  │  │  - JWT secret    │    │
│  │  │  Backend Pod (Express)    │  │  │  - API keys      │    │
│  │  │  - App server             │  │  └──────────────────┘    │
│  │  │  - Business logic         │  │                          │
│  │  │  - REST API endpoints     │  │                          │
│  │  └───────────────────────────┘  │                          │
│  │                                 │                          │
│  │  ┌───────────────────────────┐  │                          │
│  │  │  Service / Ingress        │  │                          │
│  │  │  - Load Balancer          │  │                          │
│  │  │  - API Gateway            │  │                          │
│  │  └───────────────────────────┘  │                          │
│  │                                 │                          │
│  │  ┌───────────────────────────┐  │                          │
│  │  │  Managed Identity         │  │                          │
│  │  │  - ACR pull permissions   │  │                          │
│  │  │  - Key Vault access       │  │                          │
│  │  │  - MongoDB Atlas access   │  │                          │
│  │  └───────────────────────────┘  │                          │
│  └─────────────────────────────────┘                          │
│                                                               │
└───────────────────────────────────────────────────────────────┘
         │
         └──────────────────┬──────────────────┐
                            │                  │
                            ▼                  ▼
                     ┌──────────────┐   ┌──────────────┐
                     │ MongoDB      │   │ Azure CosmosDB
                     │ Atlas        │   │ (optional alt)
                     │ (External)   │   └──────────────┘
                     └──────────────┘
```

## Project Structure

```
ByteBrainAKS/
├── backend/                    # Node.js Express API
│   ├── src/
│   │   ├── config.ts          # Configuration management
│   │   ├── index.ts           # Application entry point
│   │   ├── db/                # Database models & connections
│   │   ├── middlewares/       # Express middleware (auth, cors, etc.)
│   │   ├── routes/            # API route definitions
│   │   └── validators/        # Input validation schemas
│   ├── Dockerfile             # Backend container image definition
│   ├── package.json           # Node.js dependencies & scripts
│   ├── tsconfig.json          # TypeScript configuration
│   └── ecosystem.config.js    # PM2 configuration for production
│
├── frontend/                   # React + Vite SPA
│   ├── src/
│   │   ├── App.tsx            # Root React component
│   │   ├── main.tsx           # Application entry point
│   │   ├── index.css          # Global styles & Tailwind
│   │   ├── Components/        # Reusable React components
│   │   ├── Pages/             # Page components (routes)
│   │   ├── Routes/            # Route definitions
│   │   ├── hooks/             # Custom React hooks
│   │   ├── lib/               # Utility functions & helpers
│   │   └── Icons/             # Icon components
│   ├── Dockerfile             # Frontend container image definition
│   ├── package.json           # NPM dependencies & scripts
│   ├── vite.config.ts         # Vite build configuration
│   ├── tsconfig.json          # TypeScript configuration
│   ├── nginx.conf             # Nginx server configuration
│   └── assets/                # Static images & assets
│
├── infra/                      # Infrastructure as Code (Terraform)
│   ├── main.tf                # Main infrastructure configuration
│   ├── providers.tf           # Terraform provider configuration (Azure)
│   ├── variables.tf           # Input variable definitions
│   ├── outputs.tf             # Output definitions
│   ├── terraform.tfvars       # Variable values
│   ├── backend.tf             # Remote state backend configuration
│   └── modules/               # Reusable Terraform modules
│       ├── resource-group/    # Azure Resource Group
│       ├── acr/               # Azure Container Registry
│       ├── aks/               # Azure Kubernetes Service cluster
│       ├── key-vault/         # Azure Key Vault for secrets
│       ├── container-app/     # Container App (optional)
│       ├── vnet/              # Virtual Network
│       ├── subnet/            # Virtual Network Subnet
│       └── [other modules]/   # Additional infrastructure modules
│
├── helm-chart/                 # Kubernetes Helm Charts
│   ├── Chart.yaml             # Helm chart metadata
│   ├── values.yaml            # Default Helm values
│   └── templates/
│       ├── deployment.yaml    # Kubernetes Deployment
│       ├── service.yaml       # Kubernetes Service
│       ├── ingress.yaml       # Ingress Controller config
│       ├── hpa.yaml           # Horizontal Pod Autoscaler
│       ├── poddisruptionbudget.yaml  # Pod Disruption Budget
│       ├── serviceaccount.yaml # Service Account
│       └── _helpers.tpl       # Helm template helpers
│
├── manifests/                  # Kubernetes manifests (alternative to Helm)
│   ├── deployment.yaml        # Kubernetes Deployment
│   ├── service.yaml           # Kubernetes Service
│   ├── kustomization.yaml     # Kustomize configuration
│   └── secretproviderclass.yaml # Azure Key Vault integration
│
├── docker-compose.yml          # Docker Compose for local development
└── README.md                   # This file
```

## Prerequisites

### For Local Development

- **Docker & Docker Compose** - v20.10+
  - [Install Docker Desktop](https://www.docker.com/products/docker-desktop)

- **Node.js & NPM** - v20+ (optional, for direct development without containers)
  - [Install Node.js](https://nodejs.org/)

### For Production Deployment

- **Azure Account** with active subscription
- **Terraform** - v1.9.0+
  - [Install Terraform](https://www.terraform.io/downloads.html)

- **kubectl** - v1.26+
  - [Install kubectl](https://kubernetes.io/docs/tasks/tools/)

- **Helm** - v3.10+
  - [Install Helm](https://helm.sh/docs/intro/install/)

- **Azure CLI** - latest version
  - [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

## Local Development Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd ByteBrainAKS
```

### 2. Setup Environment Variables

Create `.env` file in the backend directory:

```bash
cp backend/.env.example backend/.env
```

Update backend `.env` with your configuration:

```env
PORT=3000
NODE_ENV=development
# Use MongoDB Atlas for development (or local MongoDB if running locally)
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/bytebrain
# For local MongoDB: mongodb://localhost:27017/bytebrain
JWT_SECRET=your-jwt-secret-key-dev
CORS_ORIGIN=http://localhost:5173
```

### 3. Start Local Development Environment

**Option A: Using Docker Compose (Backend + Local MongoDB)**

Create a `docker-compose.override.yml` if you want to include MongoDB for testing:

```bash
docker-compose up -d
```

This will start:

- **MongoDB** - Port 27017 (if included in docker-compose.yml)
- **Backend API** - Port 3000

**Option B: Using MongoDB Atlas (Recommended)**

Simply run the backend container:

```bash
cd backend
npm install
npm run dev
```

This connects to your MongoDB Atlas cluster specified in `.env`.

### 4. Verify Services

```bash
# Check running containers
docker-compose ps

# View backend logs
docker-compose logs -f backend

# Test API health
curl http://localhost:3000/health
```

## Building & Running

### Backend Development

```bash
cd backend

# Install dependencies
npm install

# TypeScript build
npm run build

# Development with auto-reload
npm run dev

# Production start
npm start

# PM2 process manager (production)
npm run start:pm2
npm run stop:pm2
```

### Frontend Development

```bash
cd frontend

# Install dependencies
npm install

# Development server with hot reload
npm run dev

# Production build
npm run build

# Preview production build
npm run preview

# Lint code
npm run lint
```

### Running Locally Without Docker Compose

**Terminal 1 - Backend:**

```bash
cd backend
npm install
npm run dev
```

**Terminal 2 - Frontend (in separate terminal):**

```bash
cd frontend
npm install
npm run dev
```

Access the application:

- Frontend: http://localhost:5173
- Backend API: http://localhost:3000
- API Health: http://localhost:3000/health

**Note:** Backend connects to MongoDB Atlas using the MONGODB_URI from `.env`

## Deployment

### Backend Deployment

#### Option 1: Docker (Standalone Containers)

Build container images:

```bash
# Backend only
docker build -t bytebrain-backend:latest ./backend
```

Run containers:

```bash
docker run -d -p 3000:3000 \
  --env-file backend/.env \
  bytebrain-backend:latest
```

#### Option 2: Kubernetes with Helm (Recommended for Production)

```bash
# Add Helm repository (if using a chart registry)
helm repo add bytebrain <chart-repo-url>
helm repo update

# Install the chart (backend only)
helm install bytebrain helm-chart/ -n bytebrain --create-namespace

# Upgrade after changes
helm upgrade bytebrain helm-chart/ -n bytebrain

# View deployment status
kubectl get pods -n bytebrain
kubectl logs -f deployment/backend -n bytebrain
```

#### Option 3: Kubernetes with Manifests (Kustomize)

```bash
# Deploy using kustomize (backend only)
kubectl apply -k manifests/

# Check deployment status
kubectl get all

# View logs
kubectl logs -f deployment/backend
```

### Frontend Deployment

Deploy the frontend to **Azure Static Web Apps**:

```bash
# Install Azure CLI (if not already installed)
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Login to Azure
az login

# Create Static Web App (if not already created)
az staticwebapp create \
  --name bytebrain-frontend \
  --resource-group bytebrain-rg \
  --source https://github.com/your-org/ByteBrainAKS \
  --location eastus \
  --branch main \
  --build-folder frontend \
  --app-location frontend

# Deploy the frontend
az staticwebapp update \
  --name bytebrain-frontend \
  --resource-group bytebrain-rg \
  --source https://github.com/your-org/ByteBrainAKS
```

Or manually deploy:

```bash
# Build frontend
cd frontend
npm install
npm run build

# Deploy built files to Azure Static Web Apps
az staticwebapp deploy \
  --name bytebrain-frontend \
  --source-location ./dist
```

### Database Deployment

MongoDB is hosted on **MongoDB Atlas** (external service):

```bash
# No Azure deployment needed for database
# Create connection string from MongoDB Atlas dashboard:
# mongodb+srv://<username>:<password>@<cluster>.mongodb.net/bytebrain

# Store connection string in Azure Key Vault
az keyvault secret set \
  --vault-name bytebrain-kv \
  --name mongodb-atlas-uri \
  --value "mongodb+srv://<username>:<password>@<cluster>.mongodb.net/bytebrain"

# Backend will retrieve this from Key Vault at runtime
```

## Infrastructure as Code

The infrastructure is managed through **Terraform** and deployed to **Microsoft Azure** using Infrastructure-as-Code (IaC). This provides a production-ready, scalable, and secure environment for hosting the ByteBrain application on Azure Kubernetes Service (AKS).

### Infrastructure Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      Azure Subscription                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │          Resource Group (bytebrain-rg)                   │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │                                                          │   │
│  │  ┌──────────────────────────────────────────────────┐   │   │
│  │  │         Virtual Network (10.0.0.0/16)            │   │   │
│  │  ├──────────────────────────────────────────────────┤   │   │
│  │  │                                                  │   │   │
│  │  │  ┌─────────────────────────────────────────┐    │   │   │
│  │  │  │  AKS Cluster (Kubernetes)               │    │   │   │
│  │  │  ├─────────────────────────────────────────┤    │   │   │
│  │  │  │                                         │    │   │   │
│  │  │  │  ┌──────────────────────────────┐       │    │   │   │
│  │  │  │  │ Backend Pod (Express)        │       │    │   │   │
│  │  │  │  │ - REST API                   │       │    │   │   │
│  │  │  │  │ - Business Logic             │       │    │   │   │
│  │  │  │  └──────────────────────────────┘       │    │   │   │
│  │  │  │                                         │    │   │   │
│  │  │  │  ┌──────────────────────────────┐       │    │   │   │
│  │  │  │  │ Service / Ingress Controller │       │    │   │   │
│  │  │  │  │ - Load Balancer              │       │    │   │   │
│  │  │  │  │ - Public IP                  │       │    │   │   │
│  │  │  │  └──────────────────────────────┘       │    │   │   │
│  │  │  └────────────────┬──────────────────────┘    │   │   │
│  │  │                   │                          │   │   │
│  │  └───────────────────┼──────────────────────────┘   │   │
│  │                      │                              │   │
│  │  ┌──────────────────▼──────────────────┐            │   │
│  │  │   Azure Container Registry (ACR)    │            │   │
│  │  │   - bytebrain-backend:latest        │            │   │
│  │  └─────────────────────────────────────┘            │   │
│  │                                                    │   │
│  │  ┌─────────────────────────────────────────────┐   │   │
│  │  │       Azure Key Vault                       │   │   │
│  │  │   Secrets:                                  │   │   │
│  │  │   - mongodb-atlas-uri                      │   │   │
│  │  │   - bytebrain-jwt-secret                   │   │   │
│  │  │   - API keys                               │   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  │                                                    │   │
│  │  ┌─────────────────────────────────────────────┐   │   │
│  │  │  User-Assigned Managed Identity             │   │   │
│  │  │  - Permissions: ACR pull, Key Vault access │   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  │                                                    │   │
│  └────────────────────────────────────────────────────┘   │
│                                                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │   Azure Static Web Apps                             │   │
│  │   - Frontend (React/Vite)                           │   │
│  │   - Custom domain                                   │   │
│  │   - SSL/TLS certificate                             │   │
│  │   - Built-in CI/CD                                  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
└────────────────────────────────────────────────────────────┘
         │
         └────────────────────────────────────┐
                                              │
                                    ┌─────────▼──────────┐
                                    │  MongoDB Atlas     │
                                    │  (External)        │
                                    │  - Database        │
                                    │  - Collections     │
                                    │  - Backups         │
                                    └────────────────────┘
```

#### Core Infrastructure Components

1. **Azure Kubernetes Service (AKS)** - Managed Kubernetes cluster running backend services
2. **Azure Container Registry (ACR)** - Private container image registry for backend images
3. **Azure Key Vault** - Centralized secrets and configuration management
4. **MongoDB Atlas** - External MongoDB database (non-Azure, hosted by MongoDB Inc.)
5. **Azure Virtual Network (VNet)** - Network isolation and security
6. **User-Assigned Managed Identity** - Secure pod authentication and authorization
7. **Azure Static Web Apps** - Serverless frontend hosting with built-in CI/CD
8. **Resource Group** - Logical container for all Azure resources

#### Additional Components

- **Azure Bastion** - Secure remote access to jump VMs (optional)
- **NAT Gateway** - Outbound internet connectivity for pods
- **Log Analytics** - Monitoring and diagnostics
- **Container Apps Environment** - Alternative serverless deployment option (optional)

### Infrastructure Directory Structure

```
infra/
├── main.tf                         # Main Terraform configuration (ACTIVE)
├── providers.tf                    # Azure provider configuration
├── variables.tf                    # Variable definitions
├── outputs.tf                      # Output value definitions
├── backend.tf                      # Remote state backend configuration
├── terraform.tfvars                # Variable values (sensitive data)
├── terraform.tfstate              # Local state file (DO NOT commit)
├── terraform.tfstate.backup       # State backup
├── .terraform/                     # Terraform working directory
│   └── modules/                    # Downloaded/cached modules
├── .tfvars.example                 # Example variable values template
│
└── modules/                        # Reusable Terraform modules
    │
    ├── resource-group/             # Azure Resource Group management
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── acr/                        # Azure Container Registry
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── aks/                        # Azure Kubernetes Service
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── key-vault/                  # Azure Key Vault
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── key-vault-secret/           # Key Vault Secrets
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── user-assigned-identity/     # Managed Identity
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── vnet/                       # Virtual Network
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── subnet/                     # Virtual Network Subnet
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── container-apps-environment/ # Container Apps Environment
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── container-app/              # Container App
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── container-instance/         # Container Instance
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── nat-gateway/                # NAT Gateway
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── azure-bastion/              # Azure Bastion
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── jump-vm-aks/                # Jump VM
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    ├── log-analytics/              # Log Analytics
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    │
    └── static-web-app/             # Static Web App
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── README.md
```

### Infrastructure Prerequisites

#### 1. Azure Account Setup

```bash
# Install Azure CLI
# Linux/macOS:
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Windows: Download installer from https://aka.ms/azure-cli

# Login to Azure
az login

# Set active subscription
az account set --subscription "your-subscription-id"

# Verify subscription
az account show
```

#### 2. Terraform Installation

```bash
# Install Terraform v1.9.0 or higher
# macOS (using Homebrew)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Linux (using apt)
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Windows (using Chocolatey)
choco install terraform

# Verify installation
terraform --version  # Should be v1.9.0 or higher
```

#### 3. Additional Tools

```bash
# kubectl - Kubernetes CLI
# macOS
brew install kubectl

# Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify
kubectl version --client

# Helm - Kubernetes package manager
# macOS
brew install helm

# Linux
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify
helm version
```

### Infrastructure Configuration

#### 1. Initialize Terraform

```bash
# Navigate to infra directory
cd infra

# Initialize Terraform (downloads provider plugins and modules)
terraform init

# If using remote state backend
terraform init -backend-config="key=bytebrain.tfstate" \
  -backend-config="container_name=tfstate" \
  -backend-config="storage_account_name=your_storage_account"
```

#### 2. Create Variable Files

Create `terraform.tfvars` from the template:

```bash
cp .tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your Azure configuration:

```hcl
subscription_id = "00000000-0000-0000-0000-000000000000"

# Resource group configuration
resource_group_name = "bytebrain-rg"
location            = "eastus"

# Container Registry
acr_name = "bytebrainacr"  # Must be globally unique, alphanumeric only

# Key Vault
key_vault_name = "bytebrain-kv"

# Secrets (stored in Key Vault)
# MongoDB Atlas connection string (not Azure Cosmos DB)
mongodb_atlas_uri = "mongodb+srv://<username>:<password>@<cluster>.mongodb.net/bytebrain"
jwt_secret        = "your-jwt-secret-key"

# Backend container configuration
backend_image_name      = "bytebrain-backend"
backend_image_tag       = "latest"
backend_cpu             = 1
backend_memory          = 2
backend_dns_name_label  = "bytebrain-backend"

# Managed Identity
user_assigned_identity_name = "bytebrain-identity"

# AKS Configuration
aks_cluster_name       = "bytebrain-aks"
aks_node_count         = 3
aks_vm_size            = "Standard_B2s"
aks_disk_size_gb       = 30

# Virtual Network
vnet_name   = "bytebrain-vnet"
subnet_name = "bytebrain-subnet"

# Azure Static Web Apps (Frontend)
static_web_app_name = "bytebrain-frontend"
github_repo_url     = "https://github.com/your-org/ByteBrainAKS"
github_branch       = "main"
```

#### 3. Sensitive Data Management

**IMPORTANT**: Never commit `terraform.tfvars` to version control. Use Azure Key Vault for sensitive variables:

```bash
# Store MongoDB Atlas connection string in Key Vault
az keyvault secret set --vault-name bytebrain-kv \
  --name mongodb-atlas-uri \
  --value "mongodb+srv://<username>:<password>@<cluster>.mongodb.net/bytebrain"

# Store JWT secret in Key Vault
az keyvault secret set --vault-name bytebrain-kv \
  --name jwt-secret \
  --value "your-jwt-secret-key"

# Reference in Terraform
data "azurerm_key_vault_secret" "mongodb_atlas_uri" {
  name         = "mongodb-atlas-uri"
  key_vault_id = azurerm_key_vault.main.id
}
```

### Infrastructure Deployment

#### 1. Plan Deployment

Review the infrastructure changes before applying:

```bash
cd infra

# Plan and save output to file
terraform plan -out=tfplan

# View detailed plan (if needed)
terraform show tfplan | less
```

#### 2. Apply Infrastructure

```bash
# Apply the saved plan
terraform apply tfplan

# Or apply directly (will prompt for confirmation)
terraform apply

# View outputs
terraform output
```

#### 3. Configure kubectl Access

```bash
# Get AKS credentials
az aks get-credentials \
  --resource-group bytebrain-rg \
  --name bytebrain-aks \
  --overwrite-existing

# Verify cluster access
kubectl get nodes
kubectl get namespaces

# Create bytebrain namespace (if not auto-created)
kubectl create namespace bytebrain
```

#### 4. Deploy Application to AKS

```bash
# Login to ACR
az acr login --name bytebrainacr

# Build and push backend image
docker build -t bytebrainacr.azurecr.io/bytebrain-backend:latest ./backend
docker push bytebrainacr.azurecr.io/bytebrain-backend:latest

# Deploy backend using Helm
helm install bytebrain ../helm-chart/ -n bytebrain \
  --set backend.image.repository=bytebrainacr.azurecr.io/bytebrain-backend

# Verify deployment
kubectl get pods -n bytebrain
kubectl logs -f deployment/backend -n bytebrain
```

#### 5. Deploy Frontend to Azure Static Web Apps

```bash
# Create Static Web App
az staticwebapp create \
  --name bytebrain-frontend \
  --resource-group bytebrain-rg \
  --source https://github.com/your-org/ByteBrainAKS \
  --location eastus \
  --branch main \
  --build-folder frontend \
  --app-location frontend \
  --api-location api  # Optional: if you have serverless functions

# Alternatively, deploy built files manually
cd frontend
npm run build
az staticwebapp deploy \
  --name bytebrain-frontend \
  --source-location ./dist
```

### Terraform State Management

#### Local State (Development)

```bash
# State files are stored locally in infra/
# Ensure .gitignore includes:
# - terraform.tfstate
# - terraform.tfstate.backup
# - .terraform/
# - .tfvars (if containing secrets)

# Check state status
terraform show

# List resources in state
terraform state list

# Inspect specific resource
terraform state show module.bytebrain_rg.azurerm_resource_group.main
```

#### Remote State (Production)

Configure remote state in `backend.tf`:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "bytebrain.tfstate"
  }
}
```

### Module Documentation

#### Key Modules Overview

**Resource Group Module** - Creates and manages Azure Resource Group container.

```bash
# Variables: name, location, tags
# Outputs: id, name, location
```

**AKS Module** - Deploys production-ready AKS cluster with monitoring.

```bash
# Variables: cluster_name, resource_group_name, location, node_count, vm_size, node_labels, network_plugin
# Outputs: kube_config, kube_config_raw, client_certificate, cluster_ca_certificate
```

**ACR Module** - Creates private Azure Container Registry.

```bash
# Variables: name, resource_group_name, location, sku
# Outputs: id, name, login_server, admin_username, admin_password
```

**Key Vault Module** - Manages secure secret storage.

```bash
# Variables: name, resource_group_name, location, sku_name
# Outputs: id, uri, name
```

**User-Assigned Identity Module** - Creates managed identity with RBAC roles.

```bash
# Variables: name, resource_group_name, location
# Outputs: id, principal_id, client_id, tenant_id
```

### Infrastructure Outputs

After successful deployment, access outputs:

```bash
# View all outputs
terraform output

# View specific output
terraform output -raw kube_config > kubeconfig.yaml

# Export for use in scripts
export ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
export KEY_VAULT_URI=$(terraform output -raw key_vault_uri)
export AKS_CLUSTER_NAME=$(terraform output -raw aks_cluster_name)
```

#### Important Outputs

| Output               | Description          | Usage                |
| -------------------- | -------------------- | -------------------- |
| `resource_group_id`  | Resource Group ID    | Reference in scripts |
| `acr_login_server`   | ACR Registry URL     | Docker push/pull     |
| `aks_kube_config`    | Kubernetes config    | kubectl access       |
| `aks_cluster_name`   | AKS cluster name     | Cluster management   |
| `key_vault_uri`      | Key Vault URI        | Secrets access       |
| `key_vault_name`     | Key Vault name       | Azure CLI commands   |
| `backend_service_ip` | Backend API IP/FQDN  | Application access   |
| `static_web_app_url` | Frontend website URL | Browser access       |

### Best Practices

#### 1. State Management

- ✅ Use remote state backend for team environments
- ✅ Enable state locking to prevent concurrent modifications
- ✅ Regular state backups
- ❌ Never commit tfstate files to version control

#### 2. Variable Management

- ✅ Use `.tfvars` files for environment-specific values
- ✅ Store sensitive data in Azure Key Vault
- ✅ Use variable validation
- ❌ Never hardcode secrets

#### 3. Module Usage

- ✅ Use modules for reusable infrastructure patterns
- ✅ Version modules consistently
- ✅ Document module inputs/outputs
- ✅ Test modules independently

#### 4. Naming Conventions

- ✅ Use consistent naming patterns across resources
- ✅ Include environment indicators (dev, staging, prod)
- ✅ Use resource abbreviations (rg, acr, aks, kv)
- Example: `bytebrain-prod-rg`, `bytebrain-prod-aks`

#### 5. Resource Tagging

```hcl
local.bytebrain_tags = {
  Project     = "Bytebrain_AKS"
  Environment = var.environment
  ManagedBy   = "Terraform"
  CreatedDate = timestamp()
}
```

#### 6. RBAC and Security

- ✅ Use Managed Identity for Azure service authentication
- ✅ Apply least-privilege RBAC roles
- ✅ Enable Azure Key Vault access policies
- ✅ Use Network Policies in AKS for traffic control

#### 7. Cost Optimization

- ✅ Right-size VM instances (Standard_B2s is cost-effective)
- ✅ Use Spot VMs for non-critical workloads
- ✅ Enable cluster autoscaling
- ✅ Monitor and review Azure costs regularly

### Infrastructure Troubleshooting

#### Common Issues

**Authentication Errors**

```bash
# Verify Azure login
az account show

# Re-login if needed
az login

# Clear cached credentials (if locked out)
az cache purge
```

**Terraform Init Failures**

```bash
# Reinitialize Terraform
rm -rf .terraform
terraform init

# Specify provider version explicitly if needed
terraform init -upgrade
```

**ACR Name Already Taken**

```bash
# ACR names must be globally unique
# Modify in terraform.tfvars and try again
# Names must contain only alphanumeric characters
```

**AKS Cluster Creation Timeout**

```bash
# Check Azure subscription limits
az vm list-usage --location eastus

# Consider reducing node_count or using smaller vm_size
# Monitor deployment in Azure Portal
```

**Key Vault Access Denied**

```bash
# Verify managed identity has correct RBAC role
az role assignment list --assignee <principal-id>

# Add missing role assignment
az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee <principal-id> \
  --scope <key-vault-id>
```

**kubectl Context Issues**

```bash
# Verify current context
kubectl config current-context

# Get fresh credentials
az aks get-credentials \
  --resource-group bytebrain-rg \
  --name bytebrain-aks \
  --overwrite-existing

# List all contexts
kubectl config get-contexts

# Switch context if needed
kubectl config use-context <context-name>
```

#### Debugging Commands

```bash
# Enable Terraform debug logging
export TF_LOG=DEBUG
terraform plan

# View Terraform provider logs
export TF_LOG_PATH=./terraform.log

# Check resource existence in Azure
az resource list --resource-group bytebrain-rg

# Validate Terraform syntax
terraform validate

# Format Terraform files
terraform fmt -recursive

# Check for security issues
tfsec .

# Cost estimation
terraform plan -json | jq '.resource_changes[] | select(.type=="azurerm_*")'
```

#### Cleanup

To destroy all infrastructure and avoid unnecessary costs:

```bash
# Plan destruction (review what will be deleted)
terraform plan -destroy

# Execute destruction
terraform destroy

# Force destruction (use with caution)
terraform destroy -auto-approve
```

#### Advanced Infrastructure Topics

**Scaling AKS Cluster**

```bash
# Manual scaling
az aks scale -g bytebrain-rg -n bytebrain-aks --node-count 5

# Enable cluster autoscaler
az aks update -g bytebrain-rg -n bytebrain-aks \
  --enable-cluster-autoscaling \
  --min-count 3 \
  --max-count 10
```

**CI/CD Integration**

Store Terraform in CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
- name: Terraform Init
  run: terraform init

- name: Terraform Validate
  run: terraform validate

- name: Terraform Plan
  run: terraform plan -out=tfplan

- name: Terraform Apply
  run: terraform apply tfplan
```

## Development Workflow

### 1. Feature Development

```bash
# Create feature branch
git checkout -b feature/feature-name

# Backend changes: test locally with docker-compose
docker-compose up -d

# Frontend changes: test in separate terminal
cd frontend && npm run dev

# Commit and push
git push origin feature/feature-name
```

### 2. Building & Pushing Backend to ACR

```bash
# Build backend image
docker build -t bytebrainacr.azurecr.io/bytebrain-backend:v1.0.0 ./backend

# Login to ACR
az acr login --name bytebrainacr

# Push to Azure Container Registry
docker push bytebrainacr.azurecr.io/bytebrain-backend:v1.0.0

# Verify in ACR
az acr repository list --name bytebrainacr
az acr repository show-tags --name bytebrainacr --repository bytebrain-backend
```

### 3. Deploying Backend to AKS

Update the Helm values or manifests with new image tags and deploy:

```bash
# Using Helm
helm upgrade bytebrain helm-chart/ -n bytebrain \
  --set backend.image.tag=v1.0.0

# Or update deployment manually
kubectl set image deployment/backend \
  backend=bytebrainacr.azurecr.io/bytebrain-backend:v1.0.0 \
  -n bytebrain
```

### 4. Deploying Frontend to Static Web Apps

```bash
# Commit frontend changes to main branch
git add frontend/
git commit -m "Update frontend"
git push origin main

# Static Web Apps automatically deploys via GitHub Actions
# Monitor deployment at: https://portal.azure.com

# Or manually deploy
cd frontend
npm run build
az staticwebapp deploy \
  --name bytebrain-frontend \
  --source-location ./dist
```

### 5. Monitoring & Debugging

```bash
# Check backend pod status
kubectl get pods -n bytebrain

# View backend logs
kubectl logs -f deployment/backend -n bytebrain

# Port forward for local testing
kubectl port-forward svc/backend 3000:3000 -n bytebrain

# Execute commands in backend pod
kubectl exec -it pod/backend-xxxxx -n bytebrain -- /bin/sh

# Check frontend deployment status
az staticwebapp show --name bytebrain-frontend --resource-group bytebrain-rg
```

## Technology Stack

### Backend

- **Runtime**: Node.js
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: MongoDB
- **Authentication**: JWT + bcrypt
- **Validation**: Zod
- **Process Manager**: PM2

### Frontend

- **Framework**: React 19
- **Build Tool**: Vite
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **UI Components**: Lucide React
- **Routing**: React Router
- **Forms**: React Hook Form
- **API Client**: Axios
- **Data Fetching**: TanStack Query
- **Notifications**: Sonner

### DevOps & Infrastructure

- **Containerization**: Docker
- **Orchestration**: Kubernetes (AKS)
- **Package Manager**: Helm
- **Infrastructure**: Terraform
- **Cloud Provider**: Azure
- **Database**: MongoDB Atlas
- **Cloud Services**:
  - Azure Kubernetes Service (AKS) - Backend API
  - Azure Container Registry (ACR) - Container images
  - Azure Key Vault - Secrets management
  - Azure Static Web Apps - Frontend hosting
  - MongoDB Atlas - Database (external)

## Environment Configuration

### Backend Environment Variables

| Variable            | Description                        | Example                                                 |
| ------------------- | ---------------------------------- | ------------------------------------------------------- |
| `PORT`              | API server port                    | `3000`                                                  |
| `NODE_ENV`          | Environment mode                   | `development`, `production`                             |
| `MONGODB_URI`       | MongoDB Atlas connection string    | `mongodb+srv://user:pass@cluster.mongodb.net/bytebrain` |
| `JWT_SECRET`        | JWT signing secret                 | `your-secret-key`                                       |
| `CORS_ORIGIN`       | CORS allowed origin                | `https://bytebrain-frontend.azurestaticapps.net`        |
| `KEY_VAULT_URI`     | Azure Key Vault URI                | `https://bytebrain-kv.vault.azure.net/`                 |
| `AZURE_CLIENT_ID`   | Azure AD client ID                 | Azure app registration ID                               |
| `MONGODB_ATLAS_URI` | MongoDB Atlas URI (from Key Vault) | Retrieved from Azure Key Vault at runtime               |

### Frontend Environment Variables

| Variable       | Description       | Example                                           |
| -------------- | ----------------- | ------------------------------------------------- |
| `NODE_ENV`     | Build environment | `development`, `production`                       |
| `VITE_API_URL` | Backend API URL   | `https://bytebrain-api.eastus.cloudapp.azure.com` |

## API Documentation

The backend provides a RESTful API. Key endpoints:

- `GET /health` - Health check
- `POST /auth/register` - User registration
- `POST /auth/login` - User login
- `GET /api/data` - Fetch data (requires auth)
- `POST /api/data` - Create data
- `PUT /api/data/:id` - Update data
- `DELETE /api/data/:id` - Delete data

For detailed API documentation, refer to the backend route definitions in [backend/src/routes/](./backend/src/routes/).

## Troubleshooting

### Docker Compose Issues

```bash
# View service logs
docker-compose logs [service-name]

# Rebuild containers
docker-compose down
docker-compose build --no-cache
docker-compose up

# Clean up all containers and volumes
docker-compose down -v
```

### Kubernetes Issues

```bash
# Check pod events
kubectl describe pod [pod-name] -n bytebrain

# View recent logs
kubectl logs --tail=100 -f deployment/backend -n bytebrain

# Check resource usage
kubectl top nodes
kubectl top pods -n bytebrain
```

### Database Connection Issues

- Verify MongoDB Atlas connection string in `MONGODB_URI` environment variable
- Check network connectivity: Ensure your IP is whitelisted in MongoDB Atlas security settings
- For local development: Use `mongodb://localhost:27017/bytebrain` if running local MongoDB
- For production: Use the connection string from MongoDB Atlas dashboard
- Verify credentials are correct: `mongodb+srv://username:password@cluster.mongodb.net/database`
- Check network policies if running in AKS: Ensure outbound connectivity to MongoDB Atlas

## Security Considerations

- **Secrets Management**: Use Azure Key Vault for sensitive data
- **Network Security**: Kubernetes Network Policies restrict traffic
- **Authentication**: JWT tokens for API security
- **Password Hashing**: bcrypt for user password storage
- **CORS**: Configured to allow only specified origins
- **Managed Identity**: Azure AD integration for pod authentication
- **Image Scanning**: Enable ACR image scanning for vulnerabilities

## Performance Optimization

- **Horizontal Pod Autoscaler**: Automatically scales backend pods based on CPU/memory
- **Database Indexing**: Optimize MongoDB queries with appropriate indexes
- **Frontend Caching**: Vite provides optimized production builds
- **CDN Integration**: Consider Azure Front Door for content delivery
- **Container Resource Limits**: Defined in Kubernetes manifests

---

**Last Updated**: August 2026
**Version**: 1.0.0
