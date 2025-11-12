# 🚀 Azure Blue-Green Deployment with Terraform & GitHub Actions

This project implements a **Blue-Green deployment** strategy on **Microsoft Azure** using **Terraform** and **GitHub Actions**.  
It provisions Azure infrastructure, deploys containerized applications to two Virtual Machine Scale Sets (VMSS) — **Blue** and **Green** — and automates traffic switching using **Azure Application Gateway**.

---


---

## ⚙️ What This Project Does

1. **Builds and pushes** a container image to Azure Container Registry (ACR).
2. **Deploys** the new image to the *inactive* VMSS (e.g., deploy to Green if Blue is live).
3. **Runs health checks** to verify the new deployment.
4. **Swaps traffic** by updating Application Gateway to point to the new backend pool.
5. **(Optional)** Scales down the old VMSS or keeps it for rollback.

---

## 🧩 Components

| Component | Description |
|------------|-------------|
| **Azure VM Scale Set (Blue/Green)** | Hosts your containerized app. Each color represents a separate environment. |
| **Azure Application Gateway (AppGW)** | Routes external traffic to the active VMSS backend pool (Blue or Green). |
| **Azure Key Vault** | Stores TLS certificate used by the App Gateway. |
| **Azure PostgreSQL Flexible Server** | Example of a managed database resource. |
| **Azure Storage Account** | Hosts the remote Terraform state backend. |
| **GitHub Actions** | CI/CD pipeline for build, push, deploy, and traffic swap automation. |

---

## 🚦 Blue-Green Deployment Flow

1. **Blue is active** and receiving live traffic.
2. CI/CD builds a new Docker image and **deploys it to Green** (inactive environment).
3. **Health checks** validate the Green environment.
4. When successful, App Gateway rule is updated:

   ```bash
   az network application-gateway url-path-map rule update \
     --gateway-name myAppGw \
     --name rule1 \
     --resource-group prod-rg \
     --backend-pool-name pool-green

---

## 🔐 Prerequisites

Before running the pipeline:

Create an Azure Container Registry (ACR) and add credentials in GitHub secrets:

ACR_USERNAME

ACR_PASSWORD

Configure an Azure Service Principal or OIDC authentication in GitHub:

AZURE_CLIENT_ID

AZURE_TENANT_ID

AZURE_SUBSCRIPTION_ID

(or) AZURE_CREDENTIALS JSON

---

## 🧹 Cleanup

When finished:

   ```bash
   cd envs/prod
   terraform destroy
```
