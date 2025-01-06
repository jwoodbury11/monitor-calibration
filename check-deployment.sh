#!/bin/bash

echo "Checking deployment status..."
initial_content=$(curl -s https://monitorcalibrationtool.com)
initial_hash=$(echo "$initial_content" | md5)
echo "Waiting for changes to go live..."

while true; do
    current_content=$(curl -s https://monitorcalibrationtool.com)
    current_hash=$(echo "$current_content" | md5)
    
    if [ "$current_hash" != "$initial_hash" ]; then
        echo "✅ Deployment complete!"
        osascript -e 'display notification "Your site changes are now live!" with title "Deployment Complete"'
        echo "Your site is live at: https://monitorcalibrationtool.com"
        break
    else
        echo "🟡 Deployment in progress..."
        sleep 5
    fi
done 