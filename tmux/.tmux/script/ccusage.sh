#!/usr/bin/env bash

# Check if ccusage is available
if ! command -v ccusage &>/dev/null; then
    exit 0
fi

# Get the total cost and round to 2 decimal places
cost=$(ccusage monthly --json 2>/dev/null | jq -r '.totals.totalCost' 2>/dev/null)

# Check if we got a valid number
# if [[ -n "$cost" && "$cost" != "null" ]]; then
#     printf "%.2f" "${cost}"
# fi
#

printf "%.2f" "${cost}"
