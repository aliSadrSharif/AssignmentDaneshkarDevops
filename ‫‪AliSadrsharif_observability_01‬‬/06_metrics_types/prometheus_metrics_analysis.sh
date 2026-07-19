#!/bin/bash

# Variables
FILE="prometheus_metrics_analysis.txt"

# List metrics
echo -e "### List metrics ###\n" > $FILE
curl -s http://localhost:9090/metrics | head -30 >> $FILE

# Response specific metric
echo -e "\n### Response specific metric ###\n" >> $FILE
curl -s 'http://localhost:9090/api/v1/query?query=prometheus_tsdb_head_samples' | jq >> $FILE

# Response type with metric
echo -e "\n### Response type with metric ###\n" >> $FILE
curl -s http://localhost:9090/api/v1/targets | jq `.data.activeTargets[]` >> $FILE