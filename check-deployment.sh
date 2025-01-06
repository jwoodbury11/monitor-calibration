#!/bin/bash

echo "Checking deployment status..."
while true; do
    status=$(curl -s https://api.github.com/repos/jwoodbury11/monitor-calibration/deployments/latest | grep -o '"state": "[^"]*"' | cut -d'"' -f4)
    
    if [ "$status" = "success" ]; then
        echo "✅ Deployment complete!"
        osascript -e 'display notification "Your site changes are now live!" with title "Deployment Complete"'
        break
    elif [ "$status" = "failure" ]; then
        echo "❌ Deployment failed"
        osascript -e 'display notification "Deployment failed. Check GitHub Actions for details." with title "Deployment Failed"'
        break
    else
        echo "🟡 Deployment in progress..."
        sleep 5
    fi
done 