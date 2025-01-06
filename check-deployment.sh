#!/bin/bash

echo "Checking deployment status..."
while true; do
    # Get the latest workflow run status
    status=$(curl -s "https://api.github.com/repos/jwoodbury11/monitor-calibration/actions/runs?per_page=1" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
    conclusion=$(curl -s "https://api.github.com/repos/jwoodbury11/monitor-calibration/actions/runs?per_page=1" | grep -o '"conclusion":"[^"]*"' | head -1 | cut -d'"' -f4)
    
    if [ "$status" = "completed" ] && [ "$conclusion" = "success" ]; then
        echo "✅ Deployment complete!"
        osascript -e 'display notification "Your site changes are now live!" with title "Deployment Complete"'
        break
    elif [ "$status" = "completed" ] && [ "$conclusion" = "failure" ]; then
        echo "❌ Deployment failed"
        osascript -e 'display notification "Deployment failed. Check GitHub Actions for details." with title "Deployment Failed"'
        break
    else
        echo "🟡 Deployment in progress..."
        sleep 5
    fi
done 