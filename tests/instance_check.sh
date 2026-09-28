#!/bin/bash

for i in {1..30}; do
    if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -i ~/.ssh/ssh_key $INSTANCE_USER@$HOST "echo ready" 2>/dev/null; then
        echo "Instance is ready"
        break
    fi
    echo "Waiting for instance... attempt $i"
    sleep 10
done
