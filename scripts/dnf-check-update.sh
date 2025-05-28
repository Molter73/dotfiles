#!/usr/bin/env bash

set -uo pipefail

UPDATES="$(dnf check-update --advisory-severities=critical | grep -cv "^No security updates")"
CLASS='""'
if ((UPDATES != 0)); then
    CLASS='"critical"'
else
    UPDATES="$(dnf check-update | wc -l)"
fi

if ((UPDATES != 0)); then
    UPDATES="\"${UPDATES} \""
else
    UPDATES=""
fi

jq -cMn \
    --argjson class "$CLASS" \
    --argjson text "$UPDATES" \
    '{text: $text, class: $class}'
