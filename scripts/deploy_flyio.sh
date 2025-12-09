#!/bin/bash
# Quick deploy to Fly.io (free tier)

set -e

echo "🔥 Deploying FirePaste to Fly.io"
echo "================================"

# Check if flyctl is installed
if ! command -v flyctl &> /dev/null; then
    echo "Installing Fly.io CLI..."
    curl -L https://fly.io/install.sh | sh
    export PATH="$HOME/.fly/bin:$PATH"
fi

echo ""
echo "Step 1: Login to Fly.io"
flyctl auth login

echo ""
echo "Step 2: Create Redis instance (free tier)"
flyctl redis create firepaste-redis --region ewr --no-replicas

echo ""
echo "Step 3: Launch app"
flyctl launch --name firepaste --region ewr --copy-config --yes

echo ""
echo "Step 4: Set Redis connection"
REDIS_URL=$(flyctl redis status firepaste-redis -j | jq -r .PrivateURL)
flyctl secrets set REDIS_ADDR="$REDIS_URL"

echo ""
echo "Step 5: Deploy"
flyctl deploy

echo ""
echo "✅ Deployment complete!"
echo ""
flyctl status
echo ""
echo "Your app is live at: https://firepaste.fly.dev"
