#!/bin/bash
pgrep -f 'dashboard' | xargs -r kill
cd /home/zzzxxx/.nezha-dashboard
exec /home/zzzxxx/.nezha-dashboard/dashboard >/dev/null 2>&1
