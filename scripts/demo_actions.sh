#!/bin/bash
# Automated demo actions for asciinema recording

sleep 1
clear

echo "🔥 FirePaste - Ephemeral Pastebin Demo"
echo "======================================"
echo ""
sleep 2

echo "Step 1: Create a paste via curl"
echo "--------------------------------"
sleep 1

RESPONSE=$(curl -s -X POST http://localhost:80/paste \
  -d "content=Hello from FirePaste! This is a secret message." \
  -d "ttl=5m" \
  -d "burn=on" \
  -w "\nStatus: %{http_code}\nRedirect: %{redirect_url}" \
  2>&1 | head -5)

echo "$RESPONSE"
sleep 3

echo ""
echo "Step 2: Check Prometheus metrics"
echo "---------------------------------"
sleep 1
curl -s http://localhost:8080/metrics | grep firepaste_pastes_created_total
sleep 2

echo ""
echo ""
echo "Step 3: View Grafana dashboard"
echo "-------------------------------"
echo "Open http://localhost:3000 in your browser"
echo "(username: admin, password: admin)"
sleep 2

echo ""
echo ""
echo "Step 4: Test the paste"
echo "----------------------"
echo "Paste URL will auto-delete after first view (burn mode)"
sleep 2

echo ""
echo "✅ Demo complete! FirePaste is running."
echo ""
echo "Try it yourself:"
echo "  - Web UI: http://localhost:80"
echo "  - Grafana: http://localhost:3000"
echo "  - Prometheus: http://localhost:9090"
echo ""
