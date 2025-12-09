# Azure Deployment Guide for FirePaste

## 🚀 Deploy FirePaste to Azure Container Apps

FirePaste can be deployed to Azure using **Azure Container Apps** with **Azure Cache for Redis**. This setup provides a serverless, scalable deployment with zero cold starts for active apps.

---

## 💰 Estimated Cost

| Service | Tier | Monthly Cost |
|---------|------|--------------|
| Azure Container Apps | 180k vCPU-seconds, 360k GiB-seconds free | **$0 - $15** |
| Azure Cache for Redis | Basic C0 (250MB) | **~$16** |
| Azure Container Registry | Basic (10 GB storage) | **~$5** |
| **Total** | | **~$21/month** |

> 💡 First-time Azure users get **$200 free credits** for 30 days!

---

## 📋 Prerequisites

1. **Azure Account** - [Sign up for free](https://azure.microsoft.com/free/)
2. **Azure CLI** - [Install](https://docs.microsoft.com/cli/azure/install-azure-cli)
3. **Terraform** - [Install](https://www.terraform.io/downloads)
4. **Docker** - [Install](https://docs.docker.com/get-docker/)

---

## 🔧 Option 1: Automated Deployment (Recommended)

### Step 1: Clone the Repository
```bash
git clone https://github.com/harshag121/FirePaste.git
cd FirePaste
```

### Step 2: Run Deployment Script
```bash
./scripts/deploy_azure.sh
```

The script will:
- ✅ Check prerequisites
- ✅ Login to Azure
- ✅ Build Docker image
- ✅ Create infrastructure (Redis, Container Registry, Container App)
- ✅ Push image to Azure Container Registry
- ✅ Deploy the application

### Step 3: Access Your App
After deployment completes, your app URL will be displayed:
```
https://firepaste-app.happypond-12345678.eastus.azurecontainerapps.io
```

---

## 🔧 Option 2: Manual Deployment

### Step 1: Login to Azure
```bash
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### Step 2: Deploy Infrastructure
```bash
cd deploy
terraform init
terraform plan -out=azure.tfplan
terraform apply azure.tfplan
```

### Step 3: Build and Push Docker Image
```bash
# Get ACR credentials
ACR_NAME=$(terraform output -raw container_registry | cut -d'.' -f1)
ACR_SERVER=$(terraform output -raw container_registry)

# Login to ACR
az acr login --name $ACR_NAME

# Build and push
docker build -t firepaste:latest .
docker tag firepaste:latest $ACR_SERVER/firepaste:latest
docker push $ACR_SERVER/firepaste:latest
```

### Step 4: Update Container App
```bash
az containerapp update \
    --name firepaste-app \
    --resource-group rg-firepaste \
    --image $ACR_SERVER/firepaste:latest
```

---

## 🔍 Monitoring & Management

### View Logs
```bash
az containerapp logs show \
    --name firepaste-app \
    --resource-group rg-firepaste \
    --follow
```

### View Metrics
Visit the Azure Portal:
```
https://portal.azure.com
```

Navigate to: `Resource Groups > rg-firepaste > firepaste-app`

### Scale Application
```bash
az containerapp update \
    --name firepaste-app \
    --resource-group rg-firepaste \
    --min-replicas 1 \
    --max-replicas 5
```

---

## 🔒 Security Best Practices

### 1. Enable HTTPS Only
Azure Container Apps automatically provides HTTPS endpoints.

### 2. Configure Redis SSL
The deployment uses Redis over SSL by default (`ssl_port`).

### 3. Use Managed Identity (Advanced)
```bash
az containerapp identity assign \
    --name firepaste-app \
    --resource-group rg-firepaste \
    --system-assigned
```

### 4. Configure Rate Limiting
The Caddy reverse proxy in the container handles rate limiting (100 req/min).

---

## 🎛️ Configuration Options

### Environment Variables

Edit `deploy/azure.tf` to add environment variables:

```hcl
env {
  name  = "MAX_PASTE_SIZE"
  value = "1048576"  # 1MB
}

env {
  name  = "DEFAULT_TTL"
  value = "24h"
}
```

### Custom Domain

1. **Add custom domain:**
```bash
az containerapp hostname add \
    --hostname "paste.yourdomain.com" \
    --resource-group rg-firepaste \
    --name firepaste-app
```

2. **Add DNS record:**
```
CNAME paste -> firepaste-app.happypond-12345678.eastus.azurecontainerapps.io
```

---

## 🧹 Cleanup

To delete all resources and stop billing:

```bash
cd deploy
terraform destroy
```

Or via Azure CLI:
```bash
az group delete --name rg-firepaste --yes
```

---

## 📊 Cost Optimization Tips

1. **Set Min Replicas to 0** - Scale to zero when not in use
2. **Use Basic Redis Tier** - Sufficient for demos/low traffic
3. **Enable Consumption Plan** - Pay only for what you use
4. **Monitor usage** - Set up billing alerts in Azure Portal

---

## 🐛 Troubleshooting

### Issue: Container fails to start
**Solution:** Check logs
```bash
az containerapp logs show --name firepaste-app --resource-group rg-firepaste --follow
```

### Issue: Can't connect to Redis
**Solution:** Verify Redis connection string
```bash
az redis show --name firepaste-redis --resource-group rg-firepaste
```

### Issue: Image push fails
**Solution:** Re-authenticate to ACR
```bash
az acr login --name firepasteacr
```

---

## 🚀 Advanced: CI/CD with GitHub Actions

Add to `.github/workflows/azure-deploy.yml`:

```yaml
name: Deploy to Azure

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
      - name: Build and Push
        run: |
          az acr build --registry firepasteacr \
            --image firepaste:latest .
      
      - name: Deploy to Container App
        run: |
          az containerapp update \
            --name firepaste-app \
            --resource-group rg-firepaste \
            --image firepasteacr.azurecr.io/firepaste:latest
```

---

## 📚 Additional Resources

- [Azure Container Apps Docs](https://docs.microsoft.com/azure/container-apps/)
- [Azure Cache for Redis](https://docs.microsoft.com/azure/azure-cache-for-redis/)
- [Azure Container Registry](https://docs.microsoft.com/azure/container-registry/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

---

## 💬 Support

- **Issues**: [GitHub Issues](https://github.com/harshag121/FirePaste/issues)
- **Docs**: [Main README](../README.md)
- **Azure Support**: [Azure Portal](https://portal.azure.com)

---

**Happy Deploying! 🔥**
