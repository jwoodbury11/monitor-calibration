#!/bin/bash

echo "Checking deployment status..."
while true; do
    # Get the latest workflow run status
    response=$(curl -s "https://api.github.com/repos/jwoodbury11/monitor-calibration/actions/runs?per_page=1")
    status=$(echo "$response" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
    conclusion=$(echo "$response" | grep -o '"conclusion":"[^"]*"' | head -1 | cut -d'"' -f4)
    
    echo "Debug - Current status: $status"
    echo "Debug - Current conclusion: $conclusion"
    
    if [ "$status" = "completed" ] && [ "$conclusion" = "success" ]; then
        echo "✅ Deployment complete!"
        osascript -e 'display notification "Your site changes are now live!" with title "Deployment Complete"'
        echo "Your site is live at: https://monitorcalibrationtool.com"
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