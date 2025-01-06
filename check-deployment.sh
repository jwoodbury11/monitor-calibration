#!/bin/bash

echo "Checking deployment status..."

# Get initial state
initial_content=$(curl -s "https://monitorcalibrationtool.com?check=$(date +%s)")
initial_hash=$(echo "$initial_content" | md5 -q)
echo "Initial hash: $initial_hash"
echo "Waiting for changes to go live..."

attempt=1
while true; do
    echo "Attempt $attempt..."
    current_content=$(curl -s "https://monitorcalibrationtool.com?check=$(date +%s)")
    current_hash=$(echo "$current_content" | md5 -q)
    echo "Current hash: $current_hash"
    
    if [ "$current_hash" != "$initial_hash" ] && [ ! -z "$current_hash" ]; then
        echo "✅ Deployment complete!"
        osascript -e 'display notification "Your site changes are now live!" with title "Deployment Complete"'
        echo "Your site is live at: https://monitorcalibrationtool.com"
        break
    elif [ -z "$current_content" ]; then
        echo "⚠️  Warning: Could not reach the website. Retrying..."
    else
        echo "🟡 Deployment in progress..."
    fi
    
    # Exit after 10 minutes (120 attempts at 5 second intervals)
    if [ $attempt -ge 120 ]; then
        echo "⚠️  Timeout after 10 minutes. Please check GitHub Pages settings."
        exit 1
    fi
    
    attempt=$((attempt + 1))
    sleep 5
done 