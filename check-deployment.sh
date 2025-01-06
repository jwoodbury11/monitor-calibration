#!/bin/bash

echo "Checking deployment status..."
while true; do
    # Get the GitHub Pages deployment status
    response=$(curl -s "https://api.github.com/repos/jwoodbury11/monitor-calibration/pages/builds/latest")
    status=$(echo "$response" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
    
    echo "Debug - Raw response: $response"
    echo "Debug - Current status: $status"
    
    if [ "$status" = "built" ]; then
        echo "✅ Deployment complete!"
        osascript -e 'display notification "Your site changes are now live!" with title "Deployment Complete"'
        echo "Your site is live at: https://monitorcalibrationtool.com"
        break
    elif [ "$status" = "errored" ]; then
        echo "❌ Deployment failed"
        osascript -e 'display notification "Deployment failed. Check GitHub Pages settings." with title "Deployment Failed"'
        break
    else
        echo "🟡 Deployment in progress..."
        sleep 5
    fi
done 