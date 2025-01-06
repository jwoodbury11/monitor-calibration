#!/bin/bash

echo "🔍 Starting continuous deployment monitor..."
echo "Press Ctrl+C to stop monitoring"

last_hash=""
changes_detected=0

while true; do
    current_content=$(curl -s "https://monitorcalibrationtool.com?check=$(date +%s)")
    current_hash=$(echo "$current_content" | md5 -q)
    
    if [ -z "$last_hash" ]; then
        last_hash=$current_hash
        echo "📡 Monitoring site: https://monitorcalibrationtool.com"
        echo "Initial hash: $current_hash"
    elif [ "$current_hash" != "$last_hash" ]; then
        changes_detected=$((changes_detected + 1))
        echo "✨ Change detected! ($changes_detected changes so far)"
        echo "Previous hash: $last_hash"
        echo "New hash: $current_hash"
        osascript -e 'display notification "New changes are live on your site!" with title "Site Updated"'
        last_hash=$current_hash
    else
        echo "👀 Checking for changes... (Last update: $(date '+%H:%M:%S'))"
    fi
    
    sleep 5
done 