#!/bin/bash
# Demo script for recording FirePaste in action
# Requires: asciinema (https://asciinema.org/)
# Install: curl -o- https://raw.githubusercontent.com/asciinema/asciinema/develop/install.sh | bash

set -e

echo "🔥 FirePaste Demo Recording"
echo "==========================="
echo ""
echo "This script will:"
echo "1. Start the FirePaste stack"
echo "2. Record a terminal demo using asciinema"
echo "3. Convert to GIF (optional, requires agg or asciinema-gif)"
echo ""
read -p "Press Enter to start..."

# Ensure stack is running
echo "Starting FirePaste stack..."
docker compose up -d
sleep 5

echo "Recording demo..."
echo "Follow the prompts in the recording."
echo ""

# Record demo
asciinema rec demo.cast -c "bash scripts/demo_actions.sh" --overwrite

echo ""
echo "✅ Recording saved to demo.cast"
echo ""
echo "To convert to GIF:"
echo "  1. Using agg (recommended): cargo install agg && agg demo.cast demo.gif"
echo "  2. Using asciicast2gif: npm install -g asciicast2gif && asciicast2gif demo.cast demo.gif"
echo "  3. Using asciinema server: asciinema upload demo.cast"
echo ""
echo "For README, you can also use asciinema player embed:"
echo "  <script src=\"https://asciinema.org/a/YOUR_CAST_ID.js\" id=\"asciicast-YOUR_CAST_ID\" async></script>"
