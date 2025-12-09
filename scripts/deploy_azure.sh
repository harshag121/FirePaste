#!/bin/bash
# Deploy FirePaste to Azure Container Apps

set -e

echo "🔥 FirePaste Azure Deployment"
echo "============================="
echo ""

# Check prerequisites
command -v az >/dev/null 2>&1 || { echo "❌ Azure CLI not installed. Run: curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "❌ Docker not installed."; exit 1; }

echo "✅ Prerequisites checked"
echo ""

# Check if logged in
if ! az account show >/dev/null 2>&1; then
    echo "Step 1: Azure Login"
    az login --use-device-code
else
    echo "✅ Already logged in to Azure"
fi

# Set subscription (optional)
CURRENT_SUB=$(az account show --query name -o tsv)
echo "Current subscription: $CURRENT_SUB"
read -p "Press Enter to continue or Ctrl+C to change subscription..."

echo ""
echo "Step 2: Creating Resource Group"
az group create --name rg-firepaste --location eastus || true

echo ""
echo "Step 3: Creating Azure Container Registry"
az acr create \
    --resource-group rg-firepaste \
    --name firepasteacr \
    --sku Basic \
    --admin-enabled true || true

echo ""
echo "Step 4: Building and Pushing Docker Image"
az acr build \
    --registry firepasteacr \
    --image firepaste:latest \
    --file Dockerfile \
    .

echo ""
echo "Step 5: Creating Redis Cache"
az redis create \
    --resource-group rg-firepaste \
    --name firepaste-redis \
    --location eastus \
    --sku Basic \
    --vm-size c0 || true

echo "Waiting for Redis to be ready..."
sleep 30

echo ""
echo "Step 6: Getting Redis Connection String"
REDIS_KEY=$(az redis list-keys --resource-group rg-firepaste --name firepaste-redis --query primaryKey -o tsv)
REDIS_HOST=$(az redis show --resource-group rg-firepaste --name firepaste-redis --query hostName -o tsv)
REDIS_ADDR="${REDIS_HOST}:6380"

echo ""
echo "Step 7: Creating Container App Environment"
az containerapp env create \
    --name firepaste-env \
    --resource-group rg-firepaste \
    --location eastus || true

echo ""
echo "Step 8: Deploying Container App"
az containerapp create \
    --name firepaste-app \
    --resource-group rg-firepaste \
    --environment firepaste-env \
    --image firepasteacr.azurecr.io/firepaste:latest \
    --target-port 8080 \
    --ingress external \
    --registry-server firepasteacr.azurecr.io \
    --registry-username firepasteacr \
    --registry-password $(az acr credential show --name firepasteacr --query passwords[0].value -o tsv) \
    --cpu 0.25 \
    --memory 0.5Gi \
    --min-replicas 0 \
    --max-replicas 2 \
    --env-vars "REDIS_ADDR=${REDIS_ADDR}" "PORT=8080" \
    --secrets "redis-password=${REDIS_KEY}" || \
az containerapp update \
    --name firepaste-app \
    --resource-group rg-firepaste \
    --image firepasteacr.azurecr.io/firepaste:latest

echo ""
echo "✅ Deployment Complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔥 Your FirePaste is live!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
APP_URL=$(az containerapp show --name firepaste-app --resource-group rg-firepaste --query properties.configuration.ingress.fqdn -o tsv)
echo "🌐 App URL: https://${APP_URL}"
echo ""
echo "View logs:"
echo "  az containerapp logs show --name firepaste-app --resource-group rg-firepaste --follow"
echo ""
echo "Monitor in Azure Portal:"
echo "  https://portal.azure.com"
echo ""
