#!/usr/bin/env bash

set -uo pipefail

CRITICAL_UPDATES="$(dnf check-update --refresh --advisory-severities=critical --json | jq '.upgrades | length')"
UPDATES="$(dnf check-update --json | jq '.upgrades | length')"
CLASS='""'

if ((CRITICAL_UPDATES != 0)); then
    CLASS='"critical"'
    UPDATES="\"${CRITICAL_UPDATES} | ${UPDATES} \""
elif ((UPDATES != 0)); then
    UPDATES="\"${UPDATES} \""
else
    UPDATES=""
fi

jq -cMn \
    --argjson class "$CLASS" \
    --argjson text "$UPDATES" \
    '{text: $text, class: $class}'
