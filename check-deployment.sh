#!/bin/bash

echo "Checking deployment status..."

# Get initial state
initial_content=$(curl -s https://monitorcalibrationtool.com)
initial_hash=$(echo "$initial_content" | md5 -q)
echo "Initial hash: $initial_hash"
echo "Waiting for changes to go live..."

attempt=1
while true; do
    echo "Attempt $attempt..."
    current_content=$(curl -s https://monitorcalibrationtool.com)
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
    
    attempt=$((attempt + 1))
    sleep 5
done 