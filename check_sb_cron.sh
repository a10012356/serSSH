#!/bin/bash

USERNAME=$(whoami)
#WORKDIR="/home/${USERNAME,,}/.nezha-agent"
WORKDIR="/home/${USERNAME,,}/logs"
CRON_NEZHA="nohup ${WORKDIR}/nezha.sh >/dev/null 2>&1 &"
CRON_SB="nohup ${WORKDIR}/web run -c config.json >/dev/null 2>&1 &"
PM2_PATH="/home/${USERNAME,,}/.npm-global/lib/node_modules/pm2/bin/pm2"
CRON_JOB="*/10 * * * * $PM2_PATH resurrect >> /home/$(whoami)/pm2_resurrect.log 2>&1"
REBOOT_COMMAND="@reboot pkill -kill -u $(whoami) && $PM2_PATH resurrect >> /home/$(whoami)/pm2_resurrect.log 2>&1"

echo "检查并添加 crontab 任务"

if [ "$(command -v pm2)" == "/home/${USERNAME,,}/.npm-global/bin/pm2" ]; then
  echo "已安装 pm2，并返回正确路径，启用 pm2 保活任务"
  (crontab -l | grep -F "$REBOOT_COMMAND") || (crontab -l; echo "$REBOOT_COMMAND") | crontab -
  (crontab -l | grep -F "$CRON_JOB") || (crontab -l; echo "$CRON_JOB") | crontab -
else
  if [ -e "${WORKDIR}/nezha.sh" ] && [ -e "${WORKDIR}/config.json" ]; then
    echo "添加 nezha & singbox 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA} && ${CRON_SB}") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA} && ${CRON_SB}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") || (crontab -l; echo "*/12 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"web\" > /dev/null || ${CRON_SB}") || (crontab -l; echo "*/12 * * * * pgrep -x \"web\" > /dev/null || ${CRON_SB}") | crontab -
  elif [ -e "${WORKDIR}/nezha.sh" ]; then
    echo "添加 nezha 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA}") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") || (crontab -l; echo "*/12 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") | crontab -
  elif [ -e "${WORKDIR}/config.json" ]; then
    echo "添加 singbox 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && ${CRON_SB}") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && ${CRON_SB}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"web\" > /dev/null || ${CRON_SB}") || (crontab -l; echo "*/12 * * * * pgrep -x \"web\" > /dev/null || ${CRON_SB}") | crontab -
  fi
fi
